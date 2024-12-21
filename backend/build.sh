#!/bin/bash

# Set working directories
WORK_DIR=$(pwd)/$1
SRC_DIR="$WORK_DIR/src"
BUILD_DIR="$WORK_DIR/build"
ZIP_FILE="$WORK_DIR/lambda_function.zip"

# Remove old build directory and ZIP file
rm -rf $BUILD_DIR
rm -f $ZIP_FILE

# Create new build directory
mkdir -p $BUILD_DIR

# Copy source code to build directory
cp $SRC_DIR/lambda_function.py $BUILD_DIR/

pip install -r $WORK_DIR/requirements.txt -t $BUILD_DIR

# Compress build directory to ZIP file
cd $BUILD_DIR
zip -r $ZIP_FILE .

# Return to working directory
cd $WORK_DIR

echo "Lambda function ZIP file created: $ZIP_FILE"