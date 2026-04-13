#!/bin/bash
# SetupAutoDeploy.command
# Double-click this ONCE to enable fully automatic deployment.
# After setup, your site deploys on its own whenever files change — no clicking required.

cd "$(dirname "$0")"
TAOR_DIR="$(pwd)"
SCRIPT_PATH="$TAOR_DIR/AutoDeploy.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.theageofreason.autodeploy.plist"

echo ""
echo "⚙️  Setting up automatic deployment for The Age of Reason..."
echo "   Folder: $TAOR_DIR"
echo ""

# --- Create the AutoDeploy.sh script ---
cat > "$SCRIPT_PATH" << SCRIPT
#!/bin/bash
cd "$TAOR_DIR"

# Check for any changes — tracked files or new untracked files
if git diff --quiet && git diff --cached --quiet && [ -z "\$(git ls-files --others --exclude-standard)" ]; then
    exit 0
fi

# Changes found — commit and push
git add -A
git commit -m "Auto-deploy \$(date '+%B %d, %Y at %I:%M %p')"
git push
SCRIPT
chmod +x "$SCRIPT_PATH"

# --- Create the LaunchAgent plist (runs every 2 minutes) ---
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.theageofreason.autodeploy</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>StartInterval</key>
    <integer>120</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$TAOR_DIR/deploy.log</string>
    <key>StandardErrorPath</key>
    <string>$TAOR_DIR/deploy.log</string>
</dict>
</plist>
PLIST

# --- Load the agent ---
launchctl unload "$PLIST_PATH" 2>/dev/null
launchctl load "$PLIST_PATH"

echo "✅ Auto-deploy is now active!"
echo ""
echo "   Your Mac will now check for changes every 2 minutes."
echo "   When Claude edits your site files, they will deploy automatically"
echo "   to theageofreason.org — even if you're on your phone."
echo ""
echo "   A deploy.log file in your TAoR folder will record each deploy."
echo ""
read -p "Press Enter to close..."
