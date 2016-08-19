#!/usr/bin/env bash -e

if ! tidy -h | grep -q 'This is modern HTML Tidy'
then
    echo "Tidy needs to be updated to support HTML5" >&2
    exit 1
fi

echo "Looking for invalid markup files:"
find * -iname '*.html' -type f | while read FILE
do
    echo "Linting: $FILE"
    tidy -q -e "$FILE"
done