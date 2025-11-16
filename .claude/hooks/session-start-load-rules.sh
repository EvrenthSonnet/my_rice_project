#!/usr/bin/env bash
set -euo pipefail

# 使用项目根目录，以防 cwd 不一致
RULES_FILE="$CLAUDE_PROJECT_DIR/claude/rules/Claude-rules.md"

if [ -f "$RULES_FILE" ]; then
  RULES_CONTENT=$(sed 's/"/\\"/g' "$RULES_FILE")

  # 输出 JSON 给 Claude：作为 additionalContext 注入到会话初始上下文中
  cat <<EOF
{
  "suppressOutput": true,
  "hookSpecificOutput": {
    "additionalContext": "$RULES_CONTENT"
  }
}
EOF

  exit 0
fi

# 找不到文件也不要阻断 session
>&2 echo "Warning: Rules file not found: $RULES_FILE"
exit 0
