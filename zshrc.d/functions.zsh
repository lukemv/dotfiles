
function ,mute {
  pamixer --mute
}

function ,unmute {
  pamixer --mute
}

function ,alias
{
  cmd=$(cat ~/dotfiles/zshrc.d/alias.zsh | fzf)
  cmd=$(echo $cmd | cut -d '=' -f1 | cut -d ' ' -f2)
  eval $cmd
}

function ,codepaths {
  p=$(find ~/code -name .git -type d -prune | xargs -I {} dirname {} | fzf)
  echo $p
}

function ,awsenv {
  echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
  echo "AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY"
  echo "AWS_SESSION_TOKEN: $AWS_SESSION_TOKEN"
  echo "AWS_DEFAULT_PROFILE: $AWS_DEFAULT_PROFILE"
  echo "AWS_PROFILE: $AWS_PROFILE"
  echo "AWS_REGION: $AWS_REGION"
  echo "AWS_PROFILE: $AWS_PROFILE"
  echo "AWS_ROLE_ARN: $AWS_ROLE_ARN"
}

function ,kdebug {
  target=$1
  kubectl debug -it --attach=false -c deleteme-debug --image=ubuntu:20.04 ${target}
  kubectl get pod ${target} \
    -o jsonpath='{.spec.ephemeralContainers}' \
    | python3 -m json.tool
}

function ,events-sorted {
  kubectl get events \
    --no-headers \
    --watch-only \
    --all-namespaces \
    --field-selector involvedObject.name=temp-db-restorer-nue -ojson \
    | TZ=UTC jq -r '. | select ( .lastTimestamp | fromdateiso8601 > now - 60 ) | "'"$amber"'\( .kind ):\t\( .lastTimestamp )\t\( .reason )\t\( .involvedObject.fieldPath )\t\( .message )'"$reset"'"'
}

function scripts {
  chmod a+x ~/.scripts
  ls ~/.scripts
}

function kgnode {
  kg_resource "node"
}

function ,pod {
  kg_resource "pod"
}

function ,service {
  kg_resource "service"
}

function ,node {
  kg_resource "node"
}

function kg_resource {
  local resource_type=$1
  local pod=$(kubectl get $resource_type --no-headers | fzf | awk '{print $1}')
  kubectl get $resource_type/$pod -o yaml | vim -c 'set syntax=yaml' -
}

function ,plogs {
  local pod=$(kubectl get pod --no-headers | fzf | awk '{print $1}')
  kubectl logs -f pod/$pod
}

function ssm {
  local instance_id=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, instance_id: InstanceId, ip_address: PrivateIpAddress, state: State.Name}" --output text | fzf | awk '{print $1}')
  echo "Starting SSM Session: $instance_id"
  aws ssm start-session --target $instance_id
}

# Note that you can do this to only see a subset of these logs:
# ,kustomize-logs | jq '. | select(.name == "prom-jmx-exporter")'
function ,kustomize-logs {
  pod=$(kubectl get pods -n flux-system | grep kustomize | awk '{print $1}')
  kubectl logs -f -n flux-system $pod
}

function ,gh__issues {
  fzfSelected=$(gh issue list -R "$1" | fzf )
  fzfResult="$?"

  if [ "$fzfResult" = "0" -a -n "$fzfSelected" ]; then
    gh issue view -R "$1" "$(echo "$fzfSelected" | awk -F "\t" '{print $1}')"
  fi
}

function ,gh__merge {
  # This will have to do for now, this is the only way
  # that we can get a clean merge that preserves the commit
  local branch=$(git rev-parse --abbrev-ref HEAD)
  git checkout main
  git pull --rebase
  git merge $branch --ff-only
  # Then review, and push
}

function ,provision {
  cd /srv/bootstrap/ansible
  ansible-galaxy install -r requirements.yml
  ansible-playbook -c 'local' playbook.yml --tags "user"
}

function ,dockerps {
  docker ps --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}"
}

function ,git_tidy() {
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|^refs/remotes/origin/||')

  if [[ -z $default_branch ]]; then
    if git show-ref --verify --quiet refs/heads/main; then
      default_branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
      default_branch="master"
    else
      echo "Could not determine default branch."
      return 1
    fi
  fi

  git checkout "$default_branch" || return 1

  git fetch --prune

  for branch in $(git branch | sed 's/\*//'); do
    branch=$(echo $branch | xargs) # Trim whitespace

    if ! git branch -r | grep -q "origin/$branch"; then
      if [ "$branch" != "$default_branch" ]; then
        echo "Force deleting local branch '$branch'"
        git branch -D "$branch"
      fi
    fi
  done

  git remote prune origin
}

function ,res() {
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|^refs/remotes/origin/||')

  if [[ -z $default_branch ]]; then
    if git show-ref --verify --quiet refs/heads/main; then
      default_branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
      default_branch="master"
    else
      echo "Could not determine default branch."
      return 1
    fi
  fi

  # Now checkout and pull with rebase
  git checkout "$default_branch" && git pull --rebase
}

# This function will add the PR number to the commit message
function ,prbb() {
  pr_num="$1"
  subject=$(git log -1 --pretty=format:%s)
  body=$(git log -1 --pretty=format:%b)

  new_subject="$subject (pull request #$pr_num)"

  git commit --amend -m "$new_subject" -m "$body"
  git push --force-with-lease
}

# Fetch and rebase
function ,far() {
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|^refs/remotes/origin/||')

  if [[ -z $default_branch ]]; then
    if git show-ref --verify --quiet refs/heads/main; then
      default_branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
      default_branch="master"
    else
      echo "Could not determine default branch."
      return 1
    fi
  fi

  # Now checkout and pull with rebase
  git fetch --all
  git rebase origin/"$default_branch"
}

,d() {
    local dir=$(find . -mindepth 1 -type d | fzf --height 40% --layout=reverse --border --preview 'tree -C {} | head -200')
    # Check if a directory was selected
    if [ -n "$dir" ]; then
        cd "$dir" || echo "Error: Unable to change directory to $dir"
    else
        echo "No directory selected"
    fi
}

# uses 'z' to search the recent stack
# pipes via fzf to select a directory
# then cd's to that directory
fz() {
  local dir=$(z $@ | fzf | awk '{ print $2 }')
  if [ -n "$dir" ]; then
      cd "$dir" || echo "Error: Unable to change directory to $dir"
  else
      echo "No directory selected"
  fi
}

,docker-volume-find() {
  if [[ -z "$1" ]]; then
      echo "Usage: ,docker-volume-find <directory>"
      return 1
  fi

  volume_name=$1

  docker ps -aq | while read container_id; do
      if docker inspect "$container_id" | jq -e ".[] | .Mounts[]? | select(.Name==\"$volume_name\")" > /dev/null; then
          echo "Volume '$volume_name' is mounted to container ID: $container_id"
      fi
  done
}

,tf_clean() {
    # Ensure a directory is supplied
    if [[ -z "$1" ]]; then
        echo "Usage: tf_clean <directory>"
        return 1
    fi

    # Check if the provided argument is a valid directory
    if [[ ! -d "$1" ]]; then
        echo "'$1' is not a valid directory."
        return 1
    fi

    # Find and remove all .terraform directories
    find "$1" -type d -name ".terraform" -exec rm -rf {} +

    echo "All .terraform directories removed from '$1' and its subdirectories."
}

function ,hyprfix {
  # Discover and export the correct HYPRLAND_INSTANCE_SIGNATURE
  echo "[hyprfix] Searching for active Hyprland instance..."

  for dir in /run/user/1000/hypr/*; do
    echo "[hyprfix] Checking: $dir"
    if [ -S "$dir/.socket.sock" ]; then
      echo "[hyprfix] Found socket in: $dir"
      export HYPRLAND_INSTANCE_SIGNATURE=$(basename "$dir")
      echo "[hyprfix] HYPRLAND_INSTANCE_SIGNATURE set to: $HYPRLAND_INSTANCE_SIGNATURE"
      break
    else
      echo "[hyprfix] No socket found in: $dir"
    fi
  done

  # Confirm
  if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "[hyprfix] ❌ No valid Hyprland socket found."
  else
    echo "[hyprfix] ✅ Ready to use hyprctl."
  fi
}

,gb() {
  (env -i HOME="$HOME" PATH="$PATH" bash --noprofile --norc -c '
    set -e
    cmd_dir="$HOME/dotfiles/goutils/cmd"
    for path in "$cmd_dir"/*; do
      [ -d "$path" ] || continue
      tool="${path##*/}"
      echo "Installing $tool..."
      (cd "$HOME/dotfiles/goutils" && go install "./cmd/$tool")
    done
  ')
}

,lock() {
  swaylock -f -l
}

,binds() {
  echo "ALT + N: lock screen"
  echo "ALT + W: kill window"
  echo "ALT + D: wofi"
}


gpush() {
  output=$(git push "$@" 2>&1 | tee /dev/tty)
  url=$(echo "$output" | grep -Eo 'https://bitbucket\.org/[^ ]+')
  if [ -n "$url" ]; then
    xdg-open "$url" >/dev/null 2>&1 &  # Linux
    # open "$url" >/dev/null 2>&1 &    # macOS
  fi
}


