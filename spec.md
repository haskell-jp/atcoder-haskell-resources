# はじめに

[ghcup](https://www.haskell.org/ghcup/) を使った環境構築方法を採用したいと思います。ghcup は [rustup](https://rustup.rs/) と同じような環境構築ツールです。

`ghcup` は比較的最近出てきたツールなので、使ったことが無い方も多いとは思いますが、コンパイラ (ghc) とビルドツール (cabal-install) のセットアップを自動的に行います。

この作業によって、以下のバージョンの `ghc`, `cabal` がインストールされます。(2020/4/2 確認)

　| バージョン
----|----
ghc | 8.8.3
cabal | 3.0.0.0
ghcup | 0.0.8

また、検証を行なったマシン環境は以下の通りです。

```
$ uname -a
Linux ip-***-***-***-*** 4.15.0-1057-aws #59-Ubuntu SMP Wed Dec 4 10:02:00 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.3 LTS"
```

## 環境構築手順

ユーザおよび、インストール先ディレクトリ等は適宜ご変更ください。

設定項目 | 値
-------|------
ユーザ名 | `ubuntu`
ghc 等のインストール場所 | `/opt`
インストールしたパッケージの保存場所 | `/opt/.cabal/store`
パッケージデータベースの保存場所 | `/opt/.cabal/store/ghc-8.6.5/package.db`
package environment file の保存場所 | `/opt/.cabal/global.env`

新たに追加する環境変数 | 値
-------------------|-----------
GHCUP_INSTALL_BASE_PREFIX | `/opt`
GHC_ENVIRONMENT | `/opt/.cabal/global.env`

```
$ sudo apt-get update
$ sudo apt-get install -y build-essential curl libgmp-dev libffi-dev libncurses-dev libnuma-dev libtinfo5

$ echo "export GHCUP_INSTALL_BASE_PREFIX=/opt" >> ~/.bashrc
$ source ~/.bashrc
$ sudo chown ubuntu:ubuntu /opt

$ curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# 途中で何度かインストール作業がストップすることがありますが、その都度エンターキーを押して進みます。

# Detected bash shell on your system...
# If you want ghcup to automatically add the required PATH variable to "/home/ubuntu/.bashrc"
# answer with YES, otherwise with NO and press ENTER.
＃ユーザ入力を求められるので `YES` と入力します。
YES

$ source ~/.bashrc

$ mkdir -p /opt/.cabal/store
$ ln -s /opt/.cabal/store /home/ubuntu/.cabal/store
$ cabal user-config update -a store-dir:/opt/.cabal/store
$ cabal user-config update -a package-db:/opt/.cabal/store

$ cabal install --lib --package-env /opt/.cabal/global.env \
    QuickCheck-2.13.2 \
    array-0.5.4.0 \
    attoparsec-0.13.2.4 \
    bytestring-0.10.10.0 \
    containers-0.6.2.1 \
    deepseq-1.4.4.0 \
    extra-1.7.1 \
    fgl-5.7.0.2 \
    hashable-1.3.0.0 \
    heaps-0.3.6.1 \
    integer-logarithms-1.0.3 \
    lens-4.19.1 \
    massiv-0.5.1.0 \
    mono-traversable-1.0.15.1 \
    mtl-2.2.2 \
    mutable-containers-0.3.4 \
    mwc-random-0.14.0.0 \
    parallel-3.2.2.0 \
    parsec-3.1.14.0 \
    primitive-0.7.0.1 \
    psqueues-0.2.7.2 \
    random-1.1 \
    reflection-2.1.5 \
    regex-tdfa-1.3.1.0 \
    repa-3.4.1.4 \
    template-haskell-2.15.0.0 \
    text-1.2.4.0 \
    tf-random-0.5 \
    transformers-0.5.6.2 \
    unboxing-vector-0.1.1.0 \
    unordered-containers-0.2.10.0 \
    utility-ht-0.0.15 \
    vector-0.12.1.2 \
    vector-algorithms-0.8.0.3 \
    vector-th-unbox-0.2.1.7
```

以下はコンテストユーザが行う設定です。

```
$ echo "export GHC_ENVIRONMENT=/opt/.cabal/global.env" >> ~/.bashrc
$ echo "export GHCUP_INSTALL_BASE_PREFIX=/opt" >> ~/.bashrc
$ echo "source /opt/.ghcup/env" >> ~/.bashrc
$ source ~/.bashrc
```

## 解説

### コンパイラ等のインストール

この作業によって ghcup, GHC, cabal がインストールされます。(apt-get でインストールされるパッケージについては補足事項を参照ください)

作業するユーザは `ubuntu` (管理者権限を持つユーザ) として進めます。また、インストール先ディレクトリは環境変数 `GHCUP_INSTALL_BASE_PREFIX` によって変更できます。

```
$ sudo apt-get update
$ sudo apt-get install -y build-essential curl libgmp-dev libffi-dev libncurses-dev libnuma-dev libtinfo5

# インストール先のディレクトリを指定します。(今回は /opt 以下にインストール)
$ echo "export GHCUP_INSTALL_BASE_PREFIX=/opt" >> ~/.bashrc
$ source ~/.bashrc
$ sudo chown ubuntu:ubuntu /opt

$ curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# 途中で何度かインストール作業がストップすることがありますが、その都度エンターキーを押して進みます。

Installation done!

In order to run ghc and cabal, you need to adjust your PATH variable.
You may want to source '/opt/.ghcup/env' in your shell
configuration to do so (e.g. ~/.bashrc).

Detected bash shell on your system...
If you want ghcup to automatically add the required PATH variable to "/home/ubuntu/.bashrc"
answer with YES, otherwise with NO and press ENTER.
```

ここでユーザ入力を求められるので `YES` と入力します。

```
YES
OK! /home/ubuntu/.bashrc has been modified. Restart your terminal for the changes to take effect,
or type "source /opt/.ghcup/env" to apply them in your current terminal session.
```

念のため `.bashrc` を再読み込みしておきます。

```
$ source ~/.bashrc
```

`/opt/.ghcup/env` ファイルの内容は以下の通りです。

```
$ cat /opt/.ghcup/env
export PATH="$HOME/.cabal/bin:${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/bin:$PATH"
```

#### バージョンの確認

インストールされたツールのバージョンは以下コマンドで確認できます。

```
$ ghcup -V
0.0.8

$ cabal -V
cabal-install version 3.0.0.0
compiled using version 3.0.0.0 of the Cabal library

$ ghc -V
The Glorious Glasgow Haskell Compilation System, version 8.8.3
```

### 追加パッケージ

#### 現状の AtCoder で利用可能なパッケージ

現在の AtCoder 環境に含まれているパッケージで、引き続きインストールするパッケージを以下の表にまとめました。([Full Platformで入るパッケージの早見表](https://www.haskell.org/platform/contents.html))

パッケージのバージョンは基本的に最新のものを入れます。各パッケージのバージョンについては [Hackage](https://hackage.haskell.org/) で確認することができます。

パッケージ名 | 既存バージョン | 提案バージョン
-----------|-----|-----
QuickCheck | [2.8.1](https://hackage.haskell.org/package/QuickCheck-2.8.1) | [2.13.2](https://hackage.haskell.org/package/QuickCheck-2.13.2)
array | [0.5.1.0](https://hackage.haskell.org/package/array-0.5.1.0) | [0.5.4.0](https://hackage.haskell.org/package/array-0.5.4.0)
attoparsec | [0.13.0.1](https://hackage.haskell.org/package/attoparsec-0.13.0.1) | [0.13.2.4](https://hackage.haskell.org/package/attoparsec-0.13.2.4)
bytestring | [0.10.6.0](https://hackage.haskell.org/package/bytestring-0.10.6.0) | [0.10.10.0](https://hackage.haskell.org/package/bytestring-0.10.10.0)
containers | [0.5.6.2](https://hackage.haskell.org/package/containers-0.5.6.2) | [0.6.2.1](https://hackage.haskell.org/package/containers-0.6.2.1)
deepseq | [1.4.1.1](https://hackage.haskell.org/package/deepseq-1.4.1.1) | [1.4.4.0](https://hackage.haskell.org/package/deepseq-1.4.4.0)
fgl | [5.5.2.3](https://hackage.haskell.org/package/fgl-5.5.2.3) | [5.7.0.2](https://hackage.haskell.org/package/fgl-5.7.0.2)
hashable | [1.2.3.3](https://hackage.haskell.org/package/hashable-1.2.3.3) | [1.3.0.0](https://hackage.haskell.org/package/hashable-1.3.0.0)
mtl | [2.2.1](https://hackage.haskell.org/package/mtl-2.2.1) | [2.2.2](https://hackage.haskell.org/package/mtl-2.2.2)
parallel | [3.2.0.6](https://hackage.haskell.org/package/parallel-3.2.0.6) | [3.2.2.0](https://hackage.haskell.org/package/parallel-3.2.2.0)
parsec | [3.1.9](https://hackage.haskell.org/package/parsec-3.1.9) | [3.1.14.0](https://hackage.haskell.org/package/parsec-3.1.14.0)
primitive | [0.6.1.0](https://hackage.haskell.org/package/primitive-0.6.1.0) | [0.7.0.1](https://hackage.haskell.org/package/primitive-0.7.0.1)
random | [1.1](https://hackage.haskell.org/package/random-1.1) | [1.1](https://hackage.haskell.org/package/random-1.1)
template-haskell | [2.10.0.0](https://hackage.haskell.org/package/template-haskell-2.10.0.0) | [2.15.0.0](https://hackage.haskell.org/package/template-haskell-2.15.0.0)
text | [1.2.1.3](https://hackage.haskell.org/package/text-1.2.1.3) | [1.2.4.0](https://hackage.haskell.org/package/text-1.2.4.0)
tf-random | [0.5](https://hackage.haskell.org/package/tf-random-0.5) | [0.5](https://hackage.haskell.org/package/tf-random-0.5)
transformers | [0.4.2.0](https://hackage.haskell.org/package/transformers-0.4.2.0) | [0.5.6.2](https://hackage.haskell.org/package/transformers-0.5.6.2)
unordered-containers | [0.2.5.1](https://hackage.haskell.org/package/unordered-containers-0.2.5.1) | [0.2.10.0](https://hackage.haskell.org/package/unordered-containers-0.2.10.0)
vector | [0.11.0.0](https://hackage.haskell.org/package/vector-0.11.0.0) | [0.12.1.2](https://hackage.haskell.org/package/vector-0.12.1.2)

#### 現状の AtCoder 環境に含まれていないパッケージ一覧

今回の言語アップデートで、新たに追加したいパッケージを以下の表にまとめました。

パッケージ名 | 提案バージョン | 追加理由
-----------|------|--------
extra | [1.7.1](https://hackage.haskell.org/package/extra-1.7.1) | Prelude に定義されていない、あったら便利な関数が多数定義されているため。
heaps | [0.3.6.1](https://hackage.haskell.org/package/heaps-0.3.6.1)
integer-logarithms | [1.0.3](https://hackage.haskell.org/package/integer-logarithms-1.0.3) | 整数の log を取るため。
lens | [4.19.1](https://hackage.haskell.org/package/lens-4.19.1)
massiv | [0.5.1.0](https://hackage.haskell.org/package/massiv-0.5.1.0) | 高次元の aligned vector を扱う module であって，「mutable <-> immutable 相互変換可能」「map,fold等がそのまま使える」を満たしているものとして希望した．
mono-traversable | [1.0.15.1](https://hackage.haskell.org/package/mono-traversable-1.0.15.1) | ByteString や Text 等を Foldable/Traversable っぽく扱うためのインターフェースを提供している。
mutable-containers | [0.3.4](https://hackage.haskell.org/package/mutable-containers-0.3.4) | Unboxed MutVar など、高速な手続き型アルゴリズムの実装に用いることのできるユーティリティを含むため。
mwc-random | [0.14.0.0](https://hackage.haskell.org/package/mwc-random-0.14.0.0) | System.Random の乱数生成処理が遅いため。[Haskellの乱数生成を勉強中 - 今度こそ最後か　やっとちゃんと速度測れた](http://blog.livedoor.jp/rtabaladi_58/archives/57642581.html) などの記事が参考になります。
psqueues | [0.2.7.2](https://hackage.haskell.org/package/psqueues-0.2.7.2)
reflection | [2.1.5](https://hackage.haskell.org/package/reflection-2.1.5) | 実行時の値に基づいた型レベル自然数を作るため。
regex-tdfa | [1.3.1.0](https://hackage.haskell.org/package/regex-tdfa-1.3.1.0) | 正規表現があるかないかでコーディング速度がかなり変わる問題が出るため [詳細](https://github.com/haskell-jp/atcoder-haskell-resources/issues/9#issuecomment-607603852)
repa | [3.4.1.4](https://hackage.haskell.org/package/repa-3.4.1.4)
unboxing-vector | [0.1.1.0](https://hackage.haskell.org/package/unboxing-vector-0.1.1.0) | [unboxing-vectorの紹介：newtypeフレンドリーなunboxed vector](https://qiita.com/mod_poppo/items/cf6b66ff16464c170ac2) を参照してください。
utility-ht | [0.0.15](https://hackage.haskell.org/package/utility-ht-0.0.15)
vector-algorithms | [0.8.0.3](https://hackage.haskell.org/package/vector-algorithms-0.8.0.3) | Vector のソートを行うため。
vector-th-unbox | [0.2.1.7](https://hackage.haskell.org/package/vector-th-unbox-0.2.1.7) | unboxing-vector に並び、newtype に対して unboxed Vector を用いるため。

#### パッケージのインストール

まずはパッケージのインストール先ディレクトリを変更します。通常のままだとインストールしたパッケージを別ユーザが利用できないため、このような変更を加えます。([5.3.1. Local versus external packages](https://www.haskell.org/cabal/users-guide/nix-local-build.html#local-versus-external-packages))

ここでは `/opt/.cabal/store` にパッケージをインストールします。また [Environment file from `cabal new-install ... --package-env .` has wrong store dir. #5925](https://github.com/haskell/cabal/issues/5925) の問題を回避するためにシンボリックリンクを張ります。

```
$ mkdir -p /opt/.cabal/store
$ ln -s /opt/.cabal/store /home/ubuntu/.cabal/store
$ cabal user-config update -a store-dir:/opt/.cabal/store
$ cabal user-config update -a package-db:/opt/.cabal/store
```

次に以下のコマンドでパッケージをインストールできます。

```
$ cabal install --lib --package-env /opt/.cabal/global.env \
    QuickCheck-2.13.2 \
    array-0.5.4.0 \
    attoparsec-0.13.2.4 \
    bytestring-0.10.10.0 \
    containers-0.6.2.1 \
    deepseq-1.4.4.0 \
    extra-1.7.1 \
    fgl-5.7.0.2 \
    hashable-1.3.0.0 \
    heaps-0.3.6.1 \
    integer-logarithms-1.0.3 \
    lens-4.19.1 \
    massiv-0.5.1.0 \
    mono-traversable-1.0.15.1 \
    mtl-2.2.2 \
    mutable-containers-0.3.4 \
    mwc-random-0.14.0.0 \
    parallel-3.2.2.0 \
    parsec-3.1.14.0 \
    primitive-0.7.0.1 \
    psqueues-0.2.7.2 \
    random-1.1 \
    reflection-2.1.5 \
    regex-tdfa-1.3.1.0 \
    repa-3.4.1.4 \
    template-haskell-2.15.0.0 \
    text-1.2.4.0 \
    tf-random-0.5 \
    transformers-0.5.6.2 \
    unboxing-vector-0.1.1.0 \
    unordered-containers-0.2.10.0 \
    utility-ht-0.0.15 \
    vector-0.12.1.2 \
    vector-algorithms-0.8.0.3 \
    vector-th-unbox-0.2.1.7
```

異なるユーザでパッケージを利用するためにオプションをいくつか指定します。

オプション | 内容
---------|--------
`--package-env` | `package environment file` の保存先とファイル名を指定します。(詳しくは [5.4.11. cabal v2-install](https://www.haskell.org/cabal/users-guide/nix-local-build.html#cabal-v2-install), [8.9.5.2. Package environments](https://downloads.haskell.org/~ghc/8.8.3/docs/html/users_guide/packages.html#package-environments) をご参照ください)

#### 追加されたパッケージの確認方法

インストールされているパッケージは以下のコマンドで確認できます。

```
$ ghc-pkg list --package-db=/opt/.cabal/store/ghc-8.8.3/package.db/
```

上記コマンドの出力のうち、実際に利用可能なパッケージは `package environment file` に列挙されているパッケージに制限されます。

```
$ cat /opt/.cabal/global.env
```

## 動作確認

以下の手順で動作確認が可能です。

`GHC_ENVIRONMENT` 環境変数に `package environment file` のパスを設定しておくと GHC は自動的にそのパスを参照します。

```
# パッケージデータベースの参照先を更新
$ echo "export GHC_ENVIRONMENT=/opt/.cabal/global.env" >> ~/.bashrc
$ source ~/.bashrc

$ echo -e "import System.Random.MWC\nmain = createSystemRandom >>= uniform >>= (print :: Int -> IO ())" > A.hs

$ ghc -o a.out -O2 A.hs
$ ./a.out
-2530740540117274139  # 乱数生成プログラムなので、実行結果は実行ごとに異なります
```

### ユーザを切り替えた場合の動作確認

以下の手順で動作確認が可能です。

```
$ sudo adduser contest
$ su contest
$ cd

$ echo "export GHC_ENVIRONMENT=/opt/.cabal/global.env" >> ~/.bashrc
$ echo "export GHCUP_INSTALL_BASE_PREFIX=/opt" >> ~/.bashrc
$ echo "source /opt/.ghcup/env" >> ~/.bashrc
$ source ~/.bashrc

$ echo -e "import System.Random.MWC\nmain = createSystemRandom >>= uniform >>= (print :: Int -> IO ())" > A.hs

$ ghc -o a.out -O2 A.hs
$ ./a.out
-2530740540117274139
```

また、インストールした全パッケージのモジュールを import するだけのファイル [Import.hs](./Import.hs) を作成し、無事にコンパイルできることを確認しました。

## 補足事項

### 依存関係について

事前に `apt-get` でインストールする依存関係は以下の通りです。

- build-essential
- curl
- libgmp-dev
- libffi-dev
- libncurses-dev
- libnuma-dev
- libtinfo5

上記のリストは `ghcup print-system-reqs` の結果によるものです。

```shell
$ ghcup print-system-reqs
build-essential curl libgmp-dev libffi-dev libncurses-dev libtinfo5
```

#### 注意点

`ghcup print-system-reqs` の結果には含まれていませんが、`libnuma-dev` も必要なのでインストールしています。([Manual libnuma install required](https://gitlab.haskell.org/haskell/ghcup/issues/58))
