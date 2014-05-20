torque_internal_csv2gpx
=======================

Perl script to convert from internal Torque for Android logs (http://torque-bhp.com/ | https://play.google.com/store/apps/details?id=org.prowl.torque), the files .torque/tripLogs/*/trackLog.csv to gpx.

Usage:
perl torque_internal_csv2gpx.pl tackLog.csv

It will write a file Torque-${start_time}_${end_time}.gpx like: Torque-20130724-124917_20130724-133218.gpx
