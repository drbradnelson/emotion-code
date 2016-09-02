#!/usr/bin/env bash -e

pushd ../
patch Resources/English/The\ Emotion\ Code\,\ November\ 2015.html  --input=Sources/EmotionCode/BookPatches/English/book-add-chapters.patch --output=Sources/EmotionCode/book-with-chapters.html
popd
patch EmotionCode/book-with-chapters.html --input=EmotionCode/BookPatches/English/book-remove-chapter-numbers.patch --output=EmotionCode/book-no-chapter-numbers.html
patch EmotionCode/book-no-chapter-numbers.html --input=EmotionCode/BookPatches/English/book-fix-warnings.patch --output=EmotionCode/book-fixed.html

rm EmotionCode/book-with-chapters.html
rm EmotionCode/book-no-chapter-numbers.html

patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter1.patch --output=EmotionCode/chapter1.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter2.patch --output=EmotionCode/chapter2.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter3.patch --output=EmotionCode/chapter3.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter4.patch --output=EmotionCode/chapter4.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter5.patch --output=EmotionCode/chapter5.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter6.patch --output=EmotionCode/chapter6.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter7.patch --output=EmotionCode/chapter7.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter8.patch --output=EmotionCode/chapter8.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter9.patch --output=EmotionCode/chapter9.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter10.patch --output=EmotionCode/chapter10.html
patch EmotionCode/book-fixed.html --input=EmotionCode/BookPatches/English/chapter11.patch --output=EmotionCode/chapter11.html