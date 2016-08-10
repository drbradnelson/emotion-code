#!/usr/bin/env bash -e
tidy --help | grep -q 'This is modern HTML Tidy'
find . -iname '*.html' -exec tidy -q -e {} +