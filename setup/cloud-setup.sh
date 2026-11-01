#!/bin/bash
# claude.ai/code の「自分の環境（Personal）」の Setup script に、この中身を貼る。
# fork した人は、REPO を自分のユーザー名に書き換える。
# REF はブランチ名ではなくコミットの SHA（40文字）にする。中身はAIへの指示として読まれるため、固定しておく。
# 更新したいときは REF を書き換える。スクリプトが変わると、環境が作り直されて新しい中身が入る。

REPO=cookkawasaki/dot-claude
REF=ここにコミットのSHA
BASE="https://raw.githubusercontent.com/$REPO/$REF"

mkdir -p ~/.claude/skills/comprehension-review
curl -fsSL "$BASE/CLAUDE.md" -o ~/.claude/CLAUDE.md \
  || echo "dot-claude: CLAUDE.md を取得できませんでした。REPO と REF を確認してください"
curl -fsSL "$BASE/skills/comprehension-review/SKILL.md" \
  -o ~/.claude/skills/comprehension-review/SKILL.md \
  || echo "dot-claude: SKILL.md を取得できませんでした。REPO と REF を確認してください"
exit 0
