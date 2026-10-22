# Remove the default welcome message
set -g fish_greeting ""

# Create a custom alias (shortcut) to list files with details
alias ll="ls -la"

# Set Ghostty as default terminal for apps that respect $TERMINAL
set -gx TERMINAL ghostty
# opencode
fish_add_path /home/castaway/.opencode/bin
