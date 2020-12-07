package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"regexp"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// func readMap(r io.Reader) (toboganMap, error) {
// 	scanner := bufio.NewScanner(r)
// 	scanner.Split(bufio.ScanLines)
// 	var result toboganMap
// 	for scanner.Scan() {
// 		result = append(result, []byte(scanner.Text()))
// 	}

// 	return result, scanner.Err()
// }

func passportSplit(data []byte, atEOF bool) (advance int, token []byte, err error) {

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

func readPassports(r io.Reader) ([]string, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(passportSplit)
	var result []string
	for scanner.Scan() {
		result = append(result, scanner.Text())
	}

	// remove uneccessary newlines
	expr := regexp.MustCompile("\n")
	for i, v := range result {
		result[i] = expr.ReplaceAllLiteralString(v, "")
	}

	return result, scanner.Err()
}

func validateOne(s string) (bool, error) {
	// no support for lookaround in golangs standard regex library :( (O(n), though)
	//expr := "^(?=.*\bbyr\b)(?=.*\biyr\b)(?=.*\beyr\b)(?=.*\bhgt\b)(?=.*\bhcl\b)(?=.*\becl\b)(?=.*\bpid\b)(?=.*\bcid\b)?.*$"

	exprs := []string{
		"byr",
		"iyr",
		"eyr",
		"hgt",
		"hcl",
		"ecl",
		"pid"}
	for _, v := range exprs {
		match, err := regexp.MatchString(v, s)
		if err != nil {
			return false, err
		}
		if !match {
			return false, nil
		}
	}

	return true, nil
}

func validateAll(s []string) (int, error) {
	ret := 0
	for _, v := range s {
		ok, err := validateOne(v)
		if err != nil {
			return 0, err
		}
		if ok {
			ret++
		}
	}
	return ret, nil
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readPassports(file)
	check(err)
	defer file.Close()

	fmt.Println(validateAll(m))
}
