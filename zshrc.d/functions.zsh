
function ,alias
{
  cmd=$(cat ~/dotfiles/.zshrc.d/alias.zsh | fzf)
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

function zc {
  readonly args=${1:?"required <args> for z missing"}
  code "$( z -e ${args})"
}

function zcr() {
  code $(z | fzf | awk '{print $2}')
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
  ansible-playbook -c 'local' playbook.yml --tags "user"
}