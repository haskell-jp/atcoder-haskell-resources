# 環境構築方法について

[ghcup](https://www.haskell.org/ghcup/) を使った環境構築方法を採用したいと思います。ghcup は [rustup](https://rustup.rs/) と同じような環境構築ツールです。

`ghcup` は比較的最近出てきたツールなので、使ったことが無い方も多いとは思いますが、コンパイラ (ghc) とビルドツール (cabal-install) のセットアップを自動的に行います。

この作業によって、以下のバージョンの `ghc`, `cabal` がインストールされます。(2019/7/8 確認)

　| バージョン
----|----
ghc | 8.6.5
cabal | 2.4.1.0

## 依存関係のインストール

事前に `apt-get` でインストールする依存関係は以下の通りです。

- curl
- coreutils
- g++
- gcc
- libgmp-dev
- libnuma-dev
- libtinfo-dev
- make
- ncurses-dev
- python3
- realpath
- xz-utils

上記のリストは `ghcup print-system-reqs` の結果によるものです。

```shell
$ ghcup --version
0.0.7

$ ghcup print-system-reqs
curl g++ gcc libgmp-dev libtinfo-dev make ncurses-dev python3 realpath xz-utils
```

### 注意点 1)

上記のリストには含まれていませんが、`libnuma-dev` も必要なのでインストールしています。([Manual libnuma install required](https://gitlab.haskell.org/haskell/ghcup/issues/58))

### 注意点 2)

`realpath` は Ubuntu 18.04 に含まれていないため `coreutils` をインストールしています。([Get rid of realpath](https://gitlab.haskell.org/haskell/ghcup/issues/31))

## 環境構築

インストール手順については [Dockerfile](./Dockerfile) にまとめました。この手順で行う内容は以下の通りです。

1. 依存関係のインストール
1. ghcup による環境構築
1. cabal による追加パッケージのインストール (追加パッケージのインストール方法を示すための例なので `mwc-random` と `vector-algorithms` しか今の所追加していません)

### 確認手順

以下の手順で動作確認が可能です。

```
$ docker build -t atcoder-env .
$ docker run --rm -it atcoder-env bash

# ghc -V
The Glorious Glasgow Haskell Compilation System, version 8.6.5

# cabal -V
cabal-install version 2.4.1.0
compiled using version 2.4.1.0 of the Cabal library

# echo -e "import System.Random.MWC\nmain = createSystemRandom >>= uniform >>= (print :: Int -> IO ())" > A.hs
# ghc -o a.out -O2 A.hs
# ./a.out
-2530740540117274139
```

### 注意点 1

`Dockerfile` の以下の部分のみ、実際にインストールを行う AtCoder の環境によっては、少し変化するかもしれません。

```dockefile
ENV PATH ~/.cabal/bin:/root/.ghcup/bin:$PATH
RUN echo "source /root/.ghcup/env" >> ~/.bashrc
```

### 注意点 2

パッケージを追加する場合は `cabal install --global mwc-random` のように `--global` オプションを追加します。

このオプションが無い場合は `--user` が指定されたことになり、`unix` ユーザーが変わると見えなくなってしまいます。
