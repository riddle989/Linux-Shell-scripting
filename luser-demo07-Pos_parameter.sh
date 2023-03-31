#!/bin/bash



# Loop through all the positional parameters.
# shift 2 positional parameter every time
while [[ "${#}" -gt 0 ]]
do
	echo "${1} ${2} ${3} ${4} ${5} ${6}"
	shift 2
done
