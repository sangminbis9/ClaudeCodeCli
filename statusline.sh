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
FIVE_HR_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
SEVEN_DAY_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Format reset timestamp (unix seconds) → "오늘 HH:MM" / "내일 HH:MM" / "MM/DD HH:MM"
fmt_reset() {
  local ts=$1
  [ -z "$ts" ] && { echo ""; return; }
  local today tomorrow target_day
  today=$(date +%Y-%m-%d)
  tomorrow=$(date -d "tomorrow" +%Y-%m-%d 2>/dev/null)
  target_day=$(date -d "@$ts" +%Y-%m-%d 2>/dev/null)
  local hm
  hm=$(date -d "@$ts" +%H:%M 2>/dev/null)
  if [ "$target_day" = "$today" ]; then
    echo "오늘 $hm"
  elif [ "$target_day" = "$tomorrow" ]; then
    echo "내일 $hm"
  else
    echo "$(date -d "@$ts" +%m/%d) $hm"
  fi
}

FIVE_HR_RESET_FMT=$(fmt_reset "$FIVE_HR_RESET")
SEVEN_DAY_RESET_FMT=$(fmt_reset "$SEVEN_DAY_RESET")

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
GRAY='\033[90m'
SESSION_LINE="     세션 $(make_bar $FIVE_HR)"
[ -n "$FIVE_HR_RESET_FMT" ] && SESSION_LINE="$SESSION_LINE ${GRAY}↻ ${FIVE_HR_RESET_FMT}${RESET}"
WEEK_LINE="     주간 $(make_bar $SEVEN_DAY)"
[ -n "$SEVEN_DAY_RESET_FMT" ] && WEEK_LINE="$WEEK_LINE ${GRAY}↻ ${SEVEN_DAY_RESET_FMT}${RESET}"
echo -e "$SESSION_LINE"
echo -e "$WEEK_LINE"
