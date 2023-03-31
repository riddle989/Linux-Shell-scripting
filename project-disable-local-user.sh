#!/bin/bash

# Display the usage and exit.
usage() {
    echo "Usage: ${0} [-dra] USER [USERN]" >&2
    echo 'Disable a local Linux account.' >&2
    echo '-d  Deletes accounts instead of disabling them.' >&2
    echo '-r  Removes the home directory associated with the account(s).' >&2
    echo '-a  Creates an archive of the home directory associated with the accounts(s).' >&2

    exit 1
}

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]; then
    echo 'Please run with sudo or as root.' >&2
    exit 1
fi

REMOVE_HOME=''
DELETE_ACCOUNT='false'
ARCHIEVE_HOME_DIR='false'

# Parse the options.
while getopts rda OPTION; do
    case ${OPTION} in
    r) REMOVE_HOME='-r' ;;
    d) DELETE_ACCOUNT='true' ;;
    a) ARCHIEVE_HOME_DIR='true' ;;
    ?) usage ;;
    esac
done

# At least one username is required or the script will display a usage
shift "$((OPTIND - 1))"
if [[ "${#}" -lt 1 ]]; then
    usage
fi

ARCHIEVE_DIR='./archieve'

system_user_check() {
    if [[ $(id -u "${1}") -lt 1000 ]]; then
        echo "System user ${1}...Can't delete" >&2
        return 1
    fi
    return 0
}

for USER_NAME in "${@}"; do
    # Refuses to disable or delete any accounts that have a UID less than 1,000.i
    if [[ $(system_user_check "${USER_NAME}") -eq 1 ]]; then
        continue
    fi

    if [[ $ARCHIEVE_HOME_DIR = 'true' ]]; then
        # Make sure the ARCHIVE_DIR directory exists.
        if [[ ! -d "${ARCHIEVE_DIR}" ]]; then
            echo "Creating ${ARCHIEVE_DIR} directory."
            mkdir -p ${ARCHIEVE_DIR}
            if [[ "${?}" -ne 0 ]]; then
                echo "The archive directory ${ARCHIEVE_DIR} could not be created." >&2
                exit 1
            fi
        fi

        HOME_DIR="/home/${USER_NAME}"
        # Archive the user's home directory and move it into the ARCHIVE_DIR
        if [[ -d "${HOME_DIR}" ]]; then
            echo "Archiving ${HOME_DIR} to ${ARCHIEVE_FILE}"

            tar -zcf ./"${ARCHIEVE_DIR}/${USER_NAME}.tgz" "${HOME_DIR}" &>/dev/null

            if [[ "${?}" -ne 0 ]]; then
                echo "Could not create ${ARCHIEVE_FILE}." >&2
                exit 1
            fi

        else
            echo "${HOME_DIR} does not exist or is not a directory." >&2
            exit 1
        fi
    fi # END of if "${ARCHIVE}" = 'true'

    # if Delete true ->ex
    if [[ $DELETE_ACCOUNT = 'true' ]]; then
        echo "User deleting..."
        # if remove_home true -> delete accnt and remove home
        userdel $REMOVE_HOME $USER_NAME

        # Check to see if the userdel command succeeded.
        # We don't want to tell the user that an account was deleted when it hasn't been.
        if [[ $? -ne 0 ]]; then
            echo "The account ${USERNAME} was NOT deleted." >&2
            exit 1
        fi
        echo "The account ${USERNAME} was deleted."
    else
        # Disables (expires/locks) accounts by default.
        echo "User disableing....."
        chage -E 0 "${USER_NAME}"

        if [[ "${?}" -ne 0 ]]; then
            echo "The account ${USERNAME} was NOT disabled." >&2
            exit 1
        fi
        echo "The account ${USERNAME} was disabled."
    fi # END of if "${DELETE_USER}" = 'true'
done

exit 0
