#!/usr/bin/env bash
cmd=$(jq -r '.tool_input.command // ""')
if echo "$cmd" | grep -qE '(^|[^[:alpha:]])grep([^[:alpha:]]|$)'; then
    echo '{"continue": false, "stopReason": "grep 대신 rg를 사용하세요. 이 프로젝트에서는 빠른 검색을 위해 ripgrep 사용을 권장합니다."}'
fi
