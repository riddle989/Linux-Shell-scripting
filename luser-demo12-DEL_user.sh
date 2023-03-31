#!/bin/bash

# THis scripts delte user


# Run as root
if [[ "${UID}" -ne 0 ]]
then
    echo "Please run with sudo." >&2
    exit 1
fi


# Assume the first argument is the user to delete
USER="${1}"


# Delete the user
userdel -r "${1}"


# Make sure the user is deleted.
if [[ "${?}" -ne 0 ]]
then
    echo "The account ${1} not deleted" >&2
    exit 1
fi


# Tell the user deleted successfully
echo "The account ${USer} was deleted"


exit 0
