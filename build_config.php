<?php
/*
* This is the file that gets called for this module when OpenRepeater rebuilds the configuration files for SVXLink.
* Settings for the config file are created as a PHP associative array, when the file is called it will convert it into
* the requiried INI format and write the config file to the appropriate location with the correct naming.
*/

$options = unserialize($cur_mod['moduleOptions']);

// Build Config
$module_config_array['Module'.$cur_mod['svxlinkName']] = [
	'NAME' => $cur_mod['svxlinkName'],
	'PLUGIN_NAME' => 'Tcl',
	'ID' => $cur_mod['svxlinkID'],
	'TIMEOUT' => intval($options['timeout_min']) * 60,				
];

$module_config_array['Module'.$cur_mod['svxlinkName']] += [
	'RADIO_ID' => $options['rig_num'],
	'RADIO_PORT' => $options['port'],
	'RADIO_BAUD' => $options['baud'],
];


if($options['access_pin']) {
	// Define Access Code. To disable, comment out.
	$module_config_array['Module'.$cur_mod['svxlinkName']] += [
		'ACCESS_PIN' => $options['access_pin'],
	];

	if($options['access_attempts_allowed']) {
		$module_config_array['Module'.$cur_mod['svxlinkName']] += [
			'ACCESS_ATTEMPTS_ALLOWED' => $options['access_attempts_allowed'],
		];
	}
}

?>