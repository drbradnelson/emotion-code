#!/usr/bin/env bash -e
find . -iname '*.html' -exec tidy -q -e {} +