# Display a random tip from tips.txt
if [[ -f "$HOME/dotfiles/tips.txt" ]]; then
  # Use shuf on Linux, gshuf on macOS (via coreutils), or fall back to awk
  if command -v shuf >/dev/null 2>&1; then
    tip=$(shuf -n 1 "$HOME/dotfiles/tips.txt")
  elif command -v gshuf >/dev/null 2>&1; then
    tip=$(gshuf -n 1 "$HOME/dotfiles/tips.txt")
  else
    tip=$(awk 'BEGIN{srand()} {lines[NR]=$0} END{print lines[int(rand()*NR)+1]}' "$HOME/dotfiles/tips.txt")
  fi
  echo "💡 $tip"
  echo
fi
