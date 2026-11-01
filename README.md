# dot-claude

Claude Code に任せたコードを、**全部読まずに自分で説明できる**ようにするための個人設定です。
中身は `~/.claude/` に置くファイルそのままです。

## 考え方

- コードを書かせる前に計画を出させ、理解の土台を作る
- 書かせた後は、AIの説明を読むのではなく、**自分が説明して、別のセッションのAIに採点させる**
- 書いたAI自身には採点させない（同じAIは自分の見落としを採点でも見落とす）

## 中身

| ファイル | 役割 |
|---|---|
| `CLAUDE.md` | コードを書かせる側のルール。計画を先に出す、設計判断の前で質問する、完了時に「変更の地図」を出す |
| `skills/comprehension-review/SKILL.md` | 試験官スキル。読む箇所の選定 → 説明の採点 → 予測クイズ → 壊して確かめる |
| `setup/cloud-setup.sh` | クラウド（claude.ai/code）用のセットアップスクリプト |

## 1つの変更での流れ

1. 作業セッションで計画を承認し、実装させる（`CLAUDE.md` が効く）
2. **新しいセッション**で「理解度レビューをして。ブランチは〇〇、計画は〇〇にある」と頼む
3. 試験官が選んだ箇所だけ読む → 何も見ずに説明を書く → 採点 → 予測クイズ → 壊して確かめる
4. 最後に、作業セッションが出した「変更の地図」と突き合わせる

## 入れ方

### クラウド（claude.ai/code）

1. 環境の選択から**自分の環境（Personal）**を編集し、Setup script に `setup/cloud-setup.sh` の中身を貼る
2. `REF` を最新コミットの SHA に置き換えて保存する
3. 次のセッションで `/context` を開き、Memory files に `/root/.claude/CLAUDE.md` が出ていれば完了

その環境を組織に共有しないでください。共有すると全員のセッションに効きます。

### 手元の CLI

```bash
git clone https://github.com/cookkawasaki/dot-claude ~/dot-claude
mkdir -p ~/.claude/skills
ln -s ~/dot-claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -s ~/dot-claude/skills/comprehension-review ~/.claude/skills/comprehension-review
```

すでに `~/.claude/CLAUDE.md` がある場合は上書きせず、その中に `@~/dot-claude/CLAUDE.md` の1行を足してください。

## 使ってみたい人へ

- このリポジトリを直接読み込まず、**fork して自分のリポジトリから**読み込んでください。中身はAIへの指示として読まれるため、他人のリポジトリの更新に左右されないようにします。
- 公開リポジトリです。会社のコードや社名を含む例はコミットしないでください。
- 作業中のリポジトリの `CLAUDE.md` と矛盾する場合は、リポジトリ側が優先されます。

## 参考

- [Comprehension debt](https://addyosmani.com/blog/comprehension-debt/)（Addy Osmani）
- [Not all AI-assisted programming is vibe coding](https://simonwillison.net/2025/Mar/19/vibe-coding/)（Simon Willison）
- [How AI assistance impacts the formation of coding skills](https://www.anthropic.com/research/AI-assistance-coding-skills)（Anthropic）
- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)（Claude Code 公式ドキュメント）
