---
name: draft-commit
description: staged diff를 보고 Conventional Commits 형식 초안을 만듭니다. 사용자가 /draft-commit <type> "<제목>" 형식으로 호출했을 때만 동작합니다.
argument-hint: '<type> "<제목>"'
disable-model-invocation: true
allowed-tools: Bash(git status *) Bash(git diff *)
---

# Draft Commit Message

## 입력 컨텍스트

- 변경 요약: !`git status --short`
- staged diff: !`git diff --staged`

## 절차

1. 첫 번째 인수(`$0`)를 type으로 사용합니다. 예상 값: feat, fix, refactor, docs, test, chore.
2. 두 번째 인수(`$1`)를 제목으로 사용합니다. 사용자는 따옴표로 여러 단어를 한 인수로 묶어 호출합니다.
3. 입력 컨텍스트의 staged diff를 보고 본문을 3~6줄로 정리합니다.
4. 결과를 아래 형식 그대로 출력합니다.

```text
<type>: <제목>

- 변경 요약 줄 1
- 변경 요약 줄 2
- 변경 요약 줄 3
```

## 금지사항

- `git commit`이나 `git add`를 직접 실행하지 마세요. 초안만 출력합니다.
- staged 변경사항이 없으면 "staged 변경 없음"이라고만 답하세요.
