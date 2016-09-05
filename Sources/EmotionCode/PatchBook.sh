#!/usr/bin/env bash -e

UNLOCALIZED_RESOURCES_FOLDER_PATH=${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}
ENGLISH_LOCALIZATION_FOLDER_PATH=$UNLOCALIZED_RESOURCES_FOLDER_PATH/en.lproj
SPANISH_LOCALIZATION_FOLDER_PATH=$UNLOCALIZED_RESOURCES_FOLDER_PATH/es.lproj

mkdir -p $ENGLISH_LOCALIZATION_FOLDER_PATH
mkdir -p $SPANISH_LOCALIZATION_FOLDER_PATH

#English version
pushd ../
patch Resources/English/The\ Emotion\ Code\,\ November\ 2015.html  --input=Sources/EmotionCode/BookPatches/English/book-add-chapters-en.patch --output=Sources/EmotionCode/book-with-chapters.html
popd
patch EmotionCode/book-with-chapters.html --input=EmotionCode/BookPatches/English/book-remove-chapter-numbers-en.patch --output=EmotionCode/book-no-chapter-numbers.html
patch EmotionCode/book-no-chapter-numbers.html --input=EmotionCode/BookPatches/English/book-fix-chapter-quote-en.patch --output=EmotionCode/book-fixed-quote.html

EMPTY_SPAN_REGEX="<span[^>]*>[[:space:]]*</span>"
sed -E -e's,<a href="">(.*)</a>,\1,g' -e s,$EMPTY_SPAN_REGEX,,g <EmotionCode/book-fixed-quote.html >EmotionCode/book-fixed.html

rm EmotionCode/book-with-chapters.html
rm EmotionCode/book-no-chapter-numbers.html
rm EmotionCode/book-fixed-quote.html

patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter1-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter1.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter2-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter2.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter3-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter3.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter4-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter4.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter5-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter5.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter6-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter6.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter7-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter7.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter8-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter8.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter9-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter9.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter10-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/chapter10.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter11-en.patch --output=$ENGLISH_LOCALIZATION_FOLDER_PATH/about-author.html

cp -r ../Resources/English/Resources $ENGLISH_LOCALIZATION_FOLDER_PATH
patch $ENGLISH_LOCALIZATION_FOLDER_PATH/Resources/css/idGeneratedStyles.css --input=EmotionCode/BookPatches/English/css_en.patch

rm EmotionCode/book-fixed.html

#Spanish version
pushd ../
patch Resources/Spanish/The\ Emotion\ Code\,\ Revision\ 9-13.html  --input=Sources/EmotionCode/BookPatches/Spanish/book-add-chapters-es.patch --output=Sources/EmotionCode/book-with-chapters.html
popd
patch EmotionCode/book-with-chapters.html --input=EmotionCode/BookPatches/Spanish/book-remove-chapter-numbers-es.patch --output=EmotionCode/book-no-chapter-numbers.html
patch EmotionCode/book-no-chapter-numbers.html --input=EmotionCode/BookPatches/Spanish/book-fix-chapter-quote-es.patch --output=EmotionCode/book-fixed-quote.html

EMPTY_SPAN_REGEX="<span[^>]*>[[:space:]]*</span>"
sed -E -e's,<a href="">(.*)</a>,\1,g' -e s,$EMPTY_SPAN_REGEX,,g <EmotionCode/book-fixed-quote.html >EmotionCode/book-fixed.html

rm EmotionCode/book-with-chapters.html
rm EmotionCode/book-no-chapter-numbers.html
rm EmotionCode/book-fixed-quote.html

patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter1-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter1.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter2-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter2.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter3-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter3.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter4-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter4.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter5-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter5.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter6-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter6.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter7-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter7.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter8-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter8.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter9-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter9.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter10-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/chapter10.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/Spanish/chapter11-es.patch --output=$SPANISH_LOCALIZATION_FOLDER_PATH/about-author.html

cp -r ../Resources/Spanish/Resources $SPANISH_LOCALIZATION_FOLDER_PATH
patch $SPANISH_LOCALIZATION_FOLDER_PATH/Resources/css/idGeneratedStyles.css --input=EmotionCode/BookPatches/Spanish/css_es.patch

rm EmotionCode/book-fixed.html