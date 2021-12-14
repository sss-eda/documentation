# Systems check
Check the following at least once every day to ensure that the radar is working properly:
- Navigate to `/data/ros/fitacf/` and confirm that the latest data file is growing.
- Run the command: `screen -x`. Verify that the radar software is running.
- Use SCP and log into the SANRAD server. Make sure that the previous day's data transferred correctly. The transfer script is located at `/home/radar/transfer_data/script/sanrad_new`.
- The size of daily data files can vary, but should be between 10MB and 20MB, more or less. Very small data files might be a sign that the radar is running at low power.-
