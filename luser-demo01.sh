#!/bin/bash

# This is a comment

# THis script displays various information to the screen.

# Display 'Hello'
echo 'Hello'

# Assign a value to a variable
WORD='script string test'

# Display that value using the variable.Double quotes for interprate as variable
echo "$WORD"

# Demonstrate that singl quotes cause varable to NOT get interprated
echo '$WORD'

# Combine the variable with hard-coded text
echo "This is a shell $WORD"

# Display the contents of the variable using an alternative syntax
echo "This is a shell ${WORD}"

# Append text to the variable
echo "${WORD}ing is fun"

# Create another variable
ENDING='ed'

# Combine the two varibles
echo "This is ${WORD}${ENDING}."

# Variable re-assignment
ENDING=$WORD
WORD='NEW WORD'
echo "${WORD} - ${ENDING}"
