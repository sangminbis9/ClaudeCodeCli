---
name: kickoff-log
description: 작업 시작 기록을 work-log.txt에 한 줄 남깁니다. 사용자가 "작업 시작", "킥오프", "지금부터 시작" 같은 말을 하거나 /kickoff-log를 직접 호출할 때 사용합니다.
allowed-tools: Bash(date *) Bash(echo *)
---

# Kickoff Log

작업을 시작할 때 다음 절차를 따르세요.

1. 현재 시각을 `YYYY-MM-DD HH:MM` 형식으로 가져옵니다.
2. 아래 한 줄을 `work-log.txt` 끝에 추가합니다. 파일이 없으면 append redirection이 자동으로 만들어주므로 별도 생성 명령은 실행하지 않습니다.

```text
[YYYY-MM-DD HH:MM] kickoff: <메시지>
```

`<메시지>`는 사용자가 알려준 작업 주제를 그대로 사용하세요. 비어 있으면 `untitled`로 둡니다.

추가가 끝나면 "킥오프 기록 완료"만 짧게 보고하세요.
