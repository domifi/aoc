package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
	"sort"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// F=0, B=1, L=0, R=1
func readSeatIDs(r io.Reader) ([]int, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	var result []int
	for scanner.Scan() {
		text := scanner.Text()
		text = strings.ReplaceAll(text, "F", "0")
		text = strings.ReplaceAll(text, "B", "1")
		text = strings.ReplaceAll(text, "L", "0")
		text = strings.ReplaceAll(text, "R", "1")

		x, err := strconv.ParseInt(text, 2, 11)
		if err != nil {
			return result, err
		}
		result = append(result, int(x))
	}
	return result, scanner.Err()
}

func getMax(slice []int) int {
	ret := 0
	for _, v := range slice {
		if v > ret {
			ret = v
		}
	}
	return ret
}

func getMissing(slice []int) (int, error) {
	if len(slice) < 2 {
		return 0, errors.New("can't look for missing seat in slice with length < 2")
	}
	ret := slice[0]
	for i, j := 0, 1; j < len(slice); {
		if slice[i]+1 != slice[j] {
			return slice[i] + 1, nil
		}
		i++
		j++
	}
	return ret, nil
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readSeatIDs(file)
	check(err)
	defer file.Close()

	sort.Ints(m)
	ret, err := getMissing(m)
	check(err)

	fmt.Println(ret)
}
