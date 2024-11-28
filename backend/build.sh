#!/bin/bash

# 作業ディレクトリを設定
WORK_DIR=$(pwd)/$1
SRC_DIR="$WORK_DIR/src"
BUILD_DIR="$WORK_DIR/build"
ZIP_FILE="$WORK_DIR/lambda_function.zip"

# 古いビルドディレクトリとZIPファイルを削除
rm -rf $BUILD_DIR
rm -f $ZIP_FILE

# 新しいビルドディレクトリを作成
mkdir -p $BUILD_DIR

# ソースコードをビルドディレクトリにコピー
cp $SRC_DIR/lambda_function.py $BUILD_DIR/

pip install -r $WORK_DIR/requirements.txt -t $BUILD_DIR

# # ビルドディレクトリをZIPファイルに圧縮
# cd $BUILD_DIR
# zip -r $ZIP_FILE .

# # 作業ディレクトリに戻る
# cd $WORK_DIR

# echo "Lambda関数のZIPファイルが作成されました: $ZIP_FILE"