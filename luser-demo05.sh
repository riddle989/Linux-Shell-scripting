#!/bin/bash

# This script generates a list of random passwords.


# A random number as password.
PASSWORD="${RANDOM}"
echo "Just a random password = ${PASSWORD}"


#Three random numbers together.
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "Three random numbers = ${PASSWORD}"


# Use the current date time as the basis for password
PASSWORD=$(date +%s)
echo "Only seconds in password = ${PASSWORD}"

#Use nano seconds for password
PASSWORD=$(date +%s%N)
echo "Nano seconds as password = ${PASSWORD}"


# A better password.
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "A better password = ${PASSWORD}"


#An even better password.
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "An even better password = ${PASSWORD}"


#Append a special character at the end of password
SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
echo "Append a special char to the password = ${PASSWORD}${SPECIAL_CHARACTER}"

exit 0
