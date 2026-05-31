#!/usr/bin/env bash
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

new_cmd=$(printf '%s' "$cmd" | perl -pe '
    s/\bgit\s+grep\b/\x00GITGREP\x00/g;
    s/--grep/\x00DDGREP\x00/g;
    s/\bgrep\b/rg/g;
    s/\x00GITGREP\x00/git grep/g;
    s/\x00DDGREP\x00/--grep/g;
')

if [ "$cmd" != "$new_cmd" ]; then
    jq -nc --arg cmd "$new_cmd" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        updatedInput: {command: $cmd}
      },
      systemMessage: ("grep → rg 자동 치환: " + $cmd)
    }'
fi
