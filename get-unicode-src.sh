#!/bin/bash

VER=15
DIR=UCD.v$VER.0

rm -rf $DIR
mkdir $DIR
cd $DIR
wget https://www.unicode.org/Public/zipped/$VER.0.0/UCD.zip
unzip UCD.zip
rm UCD.zip


