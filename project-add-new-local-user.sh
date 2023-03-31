#!/bin/bash


# Enforces that it be executed with superuser (root) privileges.
if [[ ${UID} -ne 0 ]]
then
	echo "Root previlage needed"
	exit 1
fi

# if the user does not supply an account name Provide a usage statement and exit code 1
NUMBER_OF_PARAMETERS=${#}
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
	echo "Please type the user account info"
	exit 1
fi


# Uses the first argument provided on the command line as the username
USER_NAME=${1}


# Rest of the arguments uses as the comment for the account
shift
COMMENT="${@}"


# Generate password 
PASSWORD=$(date +%s%N | sha256sum | head -c8)


# Create user
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Set a random password
echo "${USER_NAME}:${PASSWORD}" | chpasswd

# Let user know if password cant be set
if [[ "${?}" -ne 0 ]]
then
	echo "Account can't be created"
	exit 1
fi

# Expire the password immidiately
passwd -e ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
    echo "Password could not be set"
    exit 1
fi


echo "username: ${USER_NAME}"
echo "password: ${PASSWORD}"
echo "host: ${HOSTNAME}"

exit 0
