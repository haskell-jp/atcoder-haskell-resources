# 言語アップデート 2019年7月版

- 本文書の内容は [reddit](https://www.reddit.com/r/haskell_jp/comments/ax1j2m/atcoder_%E3%81%AE%E8%A8%80%E8%AA%9E%E3%82%A2%E3%83%83%E3%83%97%E3%83%87%E3%83%BC%E3%83%88%E3%81%8C6%E6%9C%88%E3%81%AB%E3%81%82%E3%82%8B%E3%82%89%E3%81%97%E3%81%84%E3%81%AE%E3%81%A7/) または [haskell-jp](https://haskell.jp/) 公式 slack の random チャンネル等の内容に基づきます。

そもそもこの提案はまとめようとしたのは、以下のツイートを見つけたからです。

> 【良いお知らせ】AtCoderの言語アップデートテストが６月に行われる"予定"です。入れたい言語とかがある人は、Ubuntuでのバージョンを固定した導入方法、および必要なライブラリやコンパイルオプションや実行コマンドあたりを調べておいてください。

上記のツイートは以下のURLから引用しています。

- https://twitter.com/chokudai/status/1100429644681998336

後になって、とあるパッケージが無い/GHCのバージョンが古すぎる/もっと良いコンパイルオプションがある等の理由によって [AtCoder](https://atcoder.jp/?lang=ja) で Haskell を選びづらいという状況ができるだけ発生しないように、これから AtCoder を通して Haskell の理解を深めようと思う人の大半が満足できる環境を提案できたらと思います。(また、現状の不満も同様に解決できたらと思っています)

# 要望の提出方法について

2019年7月1日に以下の[ツイート](https://twitter.com/chokudai/status/1145624486546309120)で言語アップデートの先行告知がありました。

> 言語アップデートのSpreadSheet出しておきまーす。編集してねー。
（良く分かってる人がいくつか書いてくれないと多分訳が分からない状態なのでchokudai垢のみで先行告知してます）

- [AtCoder 2019/7 Language Update](https://docs.google.com/spreadsheets/d/1PmsqufkF3wjKN6g1L0STS80yP4a6u-VdGiEv5uOHe0M/edit#gid=0)

# 目的

- AtCoder の Haskell 環境を整備する
- 以下の内容について Haskell-jp コミュニティの意見をまとめる
  - コンパイラ&追加パッケージのインストール方法について
  - GHC のバージョン
  - 追加パッケージの選定
  - コンパイルオプション
  
まとめた内容の提出方法はスプレッドシートへの書き込みという感じになるようです。
  
> こんな感じで統一見解を出して貰えるとたしかにいいかも。AtCoder的にはspreadsheetを公開するだけになると思うから、そこに補足とかを書いてもらえるとわかりやすい

上記のツイートは以下のURLから引用しています。

- https://twitter.com/chokudai/status/1102496049812271105
  
# 現状の AtCoder の Haskell 環境について

現在の AtCorder の環境は [ルール](https://atcoder.jp/contests/abc120/rules) に記載されています。以下の表は該当箇所だけ抜き出したものです。(OS についてはツイートの内容に基づきます)

項目 | 値
-----|----------
OS | Ubuntu
コンパイラ | Haskell (GHC 7.10.3)
コマンド | `ghc -o ./a.out -O2 ./Main.hs`
インストール方法 | Haskell Platform

AtCoder 2019/7 Language Update スプレッドシートに記載されている Judge Server Information は以下の通り。

```
$ uname -a
Linux ip-***-***-***-*** 4.15.0-1041-aws #43-Ubuntu SMP Thu Jun 6 13:39:11 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.2 LTS"
```

また、`cat /proc/cpuinfo`, `cat /proc/meminfo` の結果、AWS の `t2.medium` で動いていると思われる。

## GlobalPackageDB に登録されているパッケージとバージョンの一覧

```haskell
import Distribution.Simple
import Distribution.Simple.GHC
import Distribution.Verbosity
import Distribution.Simple.Program
import Distribution.Simple.PackageIndex

import Data.List

main :: IO ()
main = do
  (_, _, conf) <- configure silent Nothing Nothing defaultProgramConfiguration
  installedPackageIndex <- getPackageDBContents silent GlobalPackageDB conf
  mapM_ putStrLn $ map (pretty . fst) $ allPackagesBySourcePackageId installedPackageIndex
  
pretty (PackageIdentifier name ver) = unPackageName name ++ "-" ++ intersperse '.' (concatMap show $ versionBranch ver)
```

出力結果 (バージョン適当に繋げたのでちょっとバグってる)

```shell
Cabal-1.2.2.5.0
GLURaw-1.5.0.2
GLUT-2.7.0.3
HTTP-4.0.0.0.2.2.0
HUnit-1.3.0.0
ObjectName-1.1.0.0
OpenGL-2.1.3.1.0
OpenGLRaw-2.6.0.0
QuickCheck-2.8.1
StateVar-1.1.0.1
array-0.5.1.0
async-2.0.2
attoparsec-0.1.3.0.1
base-4.8.2.0
bin-package-db-0.0.0.0
binary-0.7.5.0
bytestring-0.1.0.6.0
case-insensitive-1.2.0.5
cgi-3.0.0.1.2.2.2
containers-0.5.6.2
deepseq-1.4.1.1
directory-1.2.2.0
exceptions-0.8.0.2
fgl-5.5.2.3
filepath-1.4.0.0
ghc-7.1.0.3
ghc-prim-0.4.0.0
half-0.2.2.1
hashable-1.2.3.3
haskeline-0.7.2.1
haskell-src-1.0.2.0
hoopl-3.1.0.0.2
hpc-0.6.0.2
hscolour-1.2.3
html-1.0.1.2
integer-gmp-1.0.0.0
mtl-2.2.1
multipart-0.1.2
network-2.6.2.1
network-uri-2.6.0.3
old-locale-1.0.0.7
old-time-1.1.0.3
parallel-3.2.0.6
parsec-3.1.9
pretty-1.1.2.0
primitive-0.6.1.0
process-1.2.3.0
random-1.1
regex-base-0.9.3.2
regex-compat-0.9.5.1
regex-posix-0.9.5.2
rts-1.0
scientific-0.3.3.8
split-0.2.2
stm-2.4.4
syb-0.6
template-haskell-2.1.0.0.0
terminfo-0.4.0.1
text-1.2.1.3
tf-random-0.5
time-1.5.0.1
transformers-0.4.2.0
transformers-compat-0.4.0.4
unix-2.7.1.0
unordered-containers-0.2.5.1
vector-0.1.1.0.0
xhtml-3.0.0.0.2.1
zlib-0.5.4.2
```

この結果より、Haskell Platform の `Core Libraries, provided with GHC` と `Libraries with Full Platform` に列挙されているパッケージが含まれていることがわかった。

言語を `bash` にして `ghc-pkg list` でもっと簡単に確認できた・・・。

# ghc について

素の GHC が依存するパッケージについては [Haskell Hierarchical Libraries](https://downloads.haskell.org/~ghc/latest/docs/html/libraries/) や [GHC Commentary: Libraries](https://ghc.haskell.org/trac/ghc/wiki/Commentary/Libraries) に色々と説明がある。

# 環境の構築方法について

## Haskell Platform

- [Haskell Platform 公式サイト](https://www.haskell.org/platform/)
- [Full Platformで入るパッケージの早見表](https://www.haskell.org/platform/contents.html)

MEMO

- パッケージを追加する場合は `cabal install --global mwc-random` のようにする
  - オプション無しで `--user` 相当だとすると、unix ユーザーが変わると見えなくなってしまいます。

### 問題点

> Ubuntuですと、aptで入れると最新のcosmicでも2014.2.0.0（GHC7とか）が入ってしまうようなので最新のパッケージをいれるようにはしたいですね（Haskell-platformで行くなら）

[パッケージ: haskell-platform (2014.2.0.0.debian5)](https://packages.ubuntu.com/cosmic/haskell-platform)

> じゃぁgeneric-linuxならどうやねん、と思ったら、generic-linux向けのHaskell Platformのインストーラーはないからstackかghcupを使え、と... 結局stackに帰ってきた

- ghc は cosmic (18.10) だと 8.2.2, disco (19.04) だと 8.4.4 のようですね。=> https://packages.ubuntu.com/search?keywords=ghc
- 18.04 LTS のサポート終了は「2023年4月 (Extended Security Maintenance は 2028年4月まで)」なので、これが選ばれそうな気がする。その場合は ghc-8.0.2 になってしまう。
  - [The Ubuntu lifecycle and release cadence](https://www.ubuntu.com/about/release-cycle)
  - [Releases - Ubuntu wiki](https://wiki.ubuntu.com/Releases)

## ppa

- [hvr](https://launchpad.net/~hvr/+archive/ubuntu/ghc)

## stack

- [stack 公式ドキュメント](https://docs.haskellstack.org/en/stable/README/)

MEMO

- `PATH` に `$(stack path --programs)/ghc-<version>/bin/` を追加する必要がありそう
- `stack exec ghc -- ` でコンパイルすると良い
- パッケージのインストールは `stack install vector` のように行う

## ghcup + cabal

- [ghcup 公式リソース](https://github.com/haskell/ghcup)
- [cabal 公式ドキュメント](https://www.haskell.org/cabal/users-guide/)

# 追加パッケージについて

パッケージの最新バージョンについては 2019/7/31 に確認したものです。

AtCoder にインストールされているパッケージバージョンの確認方法は以下の通りです。

```
$ ghc-pkg list | grep <pkg_name>
```

現在の AtCoder 環境に含まれているパッケージ一覧

パッケージ名 | 既存 | 最新 | 提案
-----------|-----|------|-----
QuickCheck | [2.8.1](https://hackage.haskell.org/package/QuickCheck-2.8.1) | [2.13.2](https://hackage.haskell.org/package/QuickCheck-2.13.2)
array | [0.5.1.0](https://hackage.haskell.org/package/array-0.5.1.0) | [0.5.3.0](https://hackage.haskell.org/package/array-0.5.3.0)
attoparsec | [0.13.0.1](https://hackage.haskell.org/package/attoparsec-0.13.0.1) | [0.13.2.2](https://hackage.haskell.org/package/attoparsec-0.13.2.2)
bytestring | [0.10.6.0](https://hackage.haskell.org/package/bytestring-0.10.6.0) | [0.10.10.0](https://hackage.haskell.org/package/bytestring-0.10.10.0)
containers | [0.5.6.2](https://hackage.haskell.org/package/containers-0.5.6.2) | [0.6.2.1](https://hackage.haskell.org/package/containers-0.6.2.1)
deepseq | [1.4.1.1](https://hackage.haskell.org/package/deepseq-1.4.1.1) | [1.4.4.0](https://hackage.haskell.org/package/deepseq-1.4.4.0)
fgl | [5.5.2.3](https://hackage.haskell.org/package/fgl-5.5.2.3) | [5.7.0.1](https://hackage.haskell.org/package/fgl-5.7.0.1)
parallel | [3.2.0.6](https://hackage.haskell.org/package/parallel-3.2.0.6) | [3.2.2.0](https://hackage.haskell.org/package/parallel-3.2.2.0)
parsec | [3.1.9](https://hackage.haskell.org/package/parsec-3.1.9) | [3.1.13.0](https://hackage.haskell.org/package/parsec-3.1.13.0)
primitive | [0.6.1.0](https://hackage.haskell.org/package/primitive-0.6.1.0) | [0.7.0.0](https://hackage.haskell.org/package/primitive-0.7.0.0)
random | [1.1](https://hackage.haskell.org/package/random-1.1) | [1.1](https://hackage.haskell.org/package/random-1.1)
text | [1.2.1.3](https://hackage.haskell.org/package/text-1.2.1.3) | [1.2.3.1](https://hackage.haskell.org/package/text-1.2.3.1)
transformers | [0.4.2.0](https://hackage.haskell.org/package/transformers-0.4.2.0) | [0.5.6.2](https://hackage.haskell.org/package/transformers-0.5.6.2)
unordered-containers | [0.2.5.1](https://hackage.haskell.org/package/unordered-containers-0.2.5.1) | [0.2.10.0](https://hackage.haskell.org/package/unordered-containers-0.2.10.0)
vector | [0.11.0.0](https://hackage.haskell.org/package/vector-0.11.0.0) | [0.12.0.3](https://hackage.haskell.org/package/vector-0.12.0.3)

現在の AtCoder 環境に含まれていないパッケージ一覧

パッケージ名 | 最新 | 追加理由
-----------|------|--------
extra | [1.6.17](https://hackage.haskell.org/package/extra-1.6.17) | Prelude に定義されていない、あったら便利な関数が多数定義されているため。
heaps | [0.3.6.1](https://hackage.haskell.org/package/heaps-0.3.6.1)
integer-logarithms | [1.0.3](https://hackage.haskell.org/package/integer-logarithms-1.0.3) | 整数のlogを取るため。
lens | [4.17.1](https://hackage.haskell.org/package/lens-4.17.1)
massiv | [0.4.0.0](https://hackage.haskell.org/package/massiv-0.4.0.0) | 高次元のaligned vectorを扱うmoduleであって，「mutable <-> immutable 相互変換可能」「map,fold等がそのまま使える」を満たしているものとして希望した．
mono-traversable | [1.0.12.0](https://hackage.haskell.org/package/mono-traversable-1.0.12.0) | ByteStringやText等をFoldable/Traversableっぽく扱うためのインターフェースを提供している。
mwc-random | [0.14.0.0](https://hackage.haskell.org/package/mwc-random-0.14.0.0) | 高速に乱数を生成するため。
psqueues | [0.2.7.2](https://hackage.haskell.org/package/psqueues-0.2.7.2)
reflection | [2.1.4](https://hackage.haskell.org/package/reflection-2.1.4) | 実行時の値に基づいた型レベル自然数を作るため。
repa | [3.4.1.4](https://hackage.haskell.org/package/repa-3.4.1.4)
unboxing-vector | [0.1.1.0](https://hackage.haskell.org/package/unboxing-vector-0.1.1.0) | [unboxing-vectorの紹介：newtypeフレンドリーなunboxed vector](https://qiita.com/mod_poppo/items/cf6b66ff16464c170ac2) を参照してください。
utility-ht | [0.0.14](https://hackage.haskell.org/package/utility-ht)
vector-algorithms | [0.8.0.1](https://hackage.haskell.org/package/vector-algorithms-0.8.0.1) | Vector のソートを行うため。

## 候補リスト

まだブレインストーミング段階です。以下は slack に出てきたパッケージをリスト化したものです。(アルファベット順)

- [array](https://hackage.haskell.org/package/array)
- [attoparsec](https://hackage.haskell.org/package/attoparsec)
- [bytestring](https://hackage.haskell.org/package/bytestring)
  - 入力処理で必須
- [containers](https://hackage.haskell.org/package/containers)
- [extra](https://hackage.haskell.org/package/extra)
- [fgl](https://hackage.haskell.org/package/fgl)
  - グラフ
- ~~[hashmap](https://hackage.haskell.org/package/hashmap)~~
  - `Deprecated. in favor of unordered-containers` と書いてあるため、不採用
- [heaps](https://hackage.haskell.org/package/heaps)
- [lens](https://hackage.haskell.org/package/lens)
- [mwc-random](https://hackage.haskell.org/package/mwc-random)
- [parsec](https://hackage.haskell.org/package/parsec)
- [primitive](https://hackage.haskell.org/package/primitive)
- [psqueues](https://hackage.haskell.org/package/psqueues)
- [reflection](https://hackage.haskell.org/package/reflection)
- [repa](https://hackage.haskell.org/package/repa)
- [text](https://hackage.haskell.org/package/text)
- [unboxing-vector](https://hackage.haskell.org/package/unboxing-vector)
  - [unboxing-vectorの紹介：newtypeフレンドリーなunboxed vector](https://qiita.com/mod_poppo/items/cf6b66ff16464c170ac2)
- [unordered-containers](https://hackage.haskell.org/package/unordered-containers)
- [utility-ht](https://hackage.haskell.org/package/utility-ht)
- [vector](https://hackage.haskell.org/package/vector)
- [vector-algorithms](https://hackage.haskell.org/package/vector-algorithms)
  - [Data.List.sort](https://hackage.haskell.org/package/base-4.12.0.0/docs/Data-List.html#v:sort) が遅すぎるため

## パッケージの決め方や候補についての意見 (まだまだ募集中)

- 基本的には haskell platform に含まれるものが使えたら良いんじゃないか？
- 特定の問題で利用できるという明確な利用意図があった方が良いのかもしれない
- 極めてベーシックなデータ構造系以外はない方がプロコン的には面白いんじゃないか？
  - 具体例: vector, array, hashmap 
  - データ構造については haskell-jp wiki の [データ構造列伝](https://wiki.haskell.jp/%E3%83%87%E3%83%BC%E3%82%BF%E6%A7%8B%E9%80%A0%E5%88%97%E4%BC%9D) に色々とまとまっている
- 競技プログラミングとしての面白さは減らさずに便利 (または制限時間やメモリの問題をクリアするために必要となってくるよう) なパッケージを選べたら良いのではないか？
- Python (NumPyは除く) みたいに、できるには出来るけど効率悪いかもよ？みたいな状態で止めておくのが無難かもしれない？
- C++ 標準で入ってそーなデータ構造は入れてもよさそう
  - [stl](http://www.cplusplus.com/reference/stl/)
  - C++ のほうも C++17 を入れていいみたいな話になってるのかな。それ基準で考えましょう
- UnionFindとか地味に欲しいのですが地味に候補が多い
  - 参考: [Which union-find package to use?](https://www.reddit.com/r/haskell/comments/5qj8oc/which_unionfind_package_to_use/)
  
### 疑問

- パッケージをどれぐらいまでインストールできるか？

# コンパイルオプションについて

## コンパイル時間の考察

確か以下のプログラムを使って計測したと思う・・・。(要確認)

```haskell
import System.Random.MWC

-- http://blog.livedoor.jp/rtabaladi_58/archives/65158189.html の例を借用
main :: IO ()
main = do
  gen <- createSystemRandom
  randValue <- uniform gen :: IO Int
  print randValue
```

あんまりちゃんと比較できていないけど、なぜか `stack exec` 経由だと少し早い？

### haskell-platform

```shell
# time ghc -o ./a.out -O2 ./Main.hs
real    0m4.089s
user    0m1.820s
sys     0m0.530s
```

### ppa

```shell
# time ghc -o ./a.out -O2 ./Main.hs
real    0m2.552s
user    0m1.370s
sys     0m0.460s
```

### stack

```shell
# time stack exec -- ghc -o ./a.out -O2 ./Main.hs
real    0m1.819s
user    0m1.280s
sys     0m0.260s
```

### ghcup

```shell
# time ghc -o ./a.out -O2 ./Main.hs
real    0m3.397s
user    0m1.330s
sys     0m0.580s
```

# 環境構築の具体例

動作確認には以下の `mwc-random` パッケージを使ったコードを利用しています。

```haskell
import System.Random.MWC

-- http://blog.livedoor.jp/rtabaladi_58/archives/65158189.html の例を借用
main :: IO ()
main = do
  gen <- createSystemRandom
  randValue <- uniform gen :: IO Int
  print randValue
```

## ghcup

```dockerfile
FROM ubuntu:bionic-20190307
RUN apt-get update
RUN apt-get install -y \
  curl 
RUN apt-get install -y \
  gcc \
  make \
  libgmp-dev \
  libnuma-dev \
  libtinfo-dev
RUN curl https://get-ghcup.haskell.org -sSf | sh

ENV PATH ~/.cabal/bin:/root/.ghcup/bin:$PATH
RUN echo "source /root/.ghcup/env" >> ~/.bashrc

RUN cabal v2-update
RUN cabal v2-install --global --lib \
  mwc-random-0.14.0.0 \
  vector-algorithms-0.8.0.1

###########################
# ghc: 8.6.3
# cabal-install: 2.4.1.0
###########################
```

## haskell-platform

```dockerfile
FROM ubuntu:bionic-20190307
RUN apt-get update
RUN apt-get install -y \
  haskell-platform

# v2 コマンドには対応していない
RUN cabal update
RUN cabal install --global \
  mwc-random-0.14.0.0 \
  vector-algorithms-0.8.0.1

###########################
# ghc: 8.0.2
# cabal-install: 1.24.0.2
###########################
```

## ppa

```dockerfile
FROM ubuntu:bionic-20190307
RUN apt-get update
RUN apt-get install -y \
  software-properties-common

# https://launchpad.net/~hvr/+archive/ubuntu/ghc/
RUN add-apt-repository ppa:hvr/ghc
RUN apt-get update

RUN apt-get install -y \
  libtinfo-dev \
  ghc-8.6.4 \
  cabal-install-2.4

ENV PATH /opt/ghc/bin:$PATH

RUN cabal v2-update
RUN cabal v2-install --global --lib \
  mwc-random-0.14.0.0 \
  vector-algorithms-0.8.0.1

###########################
# ghc: 8.6.4
# cabal-install: 2.4.1.0
###########################
```

## stack

```dockerfile
FROM ubuntu:bionic-20190307
RUN apt-get update
RUN apt-get install -y \
  curl

RUN curl -sSL https://get.haskellstack.org/ | sh

ENV PATH /root/.local/bin:$PATH

RUN stack install \
  mwc-random \
  vector-algorithms

###########################
# ghc: 8.6.4
# stack: 1.9.3
###########################
```

# Haskell (AtCoder) に関するリソース

- [AtCoder に登録したら解くべき精選過去問 10 問を Haskell で解いてみた](https://qiita.com/hsjoihs/items/25a08b426196ab2b9bb0)
- [HaskellでAtCoderに参戦して水色になった](https://blog.miz-ar.info/2019/05/atcoder-with-haskell/)
- [Haskellで解くAtCoder](https://myuon.github.io/posts/haskell-atcoder/)

# この文書をまとめるにあたって

slack, github において、以下の方々にご協力いただいきました。(slack, github name のアルファベット順)

- @Akihito Kirisaki
- @as_capabl
- @autotaker
- @cohei
- @fumieval
- @gksato
- @igrep
- @kakkun61
- @khibino
- @matonix
- @matsubara0507
- @mod_poppo
- @suiheilibe
- @waddlaw
- @りんご姫

ご協力ありがとうございます。
