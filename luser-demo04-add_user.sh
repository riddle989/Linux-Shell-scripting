#!/bin/bash


# This script creates an account on the lcal system.
# You will be prompted for teh account name and password.


# Ask for thhe user name.
read -p 'Enter the username to create: ' USER_NAME


# Ask for the real name.
read -p 'Enter the name of te person who this account is for: ' COMMENT


# Ask for the password.
read -p 'Enter the password to use for the account: ' PASSWORD


# Create the user.
useradd -c ${COMMENT} -m ${USER_NAME} 


# Set the password for the user.
echo "${USER_NAME}:${PASSWORD}" | sudo chpasswd


# Force password change on first login.
passwd -e ${USER_NAME}

