#!/usr/bin/env python3
import json
import re
import sys

try:
    payload = json.load(sys.stdin)
except json.JSONDecodeError as exc:
    print(f"Hook input is not valid JSON: {exc}", file=sys.stderr)
    sys.exit(1)

prompt = payload.get("prompt", "")

patterns = [
    r"(?i)\b(password|passwd|secret|token|api[_-]?key)\s*[:=]",
    r"sk-[A-Za-z0-9_-]{20,}",
]

if any(re.search(pattern, prompt) for pattern in patterns):
    print(
        json.dumps(
            {
                "decision": "block",
                "reason": "입력에 비밀번호, 토큰, API 키로 보이는 값이 있습니다. 민감 정보를 제거한 뒤 다시 요청하세요.",
            },
            ensure_ascii=False,
        )
    )
    sys.exit(0)

sys.exit(0)
