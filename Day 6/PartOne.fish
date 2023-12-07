#!/usr/bin/fish
set -l input $(cat "./input.txt")
# get first line and remove "Times: " and split by space
set -l times (string sub -s 7 $input[1] | string split -n " " )
set -l records (string sub -s 10 $input[2] | string split -n " " )

set -g output 1
for i in (seq (count $times))
    set -g count 0
    set -g currentTime 0
    echo $i
    while test $currentTime -lt $times[$i]
        set -l d (math $times[$i] '-' $currentTime)
        set -l distance (math $currentTime '*' $d)
        
        if test $distance -gt $records[$i]
            echo $distance $count $records[$i]
            set -g count (math $count '+' 1)
        end
        set -g currentTime (math $currentTime '+' 1) 
    end
    echo "count" $count
    set -g output (math $output '*' $count)
end
echo "a: " $output
