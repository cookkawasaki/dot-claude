#!/bin/bash
# claude.ai/code の「自分の環境（Personal）」の Setup script に、この中身を貼る。
# REF はブランチ名ではなくコミットの SHA にする（中身はAIへの指示として読まれるため、固定しておく）。
# 更新したいときは REF を書き換える。スクリプトが変わると環境のキャッシュも作り直される。

REF=ここにコミットのSHA
REPO=cookkawasaki/dot-claude
BASE="https://raw.githubusercontent.com/$REPO/$REF"

mkdir -p ~/.claude/skills/comprehension-review
curl -fsSL "$BASE/CLAUDE.md" -o ~/.claude/CLAUDE.md || true
curl -fsSL "$BASE/skills/comprehension-review/SKILL.md" \
  -o ~/.claude/skills/comprehension-review/SKILL.md || true
