# make_sh

## 概要

makeコマンドのラッパースクリプト

## 使用方法

### make.sh

指定された実行ユーザーの権限でmakeコマンドを実行します。

    $ make.sh -u 実行ユーザー名 -t "ターゲット ..." Makefileの存在するディレクトリ名

### その他

* 上記で紹介したツールの詳細については、「ツール名 --help」を参照してください。

## 動作環境

OS:

* Linux
* Cygwin

依存パッケージ または 依存コマンド:

* make
* [dos_tools](https://github.com/yuksiy/dos_tools)

## インストール

ソースからインストールする場合:

    (Linux, Cygwin の場合)
    # make install

fil_pkg.plを使用してインストールする場合:

[fil_pkg.pl](https://github.com/yuksiy/fil_tools_pl/blob/master/README.md#fil_pkgpl) を参照してください。

## インストール後の設定

環境変数「PATH」にインストール先ディレクトリを追加してください。

## 最新版の入手先

<https://github.com/yuksiy/make_sh>

## License

MIT License. See [LICENSE](https://github.com/yuksiy/make_sh/blob/master/LICENSE) file.

## Copyright

Copyright (c) 2004-2017 Yukio Shiiya
