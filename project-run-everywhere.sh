#!/bin/bash
# Display the usage and exit.
usage() {
    # Display the usage and exit.
    echo "Usage: ${0} [-nsv] [-f FILE] Command" >&2
    echo "Executes COMMAND as a single command on every server." >&2
    echo "  -f FILE    Use FILE fo the list of servers. Default ${SERVER_LIST}." > &2
    echo "  -n         Dry run mode. Display the COMMNAD that would have been executedd and exit" >&2
    echo "  -s         Execute the COMMAND using sudo on the remote server" >&2
    echo "  -v         Verbose mode. Displays the sever name before executing COMMAND" >&2
    exit 1
}

# A list of servers, one per line
SERVER_LIST='/servers'

# OPtions for th ssh command.
SSH_OPTIONS='-o ConnectTimeout=2'


# Make sure the script is not being executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]
then
    echo "Do not execute this script as root. Use the -s option" >&2
    usage
fi


# Parse the options.
while getopts nsf:v COMMAND_OPTION 
do
    case "${COMMAND_OPTION}" in
    v) VERBOSE='true' ;;
    n) DRY_RUN='true' ;;
    s) SUDO='sudo' ;;
    f) SERVER_LIST="${OPTARG}" ;;
    ?) usage
    esac
done


# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"


# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
    usage
fi


# Anything that remains on the command line is to be treated as a single command.
COMMAND="${@}"



# Make sure the SERVER_LIST file exists.
if [[ ! -e "${SERVER_LIST}" ]]
then 
    echo "Can't open sever list file ${SERVER_LIST}." >&2
    exit 1
fi

# Default exit status
EXIT_STATUS='0'


# Loop through the SERVER_LIST
for SERVER in $(cat $SERVER_LIST)
do
    if [[ "${VERBOSE}" = 'true' ]]
    then
        echo "${SERVER}"
    fi

    SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"


    # If it's a dry run, don't execute anything, just echo it.
    if [[ "${DRY_RUN}" = 'true' ]]
    then 
        echo "DRY RUN: ${SSH_COMMAND}"
    else
        ${SSH_COMMAND}
        SSH_EXIT_STATUS="${?}"

        # Capture any non-zero exit status from  the SSH_COMMAND and report to the user.
        ## We are not instantly exit the code, because suppose there are 100 servers,
        ##so we dont want to exit the whole script for only one server error
        if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
        then
            EXIT_STATUS="${SSH_EXIT_STATUS}"
            echo "Execution on ${SERVER} failed." > &2
        fi
    fi
done

# So finally show the worst error, after looping through the all server
exit "${EXIT_STATUS}"
