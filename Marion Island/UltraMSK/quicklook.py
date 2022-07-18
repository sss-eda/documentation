#!/usr/bin/env python3

# IMPORTS
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import re
import argparse
# import glob
# import os.path
# import sys


# Let's define a few constants
width = 10
height = 8


def plot(dataframe, title):
    """
    Plot each variable in a dataframe on its own axis

    :param dataframe: Dataframe [pandas.DataFrame]
    :param title: Title of plot and base name of png file [str]
    """

    fields = dataframe.columns
    field_count = len(fields)

    # plot data
    # make figure
    fig = plt.figure(figsize=(width, height))

    axes = []
    i = 0
    for i in range(field_count):
        if i == 0:
            axes.append(fig.add_subplot(field_count, 1, i + 1))
        else:
            axes.append(fig.add_subplot(field_count, 1, i + 1, sharex=axes[0]))

        dataframe[fields[i]].plot(ax=axes[i], label=fields[i])

        # make grid for each axis
        # axes[i].grid(which="both")
        axes[i].grid()

        # set the lables
        axes[i].set_ylabel(fields[i])

    axes[i].set_xlabel("time")

    # make a figure title
    axes[0].set_title(title)
    fig.subplots_adjust(hspace=0.0)
    fig.tight_layout()

    # filename = title + ".png"

    # print("Saving figure at:\n %s" % filename)
    # fig.savefig(filename)
    # plt.close()

    return fig


def msk_plotfile(source, destination):
    """
    Plot a single file. The date is read from the file name (assuming %Y%m%d
    format) and passed to msk_process() which creates the dataframe from the
    5-column array.

    :param source: Path to the file to be plotted [str]
    :param destination: Path to the desitnation for the plot [str]
    """

    # split off the file name from the full path
    path = source[:source.rfind("/") + 1]
    base = source[source.rfind("/") + 1:]

    print("Reading file %s " % source)

    # test file extension
    if base[-4:] == ".bin":
        header, data = msk_read_bin(source)
    elif base[-4:] == ".txt":
        data = np.genfromtxt(source, comments="%")
    else:
        raise Exception("Error: Input file extension must be '.bin' or '.txt'")

    # create figure file name
    title = base[:-4]

    # find date in the file name
    date_match = re.findall("[0-9]{8}", base)
    if len(date_match) > 0:
        # use date to specify start time
        msk_df = msk_process(data, t_start=date_match[0])
        fig = plot(msk_df[["ampH", "phsH"]], title)
    else:
        # if no date found then process without a start time
        msk_df = msk_process(data, t_start=None)
        fig = plot(msk_df[["ampH", "phsH"]], title)

    if title[:-1] != "/":
        filename = destination + "/" + title + ".png"
    else:
        filename = destination + title + ".png"

    print("Saving figure at:\n %s" % filename)
    fig.savefig(filename)
    plt.close()

    return


# def msk_quicklook(
#     date_str="20200101",
#     frequency="23.40",
#     station="mar",
#     orientation="ns"
# ):
    
#     # Quicklook plot of a specific transmitter on specific loop on a specific
#     # date.

#     # :param date_str: Date string in %Y%m%d format [str]
#     # :param frq: Transmitter frequency in ff.ff format [str]
#     # :param stn: Receiver station three-letter code [str]
#     # :param orn: Loop orientation in two-letter code format [str]
#     # :param file_name_convention: Choose between the two filename conventions
#     # for .bin files.
#     # :return:
    

#     # definitions
#     msk_data_dir = "/data/MARMSK1/" + date_str[:4] + "/" + date_str[4:6] \
#         + "/" + date_str[6:8]

#     filename = "_".join([frequency, orientation, station, date_str]).upper() \
#         + ".txt"

#     print(msk_data_dir + "/" + filename)
#     header, data = msk_read_txt(msk_data_dir + "/" + filename)
#     # print(data.shape)

#     # process data in to dataframe
#     msk_df = msk_process(data, t_start=None)

#     # plot data
#     fig = plot(msk_df[["ampH", "phsH"]], fig_title=filename)

#     return 999


