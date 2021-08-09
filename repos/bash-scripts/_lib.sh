#!/usr/bin/env bash

#set -ex

####################################################################################
# Library of common functions used across all shell scripts
####################################################################################

#-----------------------------------------------------------------------------------
# Purpose: Outputs text in green
#	ARGS:
#		${1} -- Text to output
#-----------------------------------------------------------------------------------
print_green()
{
	echo -e "\033[0;32m${1}\033[0m"
}

#-----------------------------------------------------------------------------------
# Purpose: Outputs text in red
#	ARGS:
#		${1} -- Text to output
#-----------------------------------------------------------------------------------
print_red()
{
	echo -e "\033[0;31m${1}\033[0m"
}

#-----------------------------------------------------------------------------------
# Purpose: Outputs text in yellow
#	ARGS:
#		${1} -- Text to output
#-----------------------------------------------------------------------------------
print_yellow()
{
	echo -e "\033[0;33m${1}\033[0m"
}

#-----------------------------------------------------------------------------------
# Purpose: Outputs text (for verbose-logging purposes) by checking for the
#			 presence of the "VERBOSE" flag
#	ARGS:
#		${1} -- Text to output
#-----------------------------------------------------------------------------------
verbose_log()
{
    if [[ ! -z "${VERBOSE-}" ]]; then
        print_yellow "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
        print_yellow "${1}"
        print_yellow "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    fi
}

#-----------------------------------------------------------------------------------
# Purpose: Validates a particular input by ensuring that a variable is set; does
#            not work with strings with spaces!
#	ARGS:
#		${1} -- Prompt message to enter variable (first iteration)
#		${2} -- The actual variable being checked (bash variable)
#-----------------------------------------------------------------------------------
validate_input()
{
	if [[ -z "${2-}" ]]; then
		IFS= read -r -p "${1}: " VAL
		echo "${VAL}"
	fi
	
	echo "${2-}"
}
