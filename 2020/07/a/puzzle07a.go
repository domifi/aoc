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

func contains(slice []bag, elem bag) bool {
	for _, v := range slice {
		if v == elem {
			return true
		}
	}
	return false
}

func containsAll(slice []bag, elems ...bag) bool {
	for _, elem := range elems {
		if !contains(slice, elem) {
			return false
		}
	}
	return true
}

func bagEq(a, b []bag) bool {
	if len(a) != len(b) {
		return false
	}
	return containsAll(a, b...) && containsAll(b, a...)
}

// append without duplicates
func insert(slice []bag, elems ...bag) []bag {
	var ret []bag
	ret = append(ret, slice...)
	for _, elem := range elems {
		if !contains(slice, elem) {
			ret = append(ret, elem)
		}
	}
	return ret

}

func (r *rules) superStep(sub []bag) []bag {
	var ret []bag
	for _, subBag := range sub {
		// look for bags that contain subBag:
		for superBag, rules := range *r {
			if rules[subBag] > 0 {
				ret = insert(ret, superBag)
			}
		}
	}
	return ret
}

// list of super-bags that (transitively) contain the sub-bag
func (r *rules) super(sub bag) []bag {
	prev := []bag{}
	current := r.superStep([]bag{sub})
	for !bagEq(prev, current) {
		prev = current
		current = insert(current, r.superStep(current)...)
	}
	return current
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readRules(file)
	check(err)
	defer file.Close()

	fmt.Println(len(m.super(bag("shiny gold"))))
}
