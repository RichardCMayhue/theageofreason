#!/bin/bash
# Deploy The Age of Reason website
# Double-click this file from Finder to publish your changes live

cd ~/Desktop/TAoR

# Check if there are any changes to deploy
if git diff --quiet && git diff --cached --quiet; then
  echo "✅ No changes to deploy — your site is already up to date."
  echo ""
  read -p "Press Enter to close..."
  exit 0
fi

echo "📦 Preparing your changes..."
git add -A

# Create a commit with today's date
COMMIT_MSG="Update site $(date '+%B %d, %Y at %I:%M %p')"
git commit -m "$COMMIT_MSG"

echo ""
echo "🚀 Deploying to theageofreason.org..."
git push

echo ""
echo "✅ Done! Your site will be live at https://theageofreason.org"
echo "   (Netlify usually takes 20–30 seconds to update.)"
echo ""
read -p "Press Enter to close..."
