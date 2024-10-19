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
cp terraform.tfvars.example terraform.tfvars
```

ローカルにて、aws sso コマンドにてログインを行います。

```sh
aws sso login --profile=<your profile>
export AWS_PROFILE=<your profile>
```

terraform コマンドにて、リソースを作成します。

```sh
terraform init
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

### 3. 動作確認

最後に、terraform cloud によるリソース管理が期待通りに動くかを確認します。

下記のコマンドを実施して、terraform cloud との認証を行います。

```sh
terraform login
```

> [!IMPORTANT]
> ログイン時、API キーを払い出す必要がありますが、有効期限は 1 日と短くしてください。(できれば、動作確認後に API キーを削除してください)
>
> 実際のリソース管理は、Github Application を利用した CI/CD によるリソース管理を想定しているためです。

認証に完了後、`aws/environment` 配下に任意のディクレトリを配置して、main.tf ファイルを作成します。

```sh
# イメージ
├── environment
│   └── prod
│       └── main.tf
```

main.tf に以下の内容を設定してください。また、コメントされている 2 箇所に適当な値を設定してください。

```hcl:main.tf
terraform {
  cloud {
    # terraform cloud の組織名を設定してください
    organization = "xxxxxx"

    # terraform cloud のワークスペース名
    workspaces {
      name = "xxxxxx"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
```

最後に、terraform apply コマンドを実行して、エラーが出なければ動作確認は完了です!

```sh
terraform init
terraform apply
```
