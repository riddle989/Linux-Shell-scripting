#!/bin/bash

# This script demonstrates I/O redirection.


# Redirect STDOUT to a file.
FILE="temp/test.txt"
head -n3 /etc/passwd > ${FILE}
echo "FIRST 3 Line : "
cat ${FILE}
echo

# Redirect STDIN to a program, only single line will be read, new line not work
read FILE_LINE < ${FILE}
echo "First single line from the file : ${FILE_LINE}"


# Redirect STDOUT to a file, overwriting the file
head -n5 /etc/passwd > ${FILE}
echo
echo "Contents of the file :"
cat "${FILE}"
echo

# Redirect STDOUT to a file and append to it

echo
echo "My-pass : $(date +%s%N$RANDOM | sha256sum | head -c16)" >> ${FILE}
cat "${FILE}"
echo




# Redirect STDIN to a program(explicitly), using FD 0.
read LINE 0< ${FILE}
echo ""
echo "Line contains : ${LINE}"


# Redirect STDOUT to a file(explicitly) using FD 1, overwriting the file.
head -n3 /etc/passwd 1> ${FILE}
echo
echo "COntents of ${FILE}"
cat -n ${FILE}
echo


# Redirect STDERR to a file uising FD 2.
ERR_FILE="temp/data.err"
head -n3 /etc/passwd /fakefile 2> "${ERR_FILE}"
echo "Contents of STDErr: "
cat ${ERR_FILE}


# Redirect STDOUT and STDERR to a file.
echo
head -n3 /etc/passwd /fakefile &> "${FILE}"
echo "Contents of STDOut and STDErr: "
cat ${FILE}


# Redirect STDOut and STDErr through a pipe.
echo
head -n3 /etc/passwd /fakefile |& cat -n
echo


# Send output to STDErr forcefully
echo "This error implemented forcefully" >&2


# Discard error or output by sending to null device

echo
echo "STDOUT Discarding"
head -n3 /etc/passwd /fakefile > /dev/null

echo
echo "STDERR Discarding."
head -n3 /etc/passwd /fakefile 2> /dev/null

echo 
echo "STDOUT and STDERR both discarding"
head -n3/etc/passwd /fakefile &> /dev/null


# Clean up
rm $FILE $ERR_FILE
