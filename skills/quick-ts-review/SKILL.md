---
name: quick-ts-review
description: 지정된 TypeScript 파일을 빠르게 리뷰하고 표준 양식의 보고서를 만듭니다. 사용자가 코드 리뷰, TS 리뷰, /quick-ts-review를 언급할 때 호출합니다.
argument-hint: "<file-path>"
context: fork
agent: Explore
allowed-tools: Read Glob Grep
---

# Quick TS Review

## 절차

1. `$ARGUMENTS`로 받은 경로를 Read 도구로 읽습니다.
2. `${CLAUDE_SKILL_DIR}/references/checklist.md`의 항목을 차례로 점검합니다.
3. 관련 파일이 더 있는지 Glob/Grep으로 짧게 확인합니다.
4. `${CLAUDE_SKILL_DIR}/templates/report.md`의 양식을 그대로 채워 결과를 돌려줍니다.

## 출력 규칙

- 보고서 외 잡담은 출력하지 않습니다.
- 점수는 1(낮음)~5(높음)로 매깁니다.
- 라인 번호를 모르면 `?`로 둡니다.

## 한계

- 의존 패키지 동작은 추정하지 않습니다.
- 보안 감사 수준 리뷰는 별도 Skill을 사용하세요.
