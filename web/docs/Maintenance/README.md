# Maintenance

## Climbing
All instructions related to climbing (working at heights).

## Logging
A logging system for all of the instruments on base was implemented in 2018. The logging scripts and data can be found on the data server. Any activities or disturbances to any of the instruments should be logged using this system.

Data that is entered using the logging script is synced with the instrument PC as well as being fed into the influxDB database. From there the log entries can then be displayed live on the Grafana dashboards and read into the monthly reports automatically.

In case an entry needs to be deleted, a separate script needs to be run. This script will then delete the entry from the data server, instrument PC and the influxDB database. This section provides detailed instructions for logging entries, deleting entries and adding new systems.