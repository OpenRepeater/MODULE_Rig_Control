<?php
/*
* This is the file that gets called for this module when OpenRepeater first
* installs the mdoule. It adds the default settings for the module defined in
* the PHP array below into the database in the moduleOptions field in the
* modules table. This information is serialized in the database. The variables
* that should be defined here are the same variables that are used in the
* settings form. Again, it is what is stored in the database as options and
* not the variables that the SVXLink code expects to see in the generated 
* config file for the module.
*/

$default_settings = [
    'timeout_min' => '10',
    'rig_num' => '127',
    'port' => '/dev/ttyUSB0',
    'baud' => '9600',
];
?>