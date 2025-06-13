#!/bin/bash

# Namespace (change if needed)
namespace=default

# Services and their pod name prefixes
declare -A service_prefixes=(
  ["activemq"]="activemq"
  ["broker-service"]="broker-service"
  ["fraudcheck-system"]="fraudcheck-system"
  ["payment-system"]="payment-system"
  ["payment-system1"]="payment-system1"
  ["redis"]="redis"
)

# Start a new tmux session
session_name="logs"
tmux new-session -d -s "$session_name" -n "${!service_prefixes[@]}" >/dev/null

window_index=0

for service in "${!service_prefixes[@]}"; do
  prefix="${service_prefixes[$service]}"

  # Get all matching pods
  pods=$(oc get pods -n "$namespace" --no-headers -o custom-columns=":metadata.name" | grep "^$prefix")

  if [[ -z "$pods" ]]; then
    echo "No pods found for $service"
    continue
  fi

  # Create a new window for the service
  if [[ $window_index -eq 0 ]]; then
    tmux rename-window -t "$session_name:$window_index" "$service"
  else
    tmux new-window -t "$session_name" -n "$service"
  fi

  pane_index=0
  for pod in $pods; do
    if [[ $pane_index -eq 0 ]]; then
      tmux send-keys -t "$session_name:$window_index" "echo 'Logs for pod: $pod'; oc logs -f $pod -n $namespace" C-m
    else
      tmux split-window -t "$session_name:$window_index" -v
      tmux select-layout -t "$session_name:$window_index" tiled
      tmux send-keys -t "$session_name:$window_index.$pane_index" "echo 'Logs for pod: $pod'; oc logs -f $pod -n $namespace" C-m
    fi
    ((pane_index++))
  done

  ((window_index++))
done

# Attach session
tmux select-window -t "$session_name:0"
tmux attach-session -t "$session_name"
