# dot-claude

Claude Code に任せたコードを、**全部読まずに自分で説明できる**ようにするための個人設定です。
`CLAUDE.md` と `skills/` は、`~/.claude/` に置くファイルそのままです。

## 考え方

- コードを書かせる前に計画を出させ、理解の土台を作る
- 書かせた後は、AIの説明を読むのではなく、**自分が説明して、別のセッションのAIに採点させる**。書いたAI自身は、自分の見落としを採点でも見落とすため

## 中身

| ファイル | 役割 |
|---|---|
| `CLAUDE.md` | コードを書かせる側のルール。計画を先に出す、設計判断の前で質問する、完了時に「変更の地図」（変更の要約）を出す |
| `skills/comprehension-review/SKILL.md` | 試験官スキル。読む箇所の選定 → 説明の採点 → 予測クイズ → 壊して確かめる |
| `setup/cloud-setup.sh` | Cloud で使う人向けのセットアップスクリプト |

分からない言葉は、最後の「[用語](#用語)」を見てください。

## 入れると何が変わるか

- Claude Code がコードを書く前に、毎回計画を出して止まります。「OK」「ここを変えて」など普通に返事をすれば、それが承認です
- タイポや文言の修正など、設計判断を含まない数行の修正では計画を省略します。計画を飛ばしてほしいときは「計画は省略して」と伝えてください
- 設計判断（エラー処理・データ構造など）の手前で、選択肢と理由を示して質問してきます
- 作業の最後に「変更の地図」を出します

## 1つの変更での流れ

1. 作業セッションで計画を承認し、実装させる。最後に出る「変更の地図」は、PR の説明に貼るかメモしておく
2. **新しいセッション**を、同じリポジトリで開く（作業セッションとは別のウィンドウか、閉じてから開き直す）。Cloud の場合は、先に作業ブランチを push しておく
3. 「理解度レビューをして」と頼み、聞かれたら、変更のあるブランチ名・取り込む先のブランチ（ふつうは main）・計画を伝える。「説明を採点して」「予測クイズを出して」でも始まります
4. 試験官が選んだ箇所だけ読む → 何も見ずに説明を書く → 採点 → 予測クイズ → 壊して確かめる
5. 最後に、手順1の「変更の地図」と突き合わせる
6. 試験官とのやり取りで残すことにしたテストは、作業セッションに戻してコミットする（試験官はコミットしません）

## はじめに：fork する

このリポジトリを直接読み込まず、**fork して自分のリポジトリから**読み込んでください。

### fork とは

他人の GitHub リポジトリを、自分のアカウントの下にまるごとコピーすることです。

```
cookkawasaki/dot-claude   ← 元のリポジトリ
        │ fork（コピー）
        ▼
あなた/dot-claude          ← あなた専用のコピー
```

- コピーした後は元のリポジトリとは別物になり、自由に書き換えられます
- 元のリポジトリが更新されても、あなたのコピーには自動では入りません。取り込みたいときだけ、自分のコピーのページで **Sync fork** を押します

### なぜ fork するのか

ここにあるファイルは、セッションのたびに**AIへの指示として読み込まれます**。他人のリポジトリを直接読み込むと、その人が書き換えた内容が、あなたの確認なしにあなたのAIへの指示になります。fork しておけば、いつどの更新を取り込むかを自分で決められます。

### やり方

このページ右上の **Fork** を押します。以下の手順に出てくる `<あなたのユーザー名>` は、あなたの GitHub のユーザー名に置き換えてください。

## 入れ方

Claude Code が**どこで動いているか**で、入れ方が変わります。

| 使い方 | 動いている場所 | 入れ方 |
|---|---|---|
| ターミナルの `claude` コマンド | 自分の PC | A |
| VS Code・JetBrains の拡張機能 | 自分の PC | A |
| デスクトップアプリの Code タブで **Local** を選んだとき | 自分の PC | A |
| デスクトップアプリの Code タブで **Cloud** を選んだとき | Anthropic のサーバー | B |
| ブラウザの claude.ai/code、スマホアプリの Code タブ | Anthropic のサーバー | B |

両方使う人は、A と B の両方を行ってください。会社の組織アカウントでは Cloud が使えないことがあります。Cloud を使わない人は A だけで足ります。

### A. 自分の PC で動かす場合

#### Mac・Linux

1. まず、既に個人用の `CLAUDE.md` があるか確認します。

   ```bash
   ls ~/.claude/CLAUDE.md
   ```

2. ファイルを取ってきて、スキルを置きます。

   ```bash
   git clone https://github.com/<あなたのユーザー名>/dot-claude ~/dot-claude
   mkdir -p ~/.claude/skills
   ln -s ~/dot-claude/skills/comprehension-review ~/.claude/skills/comprehension-review
   ```

3. `CLAUDE.md` を置きます。手順1の結果で分かれます。
   - 「No such file or directory」と出た（まだ無い）場合：

     ```bash
     ln -s ~/dot-claude/CLAUDE.md ~/.claude/CLAUDE.md
     ```

   - ファイル名が表示された（既にある）場合：上書きせず、既存の `~/.claude/CLAUDE.md` の末尾に次の1行を書き足します。Claude Code は、この行を「そのファイルも読み込む」という指示として扱います。

     ```
     @~/dot-claude/CLAUDE.md
     ```

`ln -s` はファイルのショートカットを作るコマンドです。元の `~/dot-claude` を更新すれば、そのまま反映されます。

#### Windows

1. `git clone https://github.com/<あなたのユーザー名>/dot-claude` で、好きな場所に取ってきます
2. `CLAUDE.md` を `%USERPROFILE%\.claude\CLAUDE.md` にコピーします。既にある場合は上書きせず、中身を末尾に貼り足します
3. `skills\comprehension-review` フォルダを `%USERPROFILE%\.claude\skills\` の下にコピーします

#### 入ったかの確認

Claude Code で新しいセッションを始め、`/context` と入力します（そのセッションが読み込んだファイルの一覧が出ます）。Memory files の欄に `~/.claude/CLAUDE.md` が出ていれば完了です。出ない場合は、`~/.claude/CLAUDE.md` が本当にあるか確かめてください。

#### 更新するとき

- Mac・Linux：fork 側で Sync fork を押した後、`cd ~/dot-claude && git pull`
- Windows：`git pull` した後、手順2・3のコピーをやり直す

### B. Anthropic のサーバー（Cloud）で動かす場合

Cloud のセッションは毎回まっさらなサーバーで始まり、自分の PC の `~/.claude/` は読まれません。代わりに、環境のセットアップスクリプト（環境を作るときに最初に実行されるスクリプト）でファイルを書き出します。

1. セッションを始める画面の環境の選択から、**自分の環境（Personal）**を編集し、Setup script に `setup/cloud-setup.sh` の中身を貼る
2. `REPO=` の行を `REPO=<あなたのユーザー名>/dot-claude` に書き換える
3. `REF=` の行に、自分のコピーの最新コミットの SHA を入れて保存する
   - 取り方：GitHub で自分のコピーを開き、ファイル一覧の右上にある「〇 Commits」を押す → 一番上のコミットの右にあるコピーボタンを押す（40文字の英数字。短い7文字版ではなく全部を貼る）
   - 手元に clone があれば `git rev-parse HEAD` でも取れます
4. 新しいセッションで `/context` と入力し、Memory files に `/root/.claude/CLAUDE.md` が出ていれば完了（Cloud では `~` が `/root` を指します）

出ていない場合は、`REF` か `REPO` の打ち間違いを疑ってください。

その環境を組織に共有しないでください。共有すると全員のセッションに効きます。

#### 更新するとき

Sync fork を押した後、`REF` を新しいコミットの SHA に書き換えて保存します。スクリプトが変わると環境が作り直され、新しい中身が入ります。

## 注意

- 公開リポジトリです。会社のコードや社名を含む例はコミットしないでください（fork したコピーも公開になります）
- 作業中のリポジトリの `CLAUDE.md` と矛盾する場合は、リポジトリ側が優先されます

## 用語

| 用語 | 意味 |
|---|---|
| CLAUDE.md | Claude Code がセッションの最初に毎回読む指示書。`~/.claude/` に置くと、すべてのプロジェクトに効く |
| スキル（SKILL.md） | 特定の頼みごとをしたときだけ読み込まれる手順書 |
| 変更の地図 | 作業の最後に Claude Code に出させる、変更の要約（ファイル別の要約・処理の流れ・判断の理由・確認していないこと・読むべき箇所） |
| アサーション | テストの中で「こうなるはず」を確かめる行（`assert` や `expect` など） |
| 予測クイズ | コードを動かす前に結果を予想し、テストで答え合わせをすること |
| 壊して確かめる | わざと1か所だけコードを変え、テストがそれに気づくかを見ること（ミューテーションテストと呼ばれる方法） |
| コミットの SHA | コミット1つ1つに付く40文字の ID。ブランチ名と違い、指す中身が後から変わらない |
| fork / Sync fork | 上の「fork とは」を参照 |

## 参考

- [Comprehension debt](https://addyosmani.com/blog/comprehension-debt/)（Addy Osmani）
- [Not all AI-assisted programming is vibe coding](https://simonwillison.net/2025/Mar/19/vibe-coding/)（Simon Willison）
- [How AI assistance impacts the formation of coding skills](https://www.anthropic.com/research/AI-assistance-coding-skills)（Anthropic）
- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)（Claude Code 公式ドキュメント）
