## 【概要】
AWS EC2→S3へファイルをロードするデータパイプラインのジョブセットです。  

## 【前提】
・2台のEC2インスタンスを使用します。（プログラム配置用インスタンス、ファイル配置用インスタンス）  
・ファイル配置用インスタンスには、AWS CLIのインストール並びに、S3へのアクセス許可があるIAMロールをアタッチする必要があります。     
・/tmp/logディレクトリ配下にログを出力します。（適宜変更して下さい。）  

## 【ジョブの構成（1から3まで順次実行）】
1. **ファイルチェックジョブ**  
　　`ec2tos3_checkfile.sh`
2. **S3ロードジョブ**  
　　`ec2tos3_s3road.sh`
3. **ファイル削除ジョブ**  
　　`ec2tos3_removefile.sh`

## 【.properties例】
```
# ファイル配置用インスタンス情報
transfer_server=ファイル配置用インスタンスのIPアドレス
username=ファイル配置用インスタンスのユーザー名
pemkey=ファイル配置用インスタンスの秘密鍵パス（プログラム配置用インスタンスに配置）

# ファイルパス
receive_if=ファイルパス

# S3バケット名
s3bucket=S3バケット名

#S3プレフィックス名
s3preffix=S3プレフィックス名

#S3サフィックス名
s3suffix=S3サフィックス名
```

## 【プログラム実行コマンド例】
```
./ec2tos3_checkfile.sh ./test.properties
./ec2tos3_s3road.sh ./test.properties
./ec2tos3_removefile.sh ./test.properties
```

## 【図式化】
![データパイプラインサンプル-ページ2](https://github.com/user-attachments/assets/af70edf1-d537-4f48-9edd-0ec4515dcf3e)



