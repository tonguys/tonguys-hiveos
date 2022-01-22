#!/usr/bin/env bash


SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"


. $SCRIPT_DIR/h-manifest.conf

echo "Downloading client release: $CLIENT_RELEASE_URL ..."
wget $CLIENT_RELEASE_URL -O $SCRIPT_DIR/client.tar.gz

echo "Extracting client archive..."
tar -xzf $SCRIPT_DIR/client.tar.gz -C $SCRIPT_DIR

ARGS_LINE="-u pool.tonguys.com -m $SCRIPT_DIR/tonguys_miner -L $SCRIPT_DIR/asd.asd"

inds="[]"

for i in $(echo $CUSTOM_USER_CONFIG); do
    key=$(echo $i | awk -F '=' '{print $1}') 
    val=$(echo $i | awk -F '=' '{print $2}')

    if [[ $key = 'token' ]]; then
        ARGS_LINE="$ARGS_LINE -t $val"
    elif [[ $key = 'gpus' ]]; then
        ARGS_LINE="-G $val $ARGS_LINE"
	for gpu in $(echo "${val:1:-1}" | sed "s/,/\n/g"); do
                if [[ $gpu == *"-"* ]]; then
                        for (( gpu_i=${gpu: 0:1}; gpu_i<=${gpu:2:2}; gpu_i++ )); do
                                inds=$(echo "$inds" | jq ".[.| length] |= .+ $gpu_i")
                        done
                else
                        inds=$(echo "$inds" | jq ".[.| length] |= .+ $gpu")
                fi
        done
    fi
done

echo "EXEC_LINE=\"$SCRIPT_DIR/client $ARGS_LINE\"" > "$CUSTOM_CONFIG_FILENAME"
echo "EXEC_LINE=\"$SCRIPT_DIR/cliechent $ARGS_LINE\""
echo "GPUS=$(echo $inds | jq -c ".")" >> "$CUSTOM_CONFIG_FILENAME"
echo "GPUS=$(echo $inds | jq -c ".")"
