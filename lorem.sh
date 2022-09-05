#!/bin/bash

FILE=$1;
#Flattening out the json
#jq '[leaf_paths as $path | {"key": $path | join("."), "value": getpath($path)}] | from_entries' fr.json >> fr_flat.json

#Splitting values into two keys and values array!!!!
declare -a keys_array=($(echo $(jq -r '.[] | to_entries[] | "\(.key)"' $FILE) | tr "\n" " "))
declare -a values_array=($(echo $(jq -r '.[] | to_entries[] | .value | length' $FILE) | tr "\n" " "))

echo "Please wait while converting.."
#curling the lorem according to length 
declare -A conversion
for i in ${!keys_array[@]}; do
	echo "."
	conversion[${keys_array[$i]}]="$(curl -s -X POST https://lipsum.com/feed/json -d "amount="${values_array[$i]}"" -d "what=bytes" -d "start=true" | jq -r ".feed.lipsum" )"
done

#combining the array into json
for i in "${!conversion[@]}"
do
    echo "$i" 
    echo "${conversion[$i]}"
done | jq -n -R 'reduce inputs as $i ({}; . + { ($i): (input) })' >> converted.json

#REGEX_DATE='^\d{2}[/-]\d{2}[/-]\d{4}$'
REGEX_DATE='/{([^}]*)}/'

echo "this is a test {name} {test}" | grep -P -q '/{([^}]*)}/'
echo $?
