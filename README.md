torque_internal_csv2gpx
=======================

Perl script to convert from internal Torque for Android logs (http://torque-bhp.com/ | https://play.google.com/store/apps/details?id=org.prowl.torque), the files .torque/tripLogs/*/trackLog.csv to gpx.

Usage:
perl torque_internal_csv2gpx.pl tackLog.csv

It will write a file Torque-${start_time}_${end_time}.gpx like: Torque-20130526-132712_20130526-134444.gpx

Fragment:

```XML
<?xml version="1.0" encoding="utf-8"?>
<gpx xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" creator="Geo::Gpx" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd" xmlns="http://www.topografix.com/GPX/1/0">
<time>2014-05-13T16:27:16Z</time>
<bounds maxlat="41.57722800504416" maxlon="-0.5878916631314471" minlat="41.4987563341856" minlon="-0.7572012674063444" />
<trk>
<desc>GPX converted from internal CSV data of Torque for Android</desc>
<name>Track 20130526-132712 - 20130526-134444</name>
<trkseg>
[...]
<trkpt lat="41.568871163763106" lon="-0.747798616066575">
<course>119.0</course>
<ele>245.4000244140625</ele>
<extensions>
<Bearing>119.0</Bearing>
<CO2>121.02799225</CO2>
<CO2Average>371.61373901</CO2Average>
<DeviceTime>26-may-2013 13:29:24.099</DeviceTime>
<EngineLoad>58.8235321</EngineLoad>
<EngineRPM>2485</EngineRPM>
<FuelFlowRate>77.78768921</FuelFlowRate>
<GPSSpeed>103.807976</GPSSpeed>
<GPSTime>Sun May 26 13:29:22 CEST 2013</GPSTime>
<GravityX>0.064453125</GravityX>
<GravityY>0.9121094</GravityY>
<GravityZ>0.30673826</GravityZ>
<IntakeAirTemperatureF>75.19999886</IntakeAirTemperatureF>
<LitresPer100Kilometer>4.5757308</LitresPer100Kilometer>
<LitresPer100KilometerLongTermAverage>8.09557724</LitresPer100KilometerLongTermAverage>
<MilesPerGallon>61.7344017</MilesPerGallon>
<SpeedOBD>102</SpeedOBD>
</extensions>
<hdop>5.0</hdop>
<speed>28.3333333333333</speed>
<time>2013-05-26T13:29:22Z</time>
</trkpt>
[...]
</trkseg>
</trk>
</gpx>
```

