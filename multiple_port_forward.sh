#!/bin/bash

CONFIG_FILE="vm_services.json"
BASTION_ID="ocid1.bastion.oc1.ap-melbourne-1.amaaaaaawiclygaazrbmmbzo6dop2w7yyrd2lhmlpx6aecvfg7n64srizpoa"
PUBLIC_KEY_FILE="/Users/shadab/Downloads/shadablenovo.pub"
PRIVATE_KEY_FILE="/Users/shadab/Downloads/mydemo_vcn.priv"
PROFILE="apaccpt04"
STARTING_LOCAL_PORT=2222

oci setup repair-file-permissions --file $PRIVATE_KEY_FILE
eval "$(ssh-agent -s)"
ssh-add $PRIVATE_KEY_FILE

if ! command -v jq &> /dev/null; then
    echo "❌ 'jq' is required but not installed. Install it and try again."
    exit 1
fi

echo ""
echo "=== 🚀 Launching Port-Forwarding Sessions from $CONFIG_FILE ==="
echo ""

LOCAL_PORT=$STARTING_LOCAL_PORT
SESSION_COMMANDS=()

NUM_ENTRIES=$(jq length "$CONFIG_FILE")

for (( i=0; i<$NUM_ENTRIES; i++ )); do
  LABEL=$(jq -r ".[$i].label" "$CONFIG_FILE")
  PRIVATE_IP=$(jq -r ".[$i].private_ip" "$CONFIG_FILE")
  RESOURCE_ID=$(jq -r ".[$i].resource_id // empty" "$CONFIG_FILE")

  SERVICE_COUNT=$(jq ".[$i].services | length" "$CONFIG_FILE")

  for (( j=0; j<$SERVICE_COUNT; j++ )); do
    SERVICE_NAME=$(jq -r ".[$i].services[$j].name" "$CONFIG_FILE")
    REMOTE_PORT=$(jq -r ".[$i].services[$j].remote_port" "$CONFIG_FILE")

    echo "➡️  Creating session: [$LABEL - $SERVICE_NAME] ($PRIVATE_IP:$REMOTE_PORT)..."

    CMD_ARGS=(
      --bastion-id "$BASTION_ID"
      --session-ttl 10800
      --profile "$PROFILE"
      --target-private-ip "$PRIVATE_IP"
      --target-port "$REMOTE_PORT"
      --ssh-public-key-file "$PUBLIC_KEY_FILE"
    )

    if [ -n "$RESOURCE_ID" ]; then
      CMD_ARGS+=(--target-resource-id "$RESOURCE_ID")
    fi

    SESSION_ID=$(oci bastion session create-port-forwarding \
      "${CMD_ARGS[@]}" \
      --query 'data.id' --raw-output)

    if [ -z "$SESSION_ID" ]; then
      echo "❌ Failed to create session for [$LABEL - $SERVICE_NAME]"
      continue
    fi

    echo "🟢 Session ID: $SESSION_ID - waiting to be ACTIVE..."

    until [ "$(oci bastion session get --session-id "$SESSION_ID" --profile "$PROFILE" --query 'data."lifecycle-state"' --raw-output)" == "ACTIVE" ]; do
        sleep 3
    done

    echo "✅ ACTIVE: [$LABEL - $SERVICE_NAME]"

    SSH_COMMAND=$(oci bastion session get --session-id "$SESSION_ID" --profile "$PROFILE" --query 'data."ssh-metadata"."command"' --raw-output)
    SSH_COMMAND=$(echo "$SSH_COMMAND" | sed "s|<privateKey>|$PRIVATE_KEY_FILE|g" | sed "s|<localPort>|$LOCAL_PORT|g")

    SESSION_COMMANDS+=("[$LABEL][$SERVICE_NAME] localhost:$LOCAL_PORT ➡ $PRIVATE_IP:$REMOTE_PORT
$SSH_COMMAND
")
    LOCAL_PORT=$((LOCAL_PORT + 1))
  done
done

echo ""
echo "=== 🧪 ALL SSH TUNNEL COMMANDS ==="
for CMD in "${SESSION_COMMANDS[@]}"; do
  echo "################################################################"
  echo "$CMD"
  echo "################################################################"
  echo ""
done

echo "🎉 All sessions active. Copy & paste your tunnel commands above into new terminal tabs!"

