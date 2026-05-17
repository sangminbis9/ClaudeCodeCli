#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

# Rate limits (same values as /usage)
FIVE_HR=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
SEVEN_DAY=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

make_bar() {
  local pct=$1 color bar="" i
  if   [ "$pct" -ge 90 ]; then color="$RED"
  elif [ "$pct" -ge 70 ]; then color="$YELLOW"
  else color="$GREEN"; fi
  local filled=$((pct / 10)) empty=$((10 - pct / 10))
  i=0; while [ $i -lt $filled ]; do bar="${bar}█"; i=$((i+1)); done
  i=0; while [ $i -lt $empty ];  do bar="${bar}░"; i=$((i+1)); done
  printf "${color}${bar}${RESET} ${pct}%%"
}

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

BRANCH=""
git rev-parse --git-dir > /dev/null 2>&1 && BRANCH=" | 🌿 $(git branch --show-current 2>/dev/null)"

COST_FMT=$(printf '$%.2f' "$COST")
echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR##*/}$BRANCH"
echo -e "     ctx  $(make_bar $PCT) | ${YELLOW}${COST_FMT}${RESET} | ⏱️ ${MINS}m ${SECS}s"
echo -e "     세션 $(make_bar $FIVE_HR)"
echo -e "     주간 $(make_bar $SEVEN_DAY)"
