#!/bin/bash
cd "/Users/cammayhuem5/Desktop/TAoR"

# Check for any changes — tracked files or new untracked files
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    exit 0
fi

# Changes found — commit and push
git add -A
git commit -m "Auto-deploy $(date '+%B %d, %Y at %I:%M %p')"
git push
