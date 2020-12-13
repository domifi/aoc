package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
)

type xmas struct {
	preamble int
	text     []int
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func readXmas(r io.Reader, pre int) (xmas, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	ret := xmas{preamble: pre}
	for scanner.Scan() {
		i, err := strconv.Atoi(scanner.Text())
		if err != nil {
			return ret, err
		}
		ret.text = append(ret.text, i)
	}
	return ret, scanner.Err()
}

func validateSlice(slice []int) bool {
	sum := slice[len(slice)-1]
	summands := slice[:len(slice)-1]

	for i, a := range summands {
		for _, b := range summands[i+1:] {
			if a+b == sum {
				return true
			}
		}
	}
	return false
}

func (x *xmas) validate() int {
	pre := x.preamble
	for i := pre; i <= len(x.text); i++ {
		if !validateSlice(x.text[i-pre : i+1]) {
			return x.text[i]
		}
	}
	return 0
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readXmas(file, 25)
	check(err)
	defer file.Close()

	fmt.Println(m.validate())
}
