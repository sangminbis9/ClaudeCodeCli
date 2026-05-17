#!/usr/bin/env python3
import json
import re
import sys

try:
    payload = json.load(sys.stdin)
except json.JSONDecodeError as exc:
    print(f"Hook input is not valid JSON: {exc}", file=sys.stderr)
    sys.exit(1)

command = payload.get("tool_input", {}).get("command", "")

blocked = [
    (r"rm\s+-rf\s+/", "루트 디렉터리 삭제 패턴"),
    (r"rm\s+-rf\s+\.", "현재 디렉터리 전체 삭제 패턴"),
    (r"git\s+push\s+.*(--force|-f)", "강제 push"),
    (r"mkfs\.", "파일 시스템 포맷"),
    (r"dd\s+if=.+of=/dev/", "블록 디바이스 직접 쓰기"),
    (r":\(\)\{\s*:\|:&\s*\};:", "fork bomb"),
]

for pattern, label in blocked:
    if re.search(pattern, command, re.IGNORECASE):
        print(f"차단됨: {label}. 실행하려던 명령: {command}", file=sys.stderr)
        sys.exit(2)

sys.exit(0)
