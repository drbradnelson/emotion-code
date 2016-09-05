#!/usr/bin/env bash -e

pushd ../
patch Resources/English/The\ Emotion\ Code\,\ November\ 2015.html  --input=Sources/EmotionCode/BookPatches/English/book-add-chapters-en.patch --output=Sources/EmotionCode/book-with-chapters.html
popd
patch EmotionCode/book-with-chapters.html --input=EmotionCode/BookPatches/English/book-remove-chapter-numbers-en.patch --output=EmotionCode/book-no-chapter-numbers.html
sed -E -e's,<a href="">(.*)</a>,\1,g' -e's,<span.*> +</span>,,g' <EmotionCode/book-no-chapter-numbers.html >EmotionCode/book-fixed.html

rm EmotionCode/book-with-chapters.html
rm EmotionCode/book-no-chapter-numbers.html

mkdir -p ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/en.lproj/

UNLOCALIZED_RESOURCES_FOLDER_PATH=${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}
ENGLISH_LOCALIZATION_FOLDER_PATH=$UNLOCALIZED_RESOURCES_FOLDER_PATH/en.lproj

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


