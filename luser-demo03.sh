#!/bin/bash

# Display the UID and username of the user executing this script
# Display if the user is the vagrant user or not.

# Display the UID.
echo "Your UID is ${UID}"


# Only display if the UID does NOT match 1000
UID_TO_TEST_FOR='1000'
if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
    echo "Your UID does not match ${UID_TO_TEST_FOR}."
    exit 1
fi


# Display the username.
USER_NAME=$(id -un)


# Test if the command succeeded.
if [[ "${?}" -ne 0 ]]
then
    echo "The 'id' command did not execute successfully"
    exit 1
fi
echo "Your user name is ${USER_NAME}"


# You can use a string test conditional.
USER_NAME_TO_TEST_FOR='riddle'
if [[ "${USER_NAME}" = "${USER_NAME_TO_TEST_FOR}" ]]
then
    echo "Your username matches ${USER_NAME_TO_TEST_FOR}"
fi


# Test for != (not equal) for the string.
USER_NAME_TO_TEST='riddle666'
if [[ "${USER_NAME}" != "${USER_NAME_TO_TEST}" ]]
then
    echo "Your username does not match ${USER_NAME_TO_TEST}."
    exit 1
fi

# If we don't specify the exit code explicitly, the last exit code will be used for the whole script
exit 0
