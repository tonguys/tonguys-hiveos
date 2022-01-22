#!/bin/bash

#-------------------------------------------------------------------------
# ENVIRONMENT (DETERMINED BY SCRIPT)
#-------------------------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
. $SCRIPT_DIR/h-manifest.conf
. $SCRIPT_DIR/$CUSTOM_NAME.conf

MINER_KEYS=$GPUS

#echo "$MINER_KEYS"
# debug

#-------------------------------------------------------------------------
# READ GPU STATS FROM HIVE OS
#-------------------------------------------------------------------------

# fill some arrays from gpu-stats
temps=(`cat $GPU_STATS_JSON | jq -r ".temp[]"`)
fans=(`cat $GPU_STATS_JSON | jq -r ".fan[]"`)
powers=(`cat $GPU_STATS_JSON | jq -r ".power[]"`)
busids=(`cat $GPU_STATS_JSON | jq -r ".busids[]"`)
brands=(`cat $GPU_STATS_JSON | jq -r ".brand[]"`)
indexes=()

#echo "asdasdasdas"
# filter arrays by $TYPE
cnt=${#busids[@]}
for (( i=0; i < $cnt; i++)); do
	if [[ "${brands[$i]}" != "cpu" ]]; then
        indexes+=($i)
        continue
	else # remove arrays data
		unset temps[$i]
		unset fans[$i]
		unset powers[$i]
		unset busids[$i]
		unset brands[$i]
	fi
done

#-------------------------------------------------------------------------
# READ MINER STAT
#-------------------------------------------------------------------------

STATUS_HS=()
STATUS_TEMP=()
STATUS_FAN=()
STATUS_BUS_NUMBERS=()

for (( i=0; i < ${#indexes[@]}; i++)); do
    #echo "GPU ID $i ${busids[${indexes[$i]}]}"
    BUS_NUMER_HEX=$(echo "${busids[${indexes[$i]}]:0:2}" | tr "a-z" "A-Z")
    BUS_NUMBER=$(echo "obase=10; ibase=16; $BUS_NUMER_HEX" | bc)

    STATUS_BUS_NUMBERS+=($BUS_NUMBER)
    STATUS_TEMP+=(${temps[${indexes[$i]}]})
    STATUS_FAN+=(${fans[${indexes[$i]}]})
done

# calc total hashrate and uptime
khs=0
STATUS_UPTIME=0
KEYS=($(echo $MINER_KEYS | jq -c -r '.[] | @sh' | tr -d \'))
STATUS_FILE="$SCRIPT_DIR/stats.json"
for (( i=0; i < ${#KEYS[@]}; i++)); do
	KEY=${KEYS[$i]}
    stt=$(jq -c ".stats[] | select(.device==$KEY)" $STATUS_FILE)

    STATUS_PASSED=$(echo $stt | jq -c ".uptime")
    if [[ $STATUS_UPTIME < $STATUS_PASSED ]]; then
        STATUS_UPTIME=$STATUS_PASSED
    fi
    STATUS_INSTANT_SPEED=$(echo $stt | jq -r ".hashrate")
    khs=`echo $khs + $STATUS_INSTANT_SPEED | bc`
    STATUS_HS+=($STATUS_INSTANT_SPEED)
done

#-------------------------------------------------------------------------
# COLLECT
#-------------------------------------------------------------------------

khs=`echo $khs*1000 | bc`
hs=$(echo "${STATUS_HS[@]}" | jq -s '.')
temp=$(echo "${STATUS_TEMP[@]}" | jq -s '.')
fan=$(echo "${STATUS_FAN[@]}" | jq -s '.')
bus_numbers=$(echo "${STATUS_BUS_NUMBERS[@]}" | jq -s '.')

#echo $hs $temp $fan $bus_numbers
stats=$(
  jq -n \
    --argjson hs "$hs" \
    --argjson temp "$temp" \
    --argjson fan "$fan" \
    --arg uptime "$STATUS_UPTIME" \
    --arg ver "$CUSTOM_VERSION" \
    --argjson bus_numbers "$bus_numbers" \
    '{"hs": $hs, "hs_units": "mhs", "temp": $temp, "fan": $fan, "uptime": $uptime, "ver": $ver, "bus_numbers":$bus_numbers}' <<<"$stats_raw"
)

[[ -z $khs ]] && khs=0
[[ -z $stats ]] && stats="null"

# debug
echo $stats
echo $khs
