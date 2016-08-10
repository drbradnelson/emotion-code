#!/usr/bin/env bash -e

echo "Looking for invalid markup files:"
tidy --help | grep -q 'This is modern HTML Tidy'
find * -iname '*.html' -type f | while read FILE
do
    echo "Linting: $FILE"
    tidy -q -e "$FILE"
done