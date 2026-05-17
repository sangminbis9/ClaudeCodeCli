#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

case "$FILE_PATH" in
  *.js|*.jsx|*.ts|*.tsx|*.json|*.css|*.md)
    npx prettier --write "$FILE_PATH"
    ;;
esac

exit 0
