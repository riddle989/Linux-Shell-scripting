#!/bin/bash


# Check if the user is superuser
if [[ "${UID}" -ne 0 ]]
then
    exit 1
fi


# Prompts to create user account

read -p "Enter the user name: " USER_NAME

read -p "Enter the Real name of the user: " COMMENT

read -p "Enter the password for the account: " PASSWORD

useradd -c "${COMMENT}" -m "${USER_NAME}"
if [[ "${?}" -eq 1 ]]
then
    exit 1
fi

echo "${USER_NAME}:${PASSWORD}" | chpasswd
if [[ "${?}" -eq 1 ]]
then
    exit 1
fi

passwd -e "${USER_NAME}"


echo "username ${USER_NAME}"
echo "password ${PASSWORD}"
echo "host ${HOSTNAME}"



exit 0
