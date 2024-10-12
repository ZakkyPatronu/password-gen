#!/bin/bash

# Default password length
PASSWORD_LENGTH=12

# Function to display usage information
usage() {
  echo "Usage: $0 [-l length] [-u] [-n] [-s]"
  echo "  -l length  : Specify the length of the password (default: 12)"
  echo "  -u         : Include uppercase letters"
  echo "  -n         : Include numbers"
  echo "  -s         : Include special characters"
  exit 1
}

# Parse command-line options
while getopts ":l:uns" opt; do
  case $opt in
    l)
      PASSWORD_LENGTH=$OPTARG
      if ! [[ "$PASSWORD_LENGTH" =~ ^[0-9]+$ ]]; then
        echo "Error: Password length must be a positive integer."
        exit 1
      fi
      ;;
    u)
      INCLUDE_UPPERCASE=true
      ;;
    n)
      INCLUDE_NUMBERS=true
      ;;
    s)
      INCLUDE_SPECIAL=true
      ;;
    *)
      usage
      ;;
  esac
done

# Set character sets
CHAR_LOWER="abcdefghijklmnopqrstuvwxyz"
CHAR_UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
CHAR_NUM="0123456789"
CHAR_SPECIAL="!@#$%^&*()-_=+[]{};:,.<>?"

# Build the character set based on user input
CHAR_SET=$CHAR_LOWER
if [ "$INCLUDE_UPPERCASE" = true ]; then
  CHAR_SET+=$CHAR_UPPER
fi
if [ "$INCLUDE_NUMBERS" = true ]; then
  CHAR_SET+=$CHAR_NUM
fi
if [ "$INCLUDE_SPECIAL" = true ]; then
  CHAR_SET+=$CHAR_SPECIAL
fi

# Check if character set is empty
if [ -z "$CHAR_SET" ]; then
  echo "Error: No character types selected for the password."
  exit 1
fi

# Generate password
PASSWORD=$(< /dev/urandom tr -dc "$CHAR_SET" | head -c "$PASSWORD_LENGTH")

# Output the generated password
echo "Generated Password: $PASSWORD"
