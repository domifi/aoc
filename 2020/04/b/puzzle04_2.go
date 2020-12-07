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
		result[i] = expr.ReplaceAllLiteralString(v, " ")
	}

	return result, scanner.Err()
}

func validateOne(s string) (bool, error) {
	// no support for lookaround in golangs standard regex library :( (O(n), though)
	//expr := "^(?=.*\bbyr\b)(?=.*\biyr\b)(?=.*\beyr\b)(?=.*\bhgt\b)(?=.*\bhcl\b)(?=.*\becl\b)(?=.*\bpid\b)(?=.*\bcid\b)?.*$"

	exprs := []string{
		`byr:(19[2-9][0-9]|200[0-3])\b`,
		`iyr:20(1[0-9]|20)\b`,
		`eyr:20(2[0-9]|30)\b`,
		`hgt:1([5-8][0-9]|9[0-3])cm\b|(59|6[0-9]|7[0-6])in\b`,
		`hcl:#[0-9a-f]{6}\b`,
		`ecl:(amb|blu|brn|gry|grn|hzl|oth)\b`,
		`pid:[0-9]{9}\b`}
	for _, v := range exprs {
		match, err := regexp.MatchString(v, s)
		if err != nil {
			return false, err
		}
		if !match {
			// fmt.Printf("Couldn't match %s in %s", v, s)
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
