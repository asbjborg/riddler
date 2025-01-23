#!/bin/bash

# GitHub PR creation function
create_pr() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: create_pr \"title\" \"body\""
    return 1
  fi
  
  local title="$1"
  local body="$2"
  local branch=$(git rev-parse --abbrev-ref HEAD)
  
  curl -L -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(security find-generic-password -a "$USER" -s "github-riddler-token" -w)" \
    "https://api.github.com/repos/asbjborg/riddler/pulls" \
    -d "{\"title\":\"$title\",\"head\":\"$branch\",\"base\":\"main\",\"body\":\"$body\"}"
}

# GitHub Issue Checking Functions
check_features() {
    local token=$(security find-generic-password -a "$USER" -s "github-riddler-token" -w)
    echo "📋 Open Feature Requests:"
    curl -s -H "Accept: application/vnd.github+json" \
         -H "Authorization: Bearer $token" \
         "https://api.github.com/repos/asbjborg/riddler/issues?labels=enhancement&state=open" \
    | jq -r '.[] | "  #\(.number) \(.title)"'
}

check_bugs() {
    local token=$(security find-generic-password -a "$USER" -s "github-riddler-token" -w)
    echo "🐛 Open Bug Reports:"
    curl -s -H "Accept: application/vnd.github+json" \
         -H "Authorization: Bearer $token" \
         "https://api.github.com/repos/asbjborg/riddler/issues?labels=bug&state=open" \
    | jq -r '.[] | "  #\(.number) \(.title)"'
}

check_issues() {
    local token=$(security find-generic-password -a "$USER" -s "github-riddler-token" -w)
    echo "📝 All Open Issues:"
    curl -s -H "Accept: application/vnd.github+json" \
         -H "Authorization: Bearer $token" \
         "https://api.github.com/repos/asbjborg/riddler/issues?state=open" \
    | jq -r '.[] | "  #\(.number) [\(.labels[].name // "unlabeled")] \(.title)"'
} 