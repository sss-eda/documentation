#!/usr/bin/env python3

import pandas as pd
import datetime as dt
import os
import matplotlib.pyplot as plt
import re


def extract_high(
    filename: str
) -> bytes:
    os.system("/home/sansa/rio1/decode_sci11/decode_sci -c 2 " + filename)

    with open(filename + ".txt", '+br') as file:
        data = file.read()

    return data


def extract_sec(
    filename: str
) -> bytes:
    with open(filename, '+br') as file:
        data = file.read()

    return data


def transform_high(
    data: bytes,
    datetime: dt.datetime
) -> pd.DataFrame:
    fields = [
        'channel_1',
        'channel_2'
    ]

    regex = (
        r'^(?P<hour>[0-9]{2}):' +
        r'(?P<minute>[0-9]{2}):' +
        r'(?P<second>[0-9]{2})\.' +
        r'(?P<milisecond>[0-9]{3}),' +
        r'(?P<' + fields[0] + r'>(\+|-)[0-9]{6}),' +
        r'(?P<' + fields[1] + r'>(\+|-)[0-9]{6})$'
    )
    pattern = re.compile(regex)

    df_index = []
    df_data = []

    lines = data.decode('utf8').splitlines()
    for line in lines:
        matched = pattern.match(line)
        if matched:
            d = matched.groupdict()
            timestamp = dt.datetime(
                year=int(datetime.year),
                month=int(datetime.month),
                day=int(datetime.day),
                hour=int(d['hour']),
                minute=int(d['minute']),
                second=int(d['second']),
                microsecond=int(d['milisecond']) * 1000
            )
            df_index.append(timestamp)
            df_data.append([
                float(d[fields[0]]),
                float(d[fields[1]])
            ])

    dataframe = pd.DataFrame(
        data=df_data,
        index=df_index,
        columns=fields
    )

    return dataframe


def transform_sec(
    data: bytes
) -> pd.DataFrame:
    fields = [
        'tacc',
        'valid',
        'channel_1',
        'channel_2'
    ]

    regex = (
        r'^(?P<year>[0-9]{4})/' +
        r'(?P<month>[0-9]{2})/' +
        r'(?P<day>[0-9]{2})\s' +
        r'(?P<hour>[0-9]{2}):' +
        r'(?P<minute>[0-9]{2}):' +
        r'(?P<second>[0-9]{2}),\s*' +
        r'(?P<' + fields[0] + r'>[0-9]+),\s*' +
        r'(?P<' + fields[1] + r'>[0-9]+),\s*' +
        r'(?P<' + fields[2] + r'>(\+|-)[0-9]+),\s*' +
        r'(?P<' + fields[3] + r'>(\+|-)[0-9]+)$'
    )
    pattern = re.compile(regex)

    df_index = []
    df_data = []

    lines = data.decode('utf8').splitlines()
    for line in lines:
        matched = pattern.match(line)
        if matched:
            d = matched.groupdict()
            timestamp = dt.datetime(
                year=int(d['year']),
                month=int(d['month']),
                day=int(d['day']),
                hour=int(d['hour']),
                minute=int(d['minute']),
                second=int(d['second'])
            )
            df_index.append(timestamp)
            df_data.append([
                int(d[fields[0]]),
                int(d[fields[1]]),
                int(d[fields[2]]),
                int(d[fields[3]])
            ])

    dataframe = pd.DataFrame(
        data=df_data,
        index=df_index,
        columns=fields
    )

    return dataframe


def load(
    dataframe: pd.DataFrame
) -> bool:
    return True


def main():
    d = dt.datetime.now() - dt.timedelta(0)

    f = d.strftime(
        format="/data/MARRIO1/SEC/%Y/%m/%d/%Y%m%d.sec",
    )

    e = extract_sec(
        filename=f
    )
    t = transform_sec(
        data=e
    )
    l = load(
        dataframe=t
    )

    print(l)

    t.plot()
    plt.savefig(f + ".png")


if __name__ == "__main__":
    main()
