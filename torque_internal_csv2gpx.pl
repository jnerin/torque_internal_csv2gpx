#!/usr/bin/perl
#
# BIG FAT WARNING:
# from .torque/tripLogs/Readme.txt:
#
# Trip Log Files Readme
# ===================
# 
#  Please note that the automatic trip logging files are designed for internal use by the app.  
# 
# The units in these files are specifically set and are converted on-the-fly to the users preferred units within Torque when the file is viewed
# 
# I developed this tool to convert _my_ tripLogs to GPX, as it's cumbersome to convert triplogs inside Torque
# Note that my phone Device Time strings are in es_ES, and that the fields in the output are the one _I_ choose in Torque to log, so you'll almost probably have to adapt those things
# 
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.


use strict;

use Text::CSV::Simple;
use Geo::Gpx;
use Time::Piece;
use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::ISO8601;

use Data::Dumper;

my $datafile = $ARGV[0];

my $gpx = Geo::Gpx->new();

my $parser = Text::CSV::Simple->new;

# First line of each .torque/tripLogs/*/trackLog.csv
# GPS Time, Device Time, Longitude, Latitude,GPS Speed(km/h), Horizontal Dilution of Precision, Altitude(m), Bearing, Gravity X(G), Gravity Y(G), Gravity Z(G),Engine RPM(rpm),Litres Per 100 Kilometer(l/100km),Speed (OBD)(km/h),Intake Air Temperature(°F),Engine Load(%),Litres Per 100 Kilometer(Long Term Average)(l/100km),Fuel flow rate/minute(cc/min),Miles Per Gallon(Long Term Average)(mpg),CO₂ in g/km (Average)(g/km),CO₂ in g/km (Instantaneous)(g/km),Miles Per Gallon(Instant)(mpg)

# FIXME: Are those your fields?
$parser->field_map(qw/GPSTime DeviceTime Longitude Latitude GPSSpeed HDOP Altitude Bearing GravityX GravityY GravityZ EngineRPM LitresPer100Kilometer SpeedOBD IntakeAirTemperatureF EngineLoad LitresPer100KilometerLongTermAverage FuelFlowRate MilesPerGallonLongTermAverage CO2Average CO2 MilesPerGallon/);

my @data = $parser->read_file($datafile);


# Sun May 11 19:55:02 CEST 2014
# Mon Jan 09 16:25:07 GMT+01:00 2012
# Mon Apr 23 12:48:48 GMT+02:00 2012
my $dateparser = DateTime::Format::Strptime->new(
  pattern => '%a %b %d %T %Z %Y',
  time_zone => 'GMT',
  on_error => 'croak',
  locale => 'en_EN'
);

# FIXME: Is this your format?
# 11-may-2014 19:55:03.905
# 09-ene-2012 16:25:09.590
# 23-abr-2012 12:48:51.605
my $dateparser_devicetime = DateTime::Format::Strptime->new(
  pattern => '%d-%b-%Y %T.',
  time_zone => 'GMT',
  on_error => 'croak',
  locale => 'es_ES'
);

#print STDERR "Working with $datafile\n";
my $start_time = $dateparser_devicetime->parse_datetime(@data[0]->{'DeviceTime'})->strftime('%Y%m%d-%H%M%S');
my $end_time = $dateparser_devicetime->parse_datetime(@data[$#data]->{'DeviceTime'})->strftime('%Y%m%d-%H%M%S');


# FIXME: Check the fields up there in $parser->field_map
my @points = map { { 
'lat' 	=> $_->{'Latitude'},
'lon' 	=> $_->{'Longitude'},
'ele' 	=> $_->{'Altitude'},
'hdop' 	=> $_->{'HDOP'},
'time'	=> $dateparser->parse_datetime($_->{'GPSTime'})->epoch(),
'course'=> $_->{'Bearing'}, # gpsbabel
# Choose speed, either GPSSpeed or SpeedOBD:
#'speed'	=> ($_->{'GPSSpeed'}/3.6),   # km/h -> m/s (gpsbabel)
'speed'	=> ($_->{'SpeedOBD'}/3.6),   # km/h -> m/s (gpsbabel)
'extensions' => { # extensions is a way to drop random tags so they don't get lost but that won't be interpreted
'GPSTime'	=> $_->{'GPSTime'},
'DeviceTime'	=> $_->{'DeviceTime'},
'GPSSpeed'	=> $_->{'GPSSpeed'},
'SpeedOBD'	=> $_->{'SpeedOBD'},
'Bearing'	=> $_->{'Bearing'},
'GravityX'	=> $_->{'GravityX'},
'GravityY'	=> $_->{'GravityY'},
'GravityZ'	=> $_->{'GravityZ'},
'EngineRPM'	=> $_->{'EngineRPM'},
'EngineLoad'	=> $_->{'EngineLoad'},
'FuelFlowRate'	=> $_->{'FuelFlowRate'},
'CO2Average'	=> $_->{'CO2Average'},
'CO2'		=> $_->{'CO2'},
'LitresPer100Kilometer'	=> $_->{'LitresPer100Kilometer'},
'IntakeAirTemperatureF'	=> $_->{'IntakeAirTemperatureF'},
'MilesPerGallon'	=> $_->{'MilesPerGallon'},
'MilesPerGallonLongTermAverage'	=> $_->{'MilesPerGallonLongTermAverage'},
'LitresPer100KilometerLongTermAverage'	=> $_->{'LitresPer100KilometerLongTermAverage'},
}
} } @data;

$gpx->tracks( [ {
'name' => "Track $start_time - $end_time", 
'desc' => 'GPX converted from internal CSV data of Torque for Android', # Start time - End time
'segments' => [ { 'points' => \@points } ] 
} ] );
#

my $xml = $gpx->xml( '1.0' );

my $output_filename="Torque-${start_time}_${end_time}.gpx";
open(my $file, '>', $output_filename); 
print $file $xml;
close $file;

print "$output_filename written with data from $datafile\n";
