#!/bin/bash


SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

if [[ ! $CUSTIOM_URL ]]; then
    echo "${RED} pool url is NULL! ${NCOLOR}"
fi

ARGS_LINE="-u $CUSTOM_URL -m $SCRIPT_DIR/tonguys_miner"

for i in $(echo $CUSTOM_USER_CONFIG); do
    key=$(echo $i | awk -F '=' '{print $1}') 
    val=$(echo $i | awk -F '=' '{print $2}')

    if [[ $key = 'token' ]]; then
        ARGS_LINE="$ARGS_LINE -t $val"
    elif [[ $key = 'gpus' ]]; then
        ARGS_LINE="$ARGS_LINE -G $val"
    fi
done

echo "CLI_ARGS=$ARGS_LINE" > $CUSTOM_CONFIG_FILENAME
