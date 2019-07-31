# はじめに

[ghcup](https://www.haskell.org/ghcup/) を使った環境構築方法を採用したいと思います。ghcup は [rustup](https://rustup.rs/) と同じような環境構築ツールです。

`ghcup` は比較的最近出てきたツールなので、使ったことが無い方も多いとは思いますが、コンパイラ (ghc) とビルドツール (cabal-install) のセットアップを自動的に行います。

この作業によって、以下のバージョンの `ghc`, `cabal` がインストールされます。(2019/7/31 確認)

　| バージョン
----|----
ghc | 8.6.5
cabal | 2.4.1.0
ghcup | 0.0.7

また、検証を行なったマシン環境は以下の通りです。

```
$ uname -a
Linux ip-***-***-***-*** 4.15.0-1044-aws #46-Ubuntu SMP Thu Jul 4 13:38:28 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.2 LTS"
```

## 環境構築手順

この作業によって ghcup, GHC, cabal がインストールされます。

```
$ sudo apt-get update
$ sudo apt-get install -y build-essential curl libgmp-dev libffi-dev libncurses-dev libnuma-dev

$ curl https://get-ghcup.haskell.org -sSf | sh
# 途中で何度かインストール作業がストップすることがありますが、その都度エンターキーを押して進みます。

Installation done!

Don't forget to source /home/ubuntu/.ghcup/env in your ~/.bashrc or similar.
```

あとはパスを通せば完了です。

```
$ echo "source ~/.ghcup/env" >> ~/.bashrc
```

`~/.ghcup/env` ファイルの内容は以下の通りです。

```
$ cat ~/.ghcup/env
export PATH="$HOME/.cabal/bin:${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/bin:$PATH"
```

インストールされたツールのバージョンは以下コマンドで確認できます。

```
$ ghcup -V
0.0.7

$ cabal -V
cabal-install version 2.4.1.0
compiled using version 2.4.1.0 of the Cabal library

$ ghc -V
The Glorious Glasgow Haskell Compilation System, version 8.6.5
```

## 追加パッケージのインストール手順

```
$ cabal v2-install --global --lib mwc-random-0.14.0.0 vector-algorithms-0.8.0.1
```

上記手順により、以下のパッケージがインストールされます。

- mwc-random-0.14.0.0
- vector-algorithms-0.8.0.1

## 動作確認

以下の手順で動作確認が可能です。

```
$ echo -e "import System.Random.MWC\nmain = createSystemRandom >>= uniform >>= (print :: Int -> IO ())" > A.hs

$ ghc -o a.out -O2 A.hs
$ ./a.out
-2530740540117274139
```

## 補足事項

### 依存関係について

事前に `apt-get` でインストールする依存関係は以下の通りです。

- build-essential
- curl
- libgmp-dev
- libffi-dev
- libncurses-dev
- libnuma-dev

上記のリストは `ghcup print-system-reqs` の結果によるものです。

```shell
$ ghcup print-system-reqs
build-essential curl libgmp-dev libffi-dev libncurses-dev
```

#### 注意点

`ghcup print-system-reqs` の結果には含まれていませんが、`libnuma-dev` も必要なのでインストールしています。([Manual libnuma install required](https://gitlab.haskell.org/haskell/ghcup/issues/58))

### 追加パッケージのインストールについて

パッケージを追加する場合は `cabal install --global mwc-random` のように `--global` オプションを追加します。

このオプションが無い場合は `--user` が指定されたことになり、`unix` ユーザーが変わると見えなくなってしまいます。
