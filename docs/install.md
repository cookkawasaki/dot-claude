# 入れ方

[README に戻る](../README.md)

必要なもの：Claude Code、GitHub アカウント、git（A の場合）

1. [fork する](#1-fork-する)
2. [どこで動いているかを確かめる](#2-どこで動いているかを確かめる)
3. [A. 自分の PC で動かす場合](#a-自分の-pc-で動かす場合) または [B. Cloud で動かす場合](#b-cloud-で動かす場合)

## 1. fork する

fork とは、他人の GitHub リポジトリを、自分のアカウントの下にまるごとコピーすることです。コピーは元とは別物で、自由に書き換えられます。元が更新されても自動では入らず、取り込みたいときだけ、自分のコピーのページで **Sync fork** を押します。

```
cookkawasaki/dot-claude   ← 元のリポジトリ
        │ fork（コピー）
        ▼
あなた/dot-claude          ← あなた専用のコピー
```

### なぜ fork するのか

ここにあるファイルは、セッションのたびに AI への指示として読み込まれます。他人のリポジトリを直接読み込むと、その人が書き換えた内容が、あなたの確認なしにあなたの AI への指示になります。fork しておけば、いつどの更新を取り込むかを自分で決められます。

### やり方

[リポジトリのページ](https://github.com/cookkawasaki/dot-claude)右上の **Fork** を押します。以下に出てくる `<あなたのユーザー名>` は、あなたの GitHub のユーザー名に置き換えてください。

## 2. どこで動いているかを確かめる

| 使い方 | 動いている場所 | 入れ方 |
|---|---|---|
| ターミナルの `claude` コマンド | 自分の PC | A |
| VS Code・JetBrains の拡張機能 | 自分の PC | A |
| デスクトップアプリの Code タブで **Local** を選んだとき | 自分の PC | A |
| デスクトップアプリの Code タブで **Cloud** を選んだとき | Anthropic のサーバー | B |
| ブラウザの claude.ai/code、スマホアプリの Code タブ | Anthropic のサーバー | B |

両方使う人は、A と B の両方を行ってください。会社の組織アカウントでは Cloud が使えないことがあります。

## A. 自分の PC で動かす場合

`~/.claude/` にファイルを置きます（Windows では `%USERPROFILE%\.claude\`）。

### Mac・Linux

1. 既に個人用の `CLAUDE.md` があるか確認します。

   ```bash
   ls ~/.claude/CLAUDE.md
   ```

2. ファイルを取ってきて、スキルを置きます。

   ```bash
   git clone https://github.com/<あなたのユーザー名>/dot-claude ~/dot-claude
   mkdir -p ~/.claude/skills
   ln -s ~/dot-claude/skills/comprehension-review ~/.claude/skills/comprehension-review
   ```

   `ln -s` はファイルのショートカットを作るコマンドです。元の `~/dot-claude` を更新すれば、そのまま反映されます。

3. `CLAUDE.md` を置きます。手順1の結果で分かれます。
   - 「No such file or directory」と出た（まだ無い）場合：

     ```bash
     ln -s ~/dot-claude/CLAUDE.md ~/.claude/CLAUDE.md
     ```

   - ファイル名が表示された（既にある）場合：上書きせず、既存の `~/.claude/CLAUDE.md` の末尾に次の1行を書き足します。Claude Code は、この行を「そのファイルも読み込む」という指示として扱います。

     ```
     @~/dot-claude/CLAUDE.md
     ```

### Windows

1. `git clone https://github.com/<あなたのユーザー名>/dot-claude` で、好きな場所に取ってきます
2. `CLAUDE.md` を `%USERPROFILE%\.claude\CLAUDE.md` にコピーします。既にある場合は上書きせず、中身を末尾に貼り足します
3. `skills\comprehension-review` フォルダを `%USERPROFILE%\.claude\skills\` の下にコピーします

### 入ったかの確認

1. Claude Code で新しいセッションを始め、`/context` と入力します（そのセッションが読み込んだファイルの一覧が出ます）。Memory files の欄に `~/.claude/CLAUDE.md` が出ていれば、ルールは入っています。出ない場合は、`~/.claude/CLAUDE.md` が本当にあるか確かめてください
2. 「理解度レビューをして」と頼みます。計画を聞き返されるか、「レビュー対象」で始まる深さの提案が出れば、試験官スキルも入っています。どちらも無くレビューを始める場合は、`~/.claude/skills/comprehension-review/SKILL.md` があるか確かめてください

### 更新するとき

- Mac・Linux：自分のコピーのページで Sync fork を押した後、`cd ~/dot-claude && git pull`
- Windows：自分のコピーのページで Sync fork を押し、`git pull` した後、手順2・3のコピーをやり直す

## B. Cloud で動かす場合

Cloud のセッションは毎回まっさらなサーバーで始まり、自分の PC の `~/.claude/` は読まれません。代わりに、環境のセットアップスクリプト（環境を作るときに最初に実行されるスクリプト）でファイルを書き出します。

1. セッションを始める画面の環境の選択から、**自分の環境（Personal）**を編集し、Setup script に [`setup/cloud-setup.sh`](../setup/cloud-setup.sh) の中身を貼る。環境の画面の場所は、公式ドキュメント [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments) に載っている
2. `REPO=` の行を `REPO=<あなたのユーザー名>/dot-claude` に書き換える
3. `REF=` の行に、自分のコピーの最新コミットの SHA を入れて保存する
   - SHA は、コミット1つ1つに付く40文字の ID です。ブランチ名と違って、指す中身が後から変わりません。AI への指示を固定しておくために使います
   - 取り方：GitHub で自分のコピーを開き、ファイル一覧の右上にある「〇 Commits」を押す → 一番上のコミットの右にあるコピーボタンを押す（短い7文字版ではなく、40文字すべてを貼る）
   - 手元に clone があれば `git rev-parse HEAD` でも取れます
4. 新しいセッションで `/context` と入力し、Memory files に `/root/.claude/CLAUDE.md` が出ていれば完了（Cloud では `~` が `/root` を指す）
   - 出ていない場合は、`REF` か `REPO` の打ち間違いを疑う

注意：この環境を組織に共有しないでください。共有すると全員のセッションに効きます。

### 更新するとき

Sync fork を押した後、`REF` を新しいコミットの SHA に書き換えて保存します。スクリプトが変わると環境が作り直され、新しい中身が入ります。
