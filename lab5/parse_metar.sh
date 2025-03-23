#!/bin/bash

curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json

jq -r '.[].receiptTime' aviation.json | head -6

temps=()
while IFS= read -r temp; do
	if [[ "$temp" =~ ^-?[0-9]+$ ]]; then
		temps+=("$temp")
	fi
done < <(jq -r '.[].temp' aviation.json)

sum=0
count=0
for temp in "${temps[@]}"; do
	sum=$((sum + temp))
	((count++))
done

avg_temp="N/A"
if ((count > 0)); then
	avg_temp=$(echo "scale=1; $sum / $count" | bc)
fi

echo "Average Temperature: $avg_temp"

cloudy=0
total=0
while IFS= read -r cloud; do
	((total++))
	[[ "$cloud" != "CLR" ]] && ((cloudy++))
done < <(jq -r '.[].cloud' aviation.json)

mostly_cloudy=false
((cloudy > total / 2)) && mostly_cloudy=true

echo "Mostly Cloudy: $mostly_cloudy"
