# k8s-ec2-terraformの概要
本ツールは、Terraformを使ってKubernetesクラスター用のAWSのEC2インスタンス、およびそれに関連するリソースを作成するものです。<br>
Kubernetesクラスターの構築を完成させるには、このツールでEC2インスタンスを作成した後に[k8s-setup](https://github.com/showchan33/k8s-setup/tree/main)をお使いください。

## 作成するAWSリソースの概要

* EC2インスタンス
    * Control Plane用: 1台
    * Workerノード用: 1台以上
* EC2インスタンスにSSHでアクセスするための各種リソース
    * Internet Gatewayにより、各EC2インスタンスにパブリックIPによりSSH接続できます

# 必要条件

* Terraformがインストールされていること
    * 動作確認バージョンはv1.8.4
* AWSアカウントを持っており、各リソースを作成可能なIAMユーザが存在すること

# 事前準備

## terraform.tfvars ファイルの作成

``terraform.tfvars.sample``を参考に、``terraform.tfvars``を作成します。<br>
以後、リソースの作成に必要な設定は全て``terraform.tfvars``で行います。

## SSH接続用の公開鍵と秘密鍵の準備

EC2インスタンスにSSH接続するための公開鍵と秘密鍵を準備します。<br>
以下は新たに鍵を作成する際のコマンドの例です。

```
ssh-keygen -b 4096 -f ./files/sshkey
```

デフォルトでは、EC2インスタンスに格納する公開鍵ファイルのパスは``./files/sshkey.pub``になっています。必要に応じて、各キー``ssh_pubkey``で指定される公開鍵のパスを書き換えてください。

## SSH接続元のIPアドレスを指定

以下の値を、EC2にSSHで接続する際のクライアントのIPアドレスに書き換えます。

```tfvars
security_group = {
  ...
  # Write down the IP address to SSH to the EC2 instance
  cidr_blocks_for_ssh = ["111.222.333.444/32"]
}
```

## セキュリティグループに追加するingressルールの指定

必要に応じて、``ingress_rules_k8s_additional``のセキュリティグループのルールを書き換えます。<br>
以下はKubernetesのCNI(Container Network Interface)にFlannelを使う場合の例ですが、他のCNIを使う場合はそれぞれに応じたルールに変更してください。

```tfvars
ingress_rules_k8s_additional = {
  # Example of using Flannel for CNI
  flannel = {
    from_port = 8472
    to_port   = 8472
    protocol  = "udp"
  }
}
```

## その他の設定

``terraform.tfvars``の各値を適宜変更してください。

# EC2インスタンスの作成

以下のコマンドを順番に実行してリソースを作成します。

```
terraform init
terraform plan
terraform apply
```

# EC2インスタンスにSSHで接続できることの確認

作成したEC2インスタンスにSSHでアクセスできることを確認します。<br>
各EC2インスタンスのパブリックIPアドレスは、``terraform apply``で最後に出力される``Outputs:``で確認できます。

```
ssh -i [秘密鍵ファイル名] [username]@[public-ip-of-ec2]
```

# Kubernetesクラスターを作成する手順

EC2インスタンスが作成できた後は、[k8s-setup](https://github.com/showchan33/k8s-setup/tree/main)を使ってKubernetesクラスターを構築できます。

# Author
showchan33

# License
"k8s-ec2-terraform" is under [GPL license](https://www.gnu.org/licenses/licenses.en.html).
