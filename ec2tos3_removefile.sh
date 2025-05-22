#!/bin/bash

INFO_LOG="/tmp/log/ec2tos3_removefile_info.log"
ERROR_LOG="/tmp/log/ec2tos3_removefile_error.log"

# 出力を振り分け
exec 1>>"$INFO_LOG"
exec 2>>"$ERROR_LOG"

echo "===== $(date '+%Y-%m-%d %H:%M:%S') : EC2→S3ジョブネット_ファイル削除ジョブ開始 =====" >&1

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

# 転送サーバーのIF削除
ssh -i "$PEMKEY" -o StrictHostKeyChecking=no "${USERNAME}@${TRANSFER_SERVER}" "rm -f ${REMOTE_FILE}"

# IF削除判定
if [ $? -eq 0 ]; then 
    echo "IF削除正常終了です。"
    echo "===== $(date '+%Y-%m-%d %H:%M:%S') : EC2→S3ジョブネット_ファイル削除ジョブ終了 =====" >&1
    exit 0
else
    echo "IF削除で異常終了しました。"
    exit 1
fi