#!/usr/bin/env bash


SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

ARGS_LINE="-u server1.tonguys.com -m $SCRIPT_DIR/tonguys_miner"

for i in $(echo $CUSTOM_USER_CONFIG); do
    key=$(echo $i | awk -F '=' '{print $1}') 
    val=$(echo $i | awk -F '=' '{print $2}')

    if [[ $key = 'token' ]]; then
        ARGS_LINE="$ARGS_LINE -t $val"
    elif [[ $key = 'gpus' ]]; then
        ARGS_LINE="-G $val $ARGS_LINE"
    fi
done

echo "CLI_ARGS=\"$ARGS_LINE\"" > "$CUSTOM_CONFIG_FILENAME"
