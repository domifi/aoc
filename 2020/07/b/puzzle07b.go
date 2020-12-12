package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

// just the colour of a bag, e.g. "light red"
type bag string

// key value pairs where key is a bag and the value is what it can contain.
// The value itself is a key value pair again where the key is the colour
// and the value the number of bags of this sort can be contained
type rules map[bag]map[bag]int

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func (r *rules) addRule(line string) error {
	line = strings.Replace(line, ".", "", 1)
	supKey := strings.Join(strings.SplitN(line, " ", 3)[:2], " ")
	if strings.Contains(line, "no other") {
		(*r)[bag(supKey)] = nil
		return nil
	}

	contains := strings.Split(strings.SplitN(line, " contain ", 2)[1], ", ")
	subMap := make(map[bag]int)
	for _, line := range contains {
		text := strings.Split(line, " ")
		num, err := strconv.Atoi(text[0])
		if err != nil {
			return err
		}
		subKey := bag(strings.Join(text[1:3], " "))
		subMap[subKey] = num
	}
	(*r)[bag(supKey)] = subMap
	return nil
}

func readRules(r io.Reader) (rules, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	ret := make(rules)
	for scanner.Scan() {
		err := ret.addRule(scanner.Text())
		if err != nil {
			return ret, err
		}
	}

	return ret, scanner.Err()
}

// not at all efficient. Maybe I'll revisit this later.
func (r *rules) capacity(b bag) int {
	sum := 0
	for k, v := range (*r)[b] {
		sum += v + v*r.capacity(k)
	}
	return sum
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readRules(file)
	check(err)
	defer file.Close()

	fmt.Println(m.capacity(bag("shiny gold")))
}
