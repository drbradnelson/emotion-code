#!/usr/bin/env bash -e

RESOURCES="../Resources"

function install {
    SOURCE="$1"
    DESTINATION="$2"
    mkdir -p "$DESTINATION"
    cp -r "$RESOURCES"/CSS "$RESOURCES"/English/Images "$DESTINATION"
    find "$SOURCE"/* -iname "*.md" -type f | while read INPUT; do
        OUTPUT="$DESTINATION"/`basename "$INPUT" .md`.html
        pandoc "$INPUT" --from=markdown --to=html5 --standalone --output="$OUTPUT" --css=main.css
    done
}

BUNDLE="$CONFIGURATION_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH"

install "$RESOURCES"/English/Markdown "$BUNDLE"/en.lproj
install "$RESOURCES"/Spanish/Markdown "$BUNDLE"/es.lproj
