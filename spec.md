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

```
$ sudo apt-get update
$ sudo apt-get install -y build-essential curl libgmp-dev libffi-dev libncurses-dev libnuma-dev

$ curl https://get-ghcup.haskell.org -sSf | sh
# 途中で何度かインストール作業がストップすることがありますが、その都度エンターキーを押して進みます。

$ echo "source ~/.ghcup/env" >> ~/.bashrc
$ source ~/.bashrc

$ cabal v2-install --global --lib \
    array-0.5.3.0 \
    attoparsec-0.13.2.2 \
    bytestring-0.10.8.2 \
    containers-0.6.0.1 \
    fgl-5.7.0.1 \
    mtl-2.2.2 \
    parsec-3.1.13.0 \
    primitive-0.7.0.0 \
    text-1.2.3.1 \
    unordered-containers-0.2.10.0 \
    vector-0.12.0.3 \
    extra-1.6.17 \
    heaps-0.3.6.1 \
    lens-4.17.1 \
    massiv-0.4.0.0 \
    mwc-random-0.14.0.0 \
    psqueues-0.2.7.2 \
    reflection-2.1.4 \
    repa-3.4.1.4 \
    unboxing-vector-0.1.1.0 \
    utility-ht-0.0.14 \
    vector-algorithms-0.8.0.1
```

## 解説

### コンパイラ等のインストール

この作業によって ghcup, GHC, cabal がインストールされます。(apt-get でインストールするものについては補足事項を参照ください)

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

### 追加パッケージ

インストールされているパッケージは以下のコマンドで確認できます。

```
$ ghc-pkg list --global
```

#### 現状の AtCoder で利用可能なパッケージ

現在の AtCoder 環境に含まれているパッケージで、引き続きインストールするパッケージを以下の表にまとめました。([Full Platformで入るパッケージの早見表](https://www.haskell.org/platform/contents.html))

パッケージのバージョンは基本的に最新のものを入れます。各パッケージのバージョンについては [Hackage](https://hackage.haskell.org/) で確認することができます。

パッケージ名 | 既存バージョン | 提案バージョン
-----------|-----|-----
array | [0.5.1.0](https://hackage.haskell.org/package/array-0.5.1.0) | [0.5.3.0](https://hackage.haskell.org/package/array-0.5.3.0)
attoparsec | [0.13.0.1](https://hackage.haskell.org/package/attoparsec-0.13.0.1) | [0.13.2.2](https://hackage.haskell.org/package/attoparsec-0.13.2.2)
bytestring | [0.10.6.0](https://hackage.haskell.org/package/bytestring-0.10.6.0) | [0.10.8.2](https://hackage.haskell.org/package/bytestring-0.10.8.2)
containers | [0.5.6.2](https://hackage.haskell.org/package/containers-0.5.6.2) | [0.6.0.1](https://hackage.haskell.org/package/containers-0.6.0.1)
fgl | [5.5.2.3](https://hackage.haskell.org/package/fgl-5.5.2.3) | [5.7.0.1](https://hackage.haskell.org/package/fgl-5.7.0.1)
mtl | [2.2.1](https://hackage.haskell.org/package/mtl-2.2.1) | [2.2.2](https://hackage.haskell.org/package/mtl-2.2.2)
parsec | [3.1.9](https://hackage.haskell.org/package/parsec-3.1.9) | [3.1.13.0](https://hackage.haskell.org/package/parsec-3.1.13.0)
primitive | [0.6.1.0](https://hackage.haskell.org/package/primitive-0.6.1.0) | [0.7.0.0](https://hackage.haskell.org/package/primitive-0.7.0.0)
text | [1.2.1.3](https://hackage.haskell.org/package/text-1.2.1.3) | [1.2.3.1](https://hackage.haskell.org/package/text-1.2.3.1)
unordered-containers | [0.2.5.1](https://hackage.haskell.org/package/unordered-containers-0.2.5.1) | [0.2.10.0](https://hackage.haskell.org/package/unordered-containers-0.2.10.0)
vector | [0.11.0.0](https://hackage.haskell.org/package/vector-0.11.0.0) | [0.12.0.3](https://hackage.haskell.org/package/vector-0.12.0.3)

#### 現状の AtCoder 環境に含まれていないパッケージ一覧

今回の言語アップデートで、新たに追加したいパッケージを以下の表にまとめました。

パッケージ名 | 最新バージョン | 追加理由
-----------|------|--------
extra | [1.6.17](https://hackage.haskell.org/package/extra-1.6.17) | Prelude に定義されていない、あったら便利な関数が多数定義されているため。
heaps | [0.3.6.1](https://hackage.haskell.org/package/heaps-0.3.6.1)
lens | [4.17.1](https://hackage.haskell.org/package/lens-4.17.1)
massiv | [0.4.0.0](https://hackage.haskell.org/package/massiv-0.4.0.0) | 高次元のaligned vectorを扱うmoduleであって，「mutable <-> immutable 相互変換可能」「map,fold等がそのまま使える」を満たしているものとして希望した．
mwc-random | [0.14.0.0](https://hackage.haskell.org/package/mwc-random-0.14.0.0) | System.Random では乱数を生成するため。
psqueues | [0.2.7.2](https://hackage.haskell.org/package/psqueues-0.2.7.2)
reflection | [2.1.4](https://hackage.haskell.org/package/reflection-2.1.4)
repa | [3.4.1.4](https://hackage.haskell.org/package/repa-3.4.1.4)
unboxing-vector | [0.1.1.0](https://hackage.haskell.org/package/unboxing-vector-0.1.1.0) | [unboxing-vectorの紹介：newtypeフレンドリーなunboxed vector](https://qiita.com/mod_poppo/items/cf6b66ff16464c170ac2) を参照してください。
utility-ht | [0.0.14](https://hackage.haskell.org/package/utility-ht)
vector-algorithms | [0.8.0.1](https://hackage.haskell.org/package/vector-algorithms-0.8.0.1) | Vector のソートを行うため。

#### パッケージのインストール

以下のコマンドでパッケージをインストールできます。

また、`--global` オプションを指定しない場合、`--user` が指定されたことになり、`unix` ユーザーが変わると見えなくなってしまいます。

```
$ cabal v2-install --global --lib \
    array-0.5.3.0 \
    attoparsec-0.13.2.2 \
    bytestring-0.10.8.2 \
    containers-0.6.0.1 \
    fgl-5.7.0.1 \
    mtl-2.2.2 \
    parsec-3.1.13.0 \
    primitive-0.7.0.0 \
    text-1.2.3.1 \
    unordered-containers-0.2.10.0 \
    vector-0.12.0.3 \
    extra-1.6.17 \
    heaps-0.3.6.1 \
    lens-4.17.1 \
    massiv-0.4.0.0 \
    mwc-random-0.14.0.0 \
    psqueues-0.2.7.2 \
    reflection-2.1.4 \
    repa-3.4.1.4 \
    unboxing-vector-0.1.1.0 \
    utility-ht-0.0.14 \
    vector-algorithms-0.8.0.1
```

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
