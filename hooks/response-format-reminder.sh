#!/usr/bin/env bash
# UserPromptSubmit hook: response format reminder

cat <<'EOF'
작업 완료 응답 끝에 반드시 아래 섹션을 ## 헤딩+이모지로 추가하세요 (번호/볼드 금지).

## 📋 진행 요약
- 이번 턴에 한 일 (변경 파일·결과 등 구체적으로)

## 🧭 다음 추천 작업  ← 후속 없으면 섹션 전체 생략
## 🚀 Git 명령  ← git 변경 없으면 생략. 한 줄 && 체인으로.
## 📱 iOS/Codemagic 빌드 필요 여부
- 항상 한 줄: "iOS 빌드 필요: 예/아니오"
- 예: ios-app/ 내 Swift·asset·xcconfig·project.yml·Info.plist 변경 시. 이때 ios-app/project.yml CURRENT_PROJECT_VERSION +1 Edit 수행 후 새 값 안내, git add에 포함.
- 아니오: worker-backend·backend·shared-types·docs·루트 md/json 등 변경 시.
EOF
exit 0
