#!/usr/bin/env bash -e

RESOURCES="../Resources"

# Convert Markdown files to HTML
# $0 - Source directory with Markdown files
# $1 - Destination directory for HTML files
generateMarkdown() {
    SOURCE="$1"
    DESTINATION="$2"
    mkdir -p "$DESTINATION"
    cp -r "$RESOURCES"/CSS/ "$RESOURCES"/English/Images/ "$DESTINATION"
    find "$SOURCE"/* -iname "*.md" -type f | while read INPUT; do
        OUTPUT="$DESTINATION"/`basename "$INPUT" .md`.html
        pandoc "$INPUT" --from=markdown --to=html5 --standalone --output="$OUTPUT" --css=main.css
    done
}

# Fix ugly "Back" button in Pandoc footnotes
# $0 - Path to directory with HTML files
fixFootnotes() {
    LOCATION="$1"
    sed \
        -e 's/↩/Back/g' \
        -e 's/\(<a href="#fnref\)/\&nbsp;\1/g' \
        -i "" \
            "$LOCATION"/*.html
}

BUNDLE="$CONFIGURATION_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH"

generateMarkdown "$RESOURCES"/English/Markdown "$BUNDLE"/en.lproj
generateMarkdown "$RESOURCES"/Spanish/Markdown "$BUNDLE"/es.lproj

fixFootnotes "$BUNDLE"/en.lproj
fixFootnotes "$BUNDLE"/es.lproj
