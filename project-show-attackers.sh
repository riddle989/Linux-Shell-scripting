#!/bin/bash


# Make sure a file was supplied as an argument.
FILE_NAME="${1}"
LIMIT='10'

if [[ ! -e "${FILE_NAME}" ]]
then
    echo "Can't open log file: ${FILE_NAME}." >&2
    exit 1
fi

# if [[ "${#}" -lt 1 ]]
# then
#     echo "Can't open log file."
#     exit 1
# fi


# Display the CSV header
echo "Count,IP,Location"

# Loop through the file
grep 'Failed password' "${FILE_NAME}" | awk '{print $(NF - 3)}'| sort | uniq -c | sort -nr | while read COUNT IP
do
    if [[ "${COUNT}" -gt ${LIMIT} ]]
    then
        LOCATION=$(geoiplookup "${IP}" | awk -F ', ' '{print $2}' )
        echo "${COUNT},${IP},${LOCATION}"
    fi
done
exit 0