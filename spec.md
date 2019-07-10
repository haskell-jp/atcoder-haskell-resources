# はじめに

[ghcup](https://www.haskell.org/ghcup/) を使った環境構築方法を採用したいと思います。ghcup は [rustup](https://rustup.rs/) と同じような環境構築ツールです。

`ghcup` は比較的最近出てきたツールなので、使ったことが無い方も多いとは思いますが、コンパイラ (ghc) とビルドツール (cabal-install) のセットアップを自動的に行います。

この作業によって、以下のバージョンの `ghc`, `cabal` がインストールされます。(2019/7/10 確認)

　| バージョン
----|----
ghc | 8.6.5
cabal | 2.4.1.0
ghcup | 0.0.7

また、検証を行なったマシン環境は以下の通りです。

```
$ uname -a
Linux ip-***_***_***_*** 4.15.0-1043-aws #45-Ubuntu SMP Mon Jun 24 14:07:03 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.2 LTS"
```

## 環境構築手順

```
$ sudo apt-get update
$ sudo apt-get install -y curl g++ gcc libgmp-dev libtinfo-dev make ncurses-dev python3 libnuma-dev coreutils

$ export GHCUP_META_DOWNLOAD_URL=https://raw.githubusercontent.com/haskell-jp/atcoder-haskell-resources/master/download-urls

$ curl https://get-ghcup.haskell.org -sSf | sh
# 途中で何度かインストール作業がストップすることがありますが、その都度エンターキーを押して進みます。
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

## 追加パッケージのインストール手順

```
$ cabal v2-update
$ cabal v2-install --global --lib mwc-random-0.14.0.0 vector-algorithms-0.8.0.1
```

上記手順により、以下のパッケージがインストールされます。

- mwc-random-0.14.0.0
- vector-algorithms-0.8.0.1

## 動作確認

以下の手順で動作確認が可能です。

```
$ ghc -V
The Glorious Glasgow Haskell Compilation System, version 8.6.5

$ cabal -V
cabal-install version 2.4.1.0
compiled using version 2.4.1.0 of the Cabal library

$ echo -e "import System.Random.MWC\nmain = createSystemRandom >>= uniform >>= (print :: Int -> IO ())" > A.hs
$ ghc -o a.out -O2 A.hs
$ ./a.out
-2530740540117274139
```

## 補足事項

### 環境構築について

`ghcup` が提供しているスクリプトをそのまま Ubuntu 18.04 で利用すると、以下のエラーが発生してしまいます。

```
"/home/ubuntu/.ghcup/ghc/8.6.5/lib/ghc-8.6.5/bin/ghc-pkg" --force --global-package-db "/home/ubuntu/.ghcup/ghc/8.6.5/lib/ghc-8.6.5/package.conf.d" update rts/dist/package.conf.install
/home/ubuntu/.ghcup/ghc/8.6.5/lib/ghc-8.6.5/bin/ghc-pkg: error while loading shared libraries: libtinfo.so.6: cannot open shared object file: No such file or directory
ghc.mk:985: recipe for target 'install_packages' failed
make[1]: *** [install_packages] Error 127
Makefile:51: recipe for target 'install' failed
make: *** [install] Error 2
Failed to install, consider updating this script via: ghcup upgrade
"ghcup --cache install" failed!
```

この問題を回避するため、インストール手順の中では、オリジナルのスクリプトファイルを一部修正したものを利用するように `GHCUP_META_DOWNLOAD_URL` を設定しています。

```
$ export GHCUP_META_DOWNLOAD_URL=https://raw.githubusercontent.com/haskell-jp/atcoder-haskell-resources/master/download-urls
```

オリジナルファイルとの差分は以下の通りです。

```diff
diff --git a/download-urls b/download-urls
index b5b0253..ad63b04 100644
--- a/download-urls
+++ b/download-urls
@@ -85,7 +85,7 @@ ghc 8.6.4   x86_64  alpine                              https://github.com/redne
 
 ghc 8.6.5   i386    debian=9,debian,ubuntu,mint,unknown https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-i386-deb9-linux.tar.xz
 ghc 8.6.5   x86_64  debian=8                            https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb8-linux.tar.xz
-ghc 8.6.5   x86_64  debian=9,debian,mint                https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb9-linux.tar.xz
+ghc 8.6.5   x86_64  debian=9,debian,mint,ubuntu=18.04   https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb9-linux.tar.xz
 ghc 8.6.5   x86_64  fedora=27,fedora,ubuntu,unknown     https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-fedora27-linux.tar.xz
 ghc 8.6.5   x86_64  centos=7,centos,amazonlinux         https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-centos7-linux.tar.xz
 ghc 8.6.5   x86_64  darwin                              https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-apple-darwin.tar.xz
```

### 依存関係について

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
$ ghcup print-system-reqs
curl g++ gcc libgmp-dev libtinfo-dev make ncurses-dev python3 realpath xz-utils
```

#### 注意点 1)

上記のリストには含まれていませんが、`libnuma-dev` も必要なのでインストールしています。([Manual libnuma install required](https://gitlab.haskell.org/haskell/ghcup/issues/58))

#### 注意点 2)

`realpath` は Ubuntu 18.04 に含まれていないため `coreutils` をインストールしています。([Get rid of realpath](https://gitlab.haskell.org/haskell/ghcup/issues/31))

### 追加パッケージのインストールについて

#### 注意点 1)

パッケージを追加する場合は `cabal install --global mwc-random` のように `--global` オプションを追加します。

このオプションが無い場合は `--user` が指定されたことになり、`unix` ユーザーが変わると見えなくなってしまいます。
