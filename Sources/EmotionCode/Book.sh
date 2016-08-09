#!/usr/bin/env bash -e

NUM_FAILS=0

for FILE in $(find . -iname '*.html' -type f -print); do
tidy -q -e ${FILE}

if [ $? -ne 0 ]; then
((NUM_FAILS++))
fi

done

if [ ${NUM_FAILS} -gt 0 ]; then
echo -e "There were ${NUM_FAILS} failed files."
exit 1
fi

exit 0