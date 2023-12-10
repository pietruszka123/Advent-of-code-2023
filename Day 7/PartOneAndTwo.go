package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

const PartTwo = false

type Hand struct {
	cards           [5]int
	bestReplecments [5]int
	_type           int
	bid             int
}

func bestCombinations(arr []int) []int {
	var nums = []int{13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2}
	var best = 0
	var bestArr = []int{}
	var toCheck = [][]int{}
	toCheck = append(toCheck, arr)
	for len(toCheck) > 0 {
		var arr = toCheck[0]
		toCheck = toCheck[1:]
		for i, v := range arr {
			if v == -1 {
				for _, n := range nums {
					var arrCopy = make([]int, len(arr))
					copy(arrCopy, arr)
					arrCopy[i] = n
					toCheck = append(toCheck, arrCopy)
				}
			}
		}
		var t = getType(arr)
		if t > best {
			best = t
			bestArr = arr
		}

	}
	return bestArr
}

func quickSort(arr []Hand) []Hand {
	if len(arr) <= 1 {
		return arr
	}
	var pivot = arr[0]
	var left = []Hand{}
	var right = []Hand{}
	for _, card := range arr[1:] {
		if compareCards(card, pivot) {
			left = append(left, card)
		} else {
			right = append(right, card)
		}
	}
	return append(append(quickSort(left), pivot), quickSort(right)...)
}

func compareCards(a, b Hand) bool {
	if a._type > b._type {
		return false
	} else if a._type < b._type {
		return true
	} else {
		for i := 0; i < len(a.cards); i++ {
			var card = a.cards[i]
			if card > b.cards[i] {
				return false
			} else if card < b.cards[i] {
				return true
			}
		}
	}
	return false
}
func convertToNumber(card rune) int {
	switch card {
	case 'A':
		return 14
	case 'K':
		return 13
	case 'Q':
		return 12
	case 'J':
		if PartTwo {
			return -1
		}
		return 11
	case 'T':
		return 10
	default:
		return int(card) - 48
	}
}
func parseLine(line string) (string, string) {
	var r = strings.Split(line, " ")
	return r[0], r[1]
}
func getType(cards []int) int {
	var chars = map[int]int{}
	for _, c := range cards {
		chars[c]++
	}
	switch len(chars) {
	case 5:
		return 0
	case 4:
		return 1
	case 3:
		for _, v := range chars {
			if v == 3 {
				return 3
			}
			if v == 2 {
				return 2
			}
		}
	case 2:
		for _, v := range chars {
			if v == 4 {
				return 5
			}
			if v == 3 {
				return 4
			}
		}
	case 1:
		return 6
	}
	return -1
}

func main() {
	var file, error = os.Open("./input.txt")
	if error != nil {
		log.Fatal(error)
		return
	}
	var scanner = bufio.NewScanner(file)

	var cardsList = []Hand{}

	for scanner.Scan() {
		var line = scanner.Text()
		var cards, bid = parseLine(line)
		var cardsInt = []int{}
		for _, c := range cards {
			cardsInt = append(cardsInt, convertToNumber(c))
		}

		var bidInt, _ = strconv.Atoi(bid)

		var bestCombination = []int{}
		var value = 0
		if PartTwo {
			bestCombination = bestCombinations(cardsInt)
			value = getType(bestCombination)
		} else {
			value = getType(cardsInt)
		}

		cardsList = append(cardsList, Hand{[5]int(cardsInt), [5]int{}, value, bidInt})
	}
	cardsList = quickSort(cardsList)

	var output = 0

	for i, card := range cardsList {
		output += card.bid * (i + 1)
	}
	fmt.Println("output: ", output)
}
