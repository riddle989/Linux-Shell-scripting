#!/bin/bash

# Format 1 for function
log1() {
    echo "You called the log function - Format 1"
    echo ""
}
log1

# Format 2 for the function
function log2 {
    echo "You called the log funciton - Format 2"
    echo ""
}
log2


log() {
    # This function sends a msg to /var/log/syslog and to std output if VERBOSE is true.
    local MESSAGE="${@}"
    if [[ "$VERBOSE" = 'true' ]]
    then
        echo "${MESSAGE}"
        echo ""
    fi
    logger -t luser-demo10.sh "${MESSAGE}"
}

readonly VERBOSE='false'
log "Hello" "world" "Three different arguments"
log "WORLD!!"

backup_file() {
    # This function creats a backup of a file and returns a non-zero code for error
    local FILE="${1}"

    # Make sure the file exists
    if [[ -f "${FILE}" ]]
    then
       # This file will be removed in 30 days 
        local BACKUP_FILE_PERMANENT="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"

        # This file will be removed after reboot
        local BACKUP_FILE_TEMP="/tmp/$(basename ${FILE}).$(date +%F-%N)"
        log "Backing up ${FILE} to ${BACKUP_FILE_TEMP}."

        # Exit status of the function will be the exit status of the cp command.
        cp -p ${FILE} ${BACKUP_FILE_TEMP}
    else
        # "return" only exit from the funtion, not the whole scripts
        return 1
    fi
}
backup_file /etc/passwd


if [[ "${?}" -eq 0 ]]
then 
    log 'File backup succeeded'
else
    log 'File backup failed'

    # "exit" directly exits from the script, so be careful when using "exit" in function
    exit 1
fi


