package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type numRange struct {
	min, max int // both inclusive
}

type game struct {
	ticket  []int
	rules   []numRange
	tickets [][]int
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// split function that splits on empty lines. For use with scanner.Split()
func newlineSplit(data []byte, atEOF bool) (advance int, token []byte, err error) {
	// Return nothing if at end of file and no data passed
	if atEOF && len(data) == 0 {
		return 0, nil, nil
	}
	// Find the index of the two newlines
	if i := strings.Index(string(data), "\n\n"); i >= 0 {
		return i + 1, data[0:i], nil
	}
	// If at end of file with data return the data
	if atEOF {
		return len(data), data, nil
	}
	return
}

func readRules(str string) ([]numRange, error) {
	var ret []numRange
	r := regexp.MustCompile(`\d+-\d+`)
	tmp := r.FindAllString(str, -1)
	if tmp == nil {
		return ret, errors.New("couldn't match any range")
	}
	for _, v := range tmp {
		var nr numRange
		var err error
		bounds := strings.Split(v, "-")
		nr.min, err = strconv.Atoi(bounds[0])
		if err != nil {
			return ret, err
		}
		nr.max, err = strconv.Atoi(bounds[1])
		if err != nil {
			return ret, err
		}
		ret = append(ret, nr)
	}
	return ret, nil
}

func readTicket(str string) (ret []int, err error) {
	for _, v := range strings.Split(str, ",") {
		var num int
		num, err = strconv.Atoi(v)
		if err != nil {
			return ret, err
		}
		ret = append(ret, num)
	}
	return ret, nil
}

func readQuestionaires(r io.Reader) (ret game, err error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(newlineSplit)
	var text []string
	for scanner.Scan() {
		text = append(text, strings.TrimSpace(scanner.Text()))
	}
	if len(text) != 3 {
		return ret, fmt.Errorf("input must have 3 sections, has %d", len(text))
	}
	// read rules:
	ret.rules, err = readRules(text[0])
	if err != nil {
		return ret, err
	}
	// read own ticket:
	ret.ticket, err = readTicket(strings.Split(text[1], "\n")[1])
	if err != nil {
		return ret, err
	}
	// read other tickets:
	tickets := strings.Split(text[2], "\n")[1:]
	for _, v := range tickets {
		nums, err := readTicket(v)
		if err != nil {
			return ret, err
		}
		ret.tickets = append(ret.tickets, nums)
	}

	return ret, scanner.Err()
}

func inRange(n int, ranges ...numRange) bool {
	cum := false
	for _, v := range ranges {
		cum = cum || (v.min <= n && n <= v.max)
	}
	return cum
}

func (g *game) solve() (sum int) {
	for _, ticket := range g.tickets {
		for _, v := range ticket {
			if !inRange(v, g.rules...) {
				sum += v
			}
		}
	}
	return sum
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readQuestionaires(file)
	check(err)
	defer file.Close()

	fmt.Println(m.solve())
}
