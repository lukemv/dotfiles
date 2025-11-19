# Display a random tip from tips.txt
if [[ -f "$HOME/dotfiles/tips.txt" ]]; then
  tip=$(shuf -n 1 "$HOME/dotfiles/tips.txt")
  echo "💡 $tip"
  echo
fi
