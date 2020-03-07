
function kubectl_status
  [ -z "$KUBECTL_PROMPT_ICON" ]; and set -l KUBECTL_PROMPT_ICON "⎈"
  [ -z "$KUBECTL_PROMPT_SEPARATOR" ]; and set -l KUBECTL_PROMPT_SEPARATOR "/"
  set -l config $KUBECONFIG
  [ -z "$config" ]; and set -l config "$HOME/.kube/config"
  if [ ! -f $config ]
    echo (set_color red)$KUBECTL_PROMPT_ICON" "(set_color white)"no config"
    return
  end

  set -l ctx (kubectl config current-context 2>/dev/null)
  if [ $status -ne 0 ]
    echo (set_color red)$KUBECTL_PROMPT_ICON" "(set_color white)"no context"
    return
  end

  set -l ns (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$ctx\")].context.namespace}")
  [ -z $ns ]; and set -l ns 'default'

  echo (set_color cyan)$KUBECTL_PROMPT_ICON" "(set_color white)"($ctx$KUBECTL_PROMPT_SEPARATOR$ns)"
end


function fish_prompt
  set -l time (set_color yellow)(date "+(%H:%M:%S)")
  set -l dir (set_color white)"["(prompt_pwd)"]"
  set -l git (set_color green)(git rev-parse --abbrev-ref HEAD 2>/dev/null; or echo "")
  set -l cursor (set_color red)"❯"(set_color yellow)"❯"(set_color green)"❯ "

  set -l kube (set_color white)(kubectl_status)

  echo $dir $time $git $kube
  echo $cursor
end
