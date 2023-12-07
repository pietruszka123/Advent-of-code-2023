#!/usr/bin/fish
set -l input $(cat "./input.txt")
set -l time (string sub -s 7 $input[1] | string split -n " " | string join "" )
set -l record (string sub -s 10 $input[2] | string split -n " " | string join "" )

function calculate
    set -f time $argv[1]
    set -f hold $argv[2]
    set -f record $argv[3]
    set -f symbol $argv[4]

    while true
        set -l t (math $hold $symbol 1)
        set -l distance (math $t '*' (math $time '-' $t))
        if test $distance -gt $record
            set -f hold (math $hold '-' 1)
        else
        break
        
        end
    end
    echo $hold
end

set -l d (math $time '*' $time - 4 '*' $record)
set -l shortest (math ceil (math -$time '+' (math sqrt $d)) / -2)
set -l longest (math ceil (math -$time '-' (math sqrt $d)) / -2)
set -l shortest (math $shortest '+' 1)
set -l longest (math $longest '-' 1)

set -l shortest (calculate $time $shortest $record "-")
set -l longest (calculate $time $longest $record "+")

set -l output (math $longest '-' $shortest + 1)
echo "Output: " $output
