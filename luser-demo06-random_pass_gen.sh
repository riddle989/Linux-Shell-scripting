#!/bin/bash

# This script generates a random password for each user specified for each user specified on the command line.


# Display what the user typed on th command line.
echo "You executed this command: ${0}"


# Display the path and filename of th script.
echo "You used $(dirname ${0}) as the path to the $(basename ${0}) script."


# Tell them how many arguments they passed in.
# (Inside the scripts they are parameters, outside they are arguments when user pass it commandline)
NUMBER_OF_PARAMETERS="${#}"
echo "you supplied ${NUMBER_OF_PARAMETERS} arguments on the command line"


# Make sure they at least supply one argument.
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
    echo "Usage: ${0} USER_NAME [USEr_NAME]..."
    exit 1
fi


# Generate and display a password for each parameter.
for USER_NAME in "${@}"
do
	PASSWORD=$(date +%s%N | sha256sum | head -c48)
	echo "${USER_NAME}:${PASSWORD}"
done

