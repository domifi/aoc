package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
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

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readSeatIDs(file)
	check(err)
	defer file.Close()

	fmt.Println(getMax(m))
}
