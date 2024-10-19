## 概要

この terraform ファイルは、任意の AWS アカウントのリソースを terraform cloud を使用して管理するために必要な IAM 関連のリソースを作成するためのものです。

## 手順

> [!NOTE]
> リソース管理を行いたい AWS アカウントへ IAM リソースの作成権限を持つロールにて、AWS Identity Center による SSO ができることが前提です

terraform cloud へのワークスペースの作成方法は以下の記事を参考にしてください。

https://zenn.dev/sikmi_tech/articles/9f302b95105f50#terraform-cloud-%E4%B8%8A%E3%81%AB%E3%83%AF%E3%83%BC%E3%82%AF%E3%82%B9%E3%83%9A%E3%83%BC%E3%82%B9%E3%82%92%E4%BD%9C%E6%88%90

### 1. AWS リソースの作成

terraform.tfvars.example ファイルを以下のコマンドでコピーして、ファイル内の内容を適宜修正してください。

```sh
cp terraform.tfvars.example terraform.tefvars
```

ローカルにて、aws sso コマンドにてログインを行います。

```sh
aws sso login --profile=<your profile>
export AWS_PROFILE=<your profile>
```

terraform コマンドにて、リソースを作成します。

```sh
terraform apply
```

下記のように、role_arn が出力されるので、手元に控えておいてください。手順 2 で必要になります。

```sh
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

role_arn = "arn:aws:iam::xxxxxxx:role/terraform-cloud"
```

### 2. terraform cloud に環境変数を設定

作成したワークスペースの Variables に以下の環境変数を設定します。

> [!NOTE]
> 環境変数は Environment Variables で作成すること!

| 環境変数名            | 値                                  |
| --------------------- | ----------------------------------- |
| TFC_AWS_PROVIDER_AUTH | true                                |
| TFC_AWS_RUN_ROLE_ARN  | 手元に控えておいた IAM ロールの ARN |

参考: https://zenn.dev/sikmi_tech/articles/9f302b95105f50#terraform-cloud-%E3%81%AB%E7%92%B0%E5%A2%83%E5%A4%89%E6%95%B0%E3%82%92%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B
