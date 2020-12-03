package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
	"strconv"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// ReadInts reads whitespace-separated ints from r. If there's an error, it
// returns the ints successfully read so far as well as the error value.
func readInts(r io.Reader) ([]int, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanWords)
	var result []int
	for scanner.Scan() {
		x, err := strconv.Atoi(scanner.Text())
		if err != nil {
			return result, err
		}
		result = append(result, x)
	}
	return result, scanner.Err()
}

func findSum(ints []int, sum int) (int, int, error) {
	for i, vi := range ints {
		for _, vj := range ints[i+1:] {
			if vi+vj == 2020 {
				return vi, vj, nil
			}
		}
	}
	fmt.Println("I pooped my pants!")
	return 0, 0, errors.New("")
}

func main() {
	file, err := os.Open("input")
	check(err)
	ints, err := readInts(file)
	check(err)
	defer file.Close()

	a, b, err := findSum(ints, 2020)
	check(err)

	fmt.Println(a * b)
}
