#!/usr/bin/env bash -e

UNLOCALIZED_RESOURCES_FOLDER_PATH=${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}
ENGLISH_LOCALIZATION_FOLDER_PATH=$UNLOCALIZED_RESOURCES_FOLDER_PATH/en.lproj
SPANISH_LOCALIZATION_FOLDER_PATH=$UNLOCALIZED_RESOURCES_FOLDER_PATH/es.lproj

mkdir -p $ENGLISH_LOCALIZATION_FOLDER_PATH
mkdir -p $SPANISH_LOCALIZATION_FOLDER_PATH

#English version
cp -r ../Resources/English/CSS/. $ENGLISH_LOCALIZATION_FOLDER_PATH/
cp -r ../Resources/English/Images/. $ENGLISH_LOCALIZATION_FOLDER_PATH/
pandoc ../Resources/English/Markdown/chapter1.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter1.html --css=main.css
pandoc ../Resources/English/Markdown/chapter2.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter2.html --css=main.css
pandoc ../Resources/English/Markdown/chapter3.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter3.html --css=main.css
pandoc ../Resources/English/Markdown/chapter4.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter4.html --css=main.css
pandoc ../Resources/English/Markdown/chapter5.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter5.html --css=main.css
pandoc ../Resources/English/Markdown/chapter6.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter6.html --css=main.css
pandoc ../Resources/English/Markdown/chapter7.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter7.html --css=main.css
pandoc ../Resources/English/Markdown/chapter8.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter8.html --css=main.css
pandoc ../Resources/English/Markdown/chapter9.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter9.html --css=main.css
pandoc ../Resources/English/Markdown/chapter10.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter10.html --css=main.css
pandoc ../Resources/English/Markdown/about-author.md --from=markdown --to=html5 --standalone --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/about-author.html --css=main.css

#Spanish version
cp -r ../Resources/Spanish/CSS/. $SPANISH_LOCALIZATION_FOLDER_PATH/
cp -r ../Resources/Spanish/Images/. $SPANISH_LOCALIZATION_FOLDER_PATH/
pandoc ../Resources/Spanish/Markdown/chapter1.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter1.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter2.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter2.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter3.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter3.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter4.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter4.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter5.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter5.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter6.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter6.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter7.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter7.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter8.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter8.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter9.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter9.html --css=main.css
pandoc ../Resources/Spanish/Markdown/chapter10.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter10.html --css=main.css
pandoc ../Resources/Spanish/Markdown/about-author.md --from=markdown --to=html5 --standalone --output=$SPANISH_LOCALIZATION_FOLDER_PATH/about-author.html --css=main.css
