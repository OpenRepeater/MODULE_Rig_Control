####################################################################################
#  OpenRepeater RigCtl Module
#  Coded by Aaron Crawford (N3MBH), Dan Loranger(KG7PAR) & Gregg Daugherty (WB6YAZ)
#  DTMF Control of rigctl (hamlib 3.0.1) functions as defined below.
#  This example uses preset memory settings (1-8) for an IC-7100
#  rigctl -m 370 -r /dev/ttyUSB0 -s 9600 E n, where n = memory number
#  config variables are set in /etc/svxlink/ModuleRigCtl.config
#
#  When using /dev/ttyUSB0, insure permissions for /dev/ttyUSB0 are set
#  to rw for others (chmod o+rw /dev/ttyUSB0)
#
#  Usage:
#  01# = RIGCTL_1
#  02# = RIGCTL_2
#  ... etc
#
#  Visit the project at OpenRepeater.com
####################################################################################


# Start of namespace
namespace eval RigCtl {

	# Check if this module is loaded in the current logic core
	if {![info exists CFG_ID]} {
		return;
	}


	# Extract the module name from the current namespace
	set module_name [namespace tail [namespace current]]


	# A convenience function for printing out information prefixed by the module name
	proc printInfo {msg} {
		puts "RIG CONTROL: $msg"
	}


	# A convenience function for calling an event handler
	proc processEvent {ev} {
		variable module_name
		::processEvent "$module_name" "$ev"
	}


	# Executed when this module is being activated
	proc activateInit {} {
		# Construct base rigctl communication string
		variable CFG_RADIO_ID
		variable CFG_RADIO_PORT
		variable CFG_RADIO_BAUD
		variable RIG_STRING
		set RIG_STRING "-m $CFG_RADIO_ID -r $CFG_RADIO_PORT -s $CFG_RADIO_BAUD"


		# Access Variables
		variable CFG_ACCESS_PIN
		variable CFG_ACCESS_ATTEMPTS_ALLOWED
		variable ACCESS_PIN_REQ
		variable ACCESS_GRANTED
		variable ACCESS_ATTEMPTS_ATTEMPTED
	    if {[info exists CFG_ACCESS_PIN]} {
			set ACCESS_PIN_REQ 1
			if {![info exists CFG_ACCESS_ATTEMPTS_ALLOWED]} { set CFG_ACCESS_ATTEMPTS_ALLOWED 3 }
		} else {
			set ACCESS_PIN_REQ 0
		}
		set ACCESS_GRANTED 0
		set ACCESS_ATTEMPTS_ATTEMPTED 0


		printInfo "Module Activated"

		if {$ACCESS_PIN_REQ == "1"} {
			printInfo "--- PLEASE ENTER YOUR PIN FOLLOWED BY THE POUND SIGN ---"
			playModuleMsg "access_enter_pin";

		} else {
			# No Pin Required but this is the first time the module has been run so play prompt
			playModuleMsg "enter_command";
		}

	}


	 # Executed when this module is being deactivated.
	proc deactivateCleanup {} {
		printInfo "Module deactivated"
	}


	# Returns voice status of RigCtl setting
	#proc RigCtlStatus {} {
	#	variable RIGCTL
	#	printInfo "STATUS RIGCTL STATE"
	#	playModuleMsg "status";
	#	set RIGCTL_FILE [open "/home/root/rcvalue" r]
	#	set RIGCTL_STATE [read -nonewline $RIGCTL_FILE]
	#	printInfo "RIGCTL $RIGCTL_STATE ON"
	#	playModuleMsg "rigctl";
	#	playModuleMsg "$RIGCTL_STATE";
	#	playModuleMsg "on";
	#	playSilence 700;
  #}


  	#############################################################################
  	# This procedure to say frequency is in newer local.tcl files
  	# once it has been added to release versions that ORP get built from,
  	# it can be removed from this module
  	#############################################################################

	#
	# Say the given frequency as intelligently as possible
	#
	#   fq -- The frequency in Hz
	#
	proc playFrequency {fq} {
	  if {$fq < 1000} {
	    set unit "Hz"
	  } elseif {$fq < 1000000} {
	    set fq [expr {$fq / 1000.0}]
	    set unit "kHz"
	  } elseif {$fq < 1000000000} {
	    set fq [expr {$fq / 1000000.0}]
	    set unit "MHz"
	  } else {
	    set fq [expr {$fq / 1000000000.0}]
	    set unit "GHz"
	  }
	  playNumber [string trimright [format "%.3f" $fq] ".0"]
	  playMsg "Core" $unit
	}

  	#############################################################################
	# RIG CONTROL PROCEDURES (CAT Control)
  	#############################################################################

  	###############################
  	# FREQUENCY PROCEDURES
  	###############################
  	
	proc getRigFreq {} {
		variable RIG_STRING
		set RIG_COMMAND "$RIG_STRING get_freq"
		set RIG_RESULT [exec rigctl {*}$RIG_COMMAND]
		return $RIG_RESULT
	}

