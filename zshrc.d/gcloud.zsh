CLOUD_SDK_PATH="$HOME/google-cloud-sdk"
items=(
	"$CLOUD_SDK_PATH/path.zsh.inc"
	"$CLOUD_SDK_PATH/completion.zsh.inc"
)

for item in "${items[@]}"; do
	if [ -f "$item" ]; then
		. "$item"
	fi
done
