#!/usr/bin/env bash -e

tidy --help | grep 'This is modern HTML Tidy' || { echo "Tidy needs to be updated to support HTML5"; exit 1; }
echo "Looking for invalid markup files:"
find * -iname '*.html' -type f | while read FILE
do
    echo "Linting: $FILE"
    tidy -q -e "$FILE"
done