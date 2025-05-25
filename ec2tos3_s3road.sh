#!/bin/bash

INFO_LOG="/home/ec2-user/log/ec2tos3_s3road_info.log"
ERROR_LOG="/home/ec2-user/log/ec2tos3_s3road_error.log"

# 出力を振り分け
exec 1>>"$INFO_LOG"
exec 2>>"$ERROR_LOG"

echo "===== $(date '+%Y-%m-%d %H:%M:%S') : EC2→S3ジョブネット_S3ロードジョブ開始 =====" >&1

# 引数のチェック
if [ -z "$1" ]; then
  echo "エラー: 第一引数を設定してください。" >&2
  exit 1
fi

# プロパティファイルの読み込み
if [ -f "$1" ]; then
  source "$1"
else
  echo "エラー: 指定されたファイルが存在しません: $1" >&2
  exit 1
fi

# 転送サーバーの情報
TRANSFER_SERVER="${transfer_server}"
USERNAME="${username}"
PEMKEY="${pemkey}"

# 転送サーバーのIF情報
REMOTE_FILE="${receive_if}"

# 転送先S3情報
S3_BUCKET="${s3bucket}"
S3_PREFIX="${s3preffix}"
S3_SUFFIX="${s3suffix}"

# 転送先S3フルパス作成
S3FULLPATH="${S3_BUCKET}${S3_PREFIX}${S3_SUFFIX}"

# S3ロード実行
ssh -i "$PEMKEY" -o StrictHostKeyChecking=no "${USERNAME}@${TRANSFER_SERVER}" "aws s3 cp ${REMOTE_FILE} ${S3FULLPATH}"

# S3ロード結果の判定
if [ $? -eq 0 ]; then
    echo "S3ロード正常終了です。"
    echo "===== $(date '+%Y-%m-%d %H:%M:%S') : EC2→S3ジョブネット_S3ロードジョブ終了 =====" >&1
    exit 0
else
    echo "S3ロードで異常終了しました。"
    exit 1
fi