	proc setRigFreq {freq} {
		variable RIG_STRING
		set RIG_COMMAND "$RIG_STRING set_freq $freq"
		exec rigctl {*}$RIG_COMMAND
		if {$freq == [getRigFreq]} {
			return "success"
		} else {
			return "failed"
		}
	}


  	###############################
  	# MEMORY PROCEDURES
  	###############################
  	
	proc getRigMemory {} {
		variable RIG_STRING
		set RIG_COMMAND "$RIG_STRING get_mem"
		set RIG_RESULT [exec rigctl {*}$RIG_COMMAND]
		return $RIG_RESULT
	}

	proc setRigMemory {mem} {
		variable RIG_STRING
		set RIG_COMMAND "$RIG_STRING set_mem $mem"
		exec rigctl {*}$RIG_COMMAND
		if {$mem == [getRigMemory]} {
			return "success"
		} else {
			return "failed"
		}
	}


  	#############################################################################
	# Module Procedures
  	#############################################################################

	proc printFreq {fq} {
	  if {$fq < 1000} {
	    set unit "Hz"
	  } elseif {$fq < 1000000} {
	    set fq [expr {$fq / 1000.0}]
	    set unit "kHz"
	  } elseif {$fq < 1000000000} {
	    set fq [expr {$fq / 1000000.0}]
	    set unit "MHz"
	  } else {
	    set fq [expr {$fq / 1000000000.0}]
	    set unit "GHz"
	  }
	  set result [string trimright [format "%.3f" $fq] ".0"]
	  append result " $unit"
	  printInfo $result
	}




  	#############################################################################
	# DTMF Procedures
  	#############################################################################

	# Executed when a DTMF command is received
	proc changeRigState {cmd} {
		variable RIGCTL
		variable currentFreq

#                exec python3 /usr/share/svxlink/python/set_pttlock_on.py
#                printInfo "pttlock on"
#                playModuleMsg "pttlockon"

		# printInfo $RIGCTL(2)

		if {$cmd == "01" || $cmd == "02" || $cmd == "03" || $cmd == "04" || $cmd == "05" || $cmd == "06" || $cmd == "07" || $cmd == "08"} {
			set curMem $cmd
			playModuleMsg "memory"
			playNumber $curMem
			playSilence 1000;
			if {[setRigMemory $curMem] == "success" } {
			    printInfo "Memory $curMem selected"
				set currentFreq [getRigFreq]
				printFreq $currentFreq
				playFrequency $currentFreq
			} else {
			    printInfo "Failed to set memory $curMem"
				playMsg "Default" "operation_failed"
			}

		} elseif {$cmd == ""} {
		    deactivateModule

		} else {
		    processEvent "unknown_command $cmd"
		}

	}

	# Execute when a DTMF Command is received and check for access.
	proc dtmfCmdReceived {cmd} {
		variable CFG_ACCESS_PIN
		variable ACCESS_PIN_REQ
		variable ACCESS_GRANTED
		variable CFG_ACCESS_ATTEMPTS_ALLOWED
		variable ACCESS_ATTEMPTS_ATTEMPTED

		if {$ACCESS_PIN_REQ == 1} {
			# Pin Required
			if {$ACCESS_GRANTED == 1} {
				# Access Granted - Pass commands to rig control
				changeRigState $cmd
			} else {
				# Access Not Granted Yet, Process Pin
				if {$cmd == $CFG_ACCESS_PIN} {
					set ACCESS_GRANTED 1
					printInfo "ACCESS GRANTED --------------------"
					playModuleMsg "access_granted";
					playModuleMsg "enter_command";
				} elseif {$cmd == ""} {
					# If only pound sign is entered, deactivate module
					deactivateModule
				} else {
					incr ACCESS_ATTEMPTS_ATTEMPTED
					printInfo "FAILED ACCESS ATTEMPT ($ACCESS_ATTEMPTS_ATTEMPTED/$CFG_ACCESS_ATTEMPTS_ALLOWED) --------------------"

					if {$ACCESS_ATTEMPTS_ATTEMPTED < $CFG_ACCESS_ATTEMPTS_ALLOWED} {
						printInfo "Please try again!!! --------------------"
						playModuleMsg "access_invalid_pin";
						playModuleMsg "access_try_again";
					} else {
						printInfo "ACCESS DENIED!!! --------------------"
						playModuleMsg "access_denied";
						deactivateModule
					}
				}
			}

		} else {
			# No Pin Required - Pass straight on to relay control
			changeRigState $cmd
		}

	}

	# Executed when a DTMF command is received in idle mode. (Module Inactive)
	proc dtmfCmdReceivedWhenIdle {cmd} {
		printInfo "DTMF command received when idle: $cmd"
	}


	# Executed when the squelch opened or closed.
	proc squelchOpen {is_open} {
		# if {$is_open} {set str "OPEN"} else { set str "CLOSED"}
		# printInfo "The squelch is $str"
	}


	# Executed when all announcement messages has been played.
	proc allMsgsWritten {} {
		# printInfo "Test allMsgsWritten called..."
	}


# end of namespace
}