def msk_phase(x, y, unwrap=True):
    """
    Calculates phase from orthogonal signals using arctan function.

    """

    # caculate phase
    phs = np.arctan2(y, x)

    # generate x-axis for phase
    x1 = np.arange(0, len(phs))

    # interpolate at these points
    z = np.interp(x1, x1, phs)

    # 'unwrap' changes phase (z) to its 2*pi compliment, when a discontinuity
    # greater than pi is observed

    if unwrap:
        # unwrap and convert to degrees
        z1 = np.unwrap(z)*180/np.pi
    else:
        # No unwrap
        z1 = z*180/np.pi

    # identify nan's
    i = np.isnan(phs)
    z1[i] = np.nan

    return z1


def msk_read_bin(baseame, ncol=5):
    """
    Read binary MSK file. This won't be necessary after the switch to text
    format.
    """
    import struct

    try:
        fid = open(baseame, mode='rb')
    except:
        print('ERROR: file %s not found' % baseame)
        hdrError = 'FILE DOES NOT EXIST'
        return hdrError, None

    hdr = []
    data = []

    for i in range(10):
        hdr.append(fid.readline(40))

    # read 4 bytes
    s = fid.read(4)
    nBytesRead = 0

    # read until the length of s is not 4, i.e. EOF reached
    while len(s) == 4:
        nBytesRead += 4
        # unpack into data a little-endian (the '<') float
        data.append(struct.unpack("<f", s)[0])
        s = fid.read(4)

    # close the file
    fid.close()
    print('%d Bytes read from file %s' % (nBytesRead, baseame))

    # output data
    data = np.array(data)
    data_cols = np.array(data.reshape(int(len(data) / ncol), ncol))

    return hdr, data_cols


def seconds_to_datetime(seclist, t0):
    """
    Add an array of seconds `seclist` to a timestamp `t0`.

    :param seclist: List or array of seconds
    :param t0: Starting timestamp
    :return t: List of timestamps
    """

    t = []

    for s in seclist:
        t.append(t0 + pd.Timedelta(seconds=s))

    return t


def msk_process(data, t_start=None, unwrap=False):
    """
    Process the single-column array returned by msk_read_bin to create a
    Pandas DataFrame.

    :type data: Single column array as read from binary msk files
    :param t_start: Start date of the data [str]. If not specified, seconds of
    the day are used for timestamp
    :param unwrap: Unwrap the phase or leave as is? [boolean]
    :return: msk_df: Pandas DataFrame with one time-based index, six variables
    (three phase, three amplitude).
    """

    N = len(data[:, 0])

    if t_start is None:
        t = data[:, 0]
    else:
        print('Setting start date to: ')
        print(t_start)
        t0 = pd.datetime.strptime(t_start, '%Y%m%d')
        # make timeseries of N datapoints at 1-sec intervals
        # t = pd.date_range(start=t0, periods=N, freq='S')
        t = seconds_to_datetime(data[:, 0], t0)

    # create pandas structure
    df = pd.DataFrame(data=data[:, 1:],
                      index=t,
                      columns=['xh', 'yh', 'xl', 'yl'])

    # get mean x and y
    x = (df.xl.values + df.xh.values) / 2
    y = (df.yl.values + df.yh.values) / 2

    # calculate high and low amplitudes
    df['ampH'] = 10 * np.log10(df.xh.values ** 2 + df.yh.values ** 2)
    df['ampL'] = 10 * np.log10(df.xl.values ** 2 + df.yl.values ** 2)
    df['ampM'] = 10 * np.log10(x ** 2 + y ** 2)

    # calculate phase
    df['phsH'] = msk_phase(df.xh.values, df.yh.values, unwrap=unwrap)
    df['phsL'] = msk_phase(df.xl.values, df.yl.values, unwrap=unwrap)

    # calculate phase from H, L X and Y
    df['phsM'] = msk_phase(x, y, unwrap=unwrap)

    # mask 0's with NAN
    df = df.mask(df == 0)

    return df


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Saves a quicklook plot " +
        "of a file in the specified destination")
    parser.add_argument(
        "source",
        type=str,
        help="the source file, binary or text UltraMSK data"
    )
    parser.add_argument(
        "destination",
        type=str,
        help="the destination where quicklook needs to be saved"
    )

    args = parser.parse_args()

    msk_plotfile(args.source, args.destination)