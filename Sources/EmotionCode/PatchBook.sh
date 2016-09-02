#!/usr/bin/env bash -e

pushd ../
patch Resources/English/The\ Emotion\ Code\,\ November\ 2015.html  --input=Sources/EmotionCode/BookPatches/English/book-add-chapters-en.patch --output=Sources/EmotionCode/book-with-chapters.html
popd
patch EmotionCode/book-with-chapters.html --input=EmotionCode/BookPatches/English/book-remove-chapter-numbers-en.patch --output=EmotionCode/book-no-chapter-numbers.html
patch EmotionCode/book-no-chapter-numbers.html --input=EmotionCode/BookPatches/English/book-fix-warnings-en.patch --output=EmotionCode/book-fixed.html

rm EmotionCode/book-with-chapters.html
rm EmotionCode/book-no-chapter-numbers.html

patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter1-en.patch --output=EmotionCode/chapter1.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter2-en.patch --output=EmotionCode/chapter2.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter3-en.patch --output=EmotionCode/chapter3.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter4-en.patch --output=EmotionCode/chapter4.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter5-en.patch --output=EmotionCode/chapter5.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter6-en.patch --output=EmotionCode/chapter6.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter7-en.patch --output=EmotionCode/chapter7.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter8-en.patch --output=EmotionCode/chapter8.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter9-en.patch --output=EmotionCode/chapter9.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter10-en.patch --output=EmotionCode/chapter10.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter11-en.patch --output=EmotionCode/about-author.html

rm EmotionCode/book-fixed.html

cp EmotionCode/chapter1.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter2.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter3.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter4.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter5.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter6.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter7.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter8.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter9.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/chapter10.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/
cp EmotionCode/about-author.html ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/