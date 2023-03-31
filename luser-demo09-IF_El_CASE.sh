#!/bin/bash

# This script demonstrate a case statement
if [[ "${1}" = 'start' ]]
then
    echo "Starting..."
elif [[ "${1}" = 'stop' ]]
then
    echo "Stopping..."
elif [[ "${1}" = 'status' ]]
then
    echo "Status: "
else
    echo "Supply a valid option." >&2
    exit 1
fi


# This is the ideal format of a case statement
case "${1}" in
    start)
        echo "Starting..."
        ;;
    stop)
        echo "Stopping..."
        ;;
    status|state|--status|-state)
        echo "Multiple case matching..."
        ;;
    *)
        echo "Everything else" >&2
        exit 1
        ;;
esac


# Here is a compact version of the case statement.
case "${1}" in
    start) echo "Compact version Starting" ;;
    stop) echo "Compact version Stopping" ;;
    status) echo "Compact version status" ;;
    *)
        echo "Compact version Every thing else" >&2
        exit 1
        ;;
esac
