package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

type password struct {
	min, max int
	c        byte
	word     string
}

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

// example string: "1-3 a: abcde"
func readPassword(s string) (password, error) {
	var ret password
	emptyPassword := password{0, 0, '\x00', ""}

	// find minimum and save it:
	slice := strings.Split(s, "-")
	if len(slice) != 2 {
		return emptyPassword, fmt.Errorf("Couldn't parse min of String: %s", s)
	}
	var err error
	ret.min, err = strconv.Atoi(slice[0])
	check(err)

	// find maximum and save it:
	slice = strings.Fields(slice[1])
	if len(slice) != 3 {
		return emptyPassword, fmt.Errorf("Couldn't parse max of String: %s", s)
	}
	ret.max, err = strconv.Atoi(slice[0])
	check(err)

	// find character and save it:

}

func readPasswords(r io.Reader) ([]password, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanWords)
	var result []password
	for scanner.Scan() {
		x, err := readPassword(scanner.Text())
		check(err)

		result = append(result, x)
	}

	return result, scanner.Err()
}

func findSum(ints []int, sum int) (int, int, int, error) {
	for i, vi := range ints {
		ints2 := ints[i+1:]
		for j, vj := range ints2 {
			for _, vk := range ints2[j+1:] {
				if vi+vj+vk == 2020 {
					return vi, vj, vk, nil
				}
			}

		}
	}
	fmt.Println("I pooped my pants!")
	return 0, 0, 0, errors.New("")
}

func main() {
	file, err := os.Open("../input")
	check(err)
	ints, err := readInts(file)
	check(err)
	defer file.Close()

	a, b, c, err := findSum(ints, 2020)
	check(err)

	fmt.Println(a * b * c)
}
