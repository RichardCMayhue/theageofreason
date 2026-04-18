#!/bin/bash
cd ~/Desktop/TAoR
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    exit 0
fi
git add -A
git commit -m "Auto-deploy $(date '+%B %d, %Y at %I:%M %p')"
git push
