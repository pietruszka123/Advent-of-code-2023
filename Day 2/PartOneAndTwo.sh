#!/bin/bash
input=$(cat input.txt)
partTwo=true

function sumArray() {
    local sum=0
    for i in "$@"; do
        sum=$(($sum+$i))
    done
    echo $sum
}
function largestInArray(){
    local largest=0
    for i in "$@"; do
        if (($i > $largest)); then
            largest=$i
        fi
    done
    echo $largest

}

output=()
while read line; do
    game_id=$(echo $line | awk '{print substr($2,1,length($2)-1)}')
    blue=$(largestInArray $(echo $line | grep -Eo '[0-9]+\sblue' | awk '{print $1}'))
    green=$(largestInArray $(echo $line | grep -Eo '[0-9]+\sgreen' | awk '{print $1}'))
    red=$(largestInArray $(echo $line | grep -Eo '[0-9]+\sred' | awk '{print $1}'))
    if $partTwo; then 
        output+=($(expr "$blue" "*" "$green" "*" "$red"))
    else 
    if (($red <= 12)) && (($green <= 13)) && (($blue <= 14)) ; then
        output+=($game_id)
        fi
    fi

done <<< "$input"

echo "Sum: $(sumArray ${output[@]})"