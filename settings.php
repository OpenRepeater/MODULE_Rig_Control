<?php
/* 
 *	Settings Page for Module 
 *	
 *	This is included into a full page wrapper to be displayed. 
 */
?>

<!-- BEGIN FORM CONTENTS -->
	<fieldset>
		<legend>Module Settings</legend>
		  <div class="control-group">
			<label class="control-label" for="rig_num">Rig Number</label>
			<div class="controls">
			  <input class="input-xlarge" id="rig_num" type="text" name="rig_num" value="<?php echo $moduleSettings['rig_num']; ?>">
			</div>
		    <span class="help-inline">...</span>
		  </div>
	
		  <div class="control-group">
			<label class="control-label" for="port">Port</label>
			<div class="controls">
			  <input class="input-xlarge" id="port" type="text" name="port" value="<?php echo $moduleSettings['port']; ?>">
			</div>
		    <span class="help-inline">...</span>
		  </div>

		  <div class="control-group">
			<label class="control-label" for="baud">Baud</label>
			<div class="controls">
			  <input class="input-xlarge" id="baud" type="text" name="baud" value="<?php echo $moduleSettings['baud']; ?>">
			</div>
		    <span class="help-inline">...</span>
		  </div>

	

		  <div class="control-group">
			<label class="control-label" for="access_pin">DTMF Access Pin</label>
			<div class="controls">
			  <input class="input-xlarge" id="access_pin" type="text" name="access_pin" value="<?php echo $moduleSettings['access_pin']; ?>">
			</div>
		    <span class="help-inline">When set, the Rig Control Module will prompt for this pin when the module is activated. Leave empty to not require a pin for access.</span>
		  </div>
	
		  <div class="control-group">
			<label class="control-label" for="access_attempts_allowed">DTMF Access Attempts Allowed</label>
			<div class="controls">
			  <input class="input-xlarge" id="access_attempts_allowed" type="text" name="access_attempts_allowed" value="<?php echo $moduleSettings['access_attempts_allowed']; ?>" required>
			</div>
		    <span class="help-inline">The number of pin entry attempts allowed before module is deactivated.</span>
		  </div>

		  <div class="control-group">
			<label class="control-label" for="timeout_min">Time Out</label>
			<div class="controls">
			  <input class="input-xlarge" id="timeout_min" type="text" name="timeout_min" value="<?php echo $moduleSettings['timeout_min']; ?>">
			</div>
		    <span class="help-inline">...Timeout in minutes</span>
		  </div>
	
	</fieldset>					
	
<!-- END FORM CONTENTS -->