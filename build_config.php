<?php
/*
* This is the file that gets called for this module when OpenRepeater rebuilds the configuration files for SVXLink.
* Settings for the config file are created as a PHP associative array, when the file is called it will convert it into
* the requiried INI format and write the config file to the appropriate location with the correct naming.
*/

// Build Config
$module_config_array['Module'.$cur_mod['svxlinkName']] = [
	'NAME' => $cur_mod['svxlinkName'],
	'PLUGIN_NAME' => 'Tcl',
	'ID' => $cur_mod['svxlinkID'],
];

$module_config_array['Module'.$cur_mod['svxlinkName']] += [
	'RADIO_ID' => '127',
	'RADIO_PORT' => '/dev/ttyUSB0',
	'RADIO_BAUD' => '9600',
];

$module_config_array['Module'.$cur_mod['svxlinkName']] += [
	'#ACCESS_PIN' => '1234',
	'ACCESS_ATTEMPTS_ALLOWED' => '3',
];

$module_config_array['Module'.$cur_mod['svxlinkName']] += [
	'RIGCTL_1' => '"-m 370 -r /dev/ttyUSB0 -s 9600 E 1"',
	'RIGCTL_2' => '"-m 370 -r /dev/ttyUSB0 -s 9600 E 2"',
	'RIGCTL_3' => '"-m 370 -r /dev/ttyUSB0 -s 9600 E 3"',
	'RIGCTL_4' => '"-m 370 -r /dev/ttyUSB0 -s 9600 E 4"',
	'RIGCTL_5' => '"-m 370 -r /dev/ttyUSB0 -s 9600 E 5"',
	'RIGCTL_6' => '"-m 370 -r /dev/ttyUSB0 -s 9600 E 6"',
	'RIGCTL_7' => '"-m 370 -r /dev/ttyUSB0 -s 9600 E 7"',
	'RIGCTL_8' => '"-m 370 -r /dev/ttyUSB0 -s 9600 E 8"',
];

?>