package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"
)

type questionaire [26]byte

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

// increments the corresponding counter in q
func (q *questionaire) addQuestion(char byte) {
	id := (byte(char) - byte('a')) % 26
	(*q)[id]++
}

// converts a string (e.g. "abx") into a questionaire
func readQuestionaire(s string) questionaire {
	var ret questionaire
	for _, v := range []byte(s) {
		ret.addQuestion(v)
	}
	return ret
}

func readQuestionaires(r io.Reader) (int, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(newlineSplit)
	sum := 0
	for scanner.Scan() {
		text := strings.Split(scanner.Text(), "\n")
		text = removeAll(text, "")

		sum += everyone(text)
	}

	return sum, scanner.Err()
}

func removeAll(str []string, s string) []string {
	ret := make([]string, len(s))
	for _, v := range str {
		if v != s {
			ret = append(ret, v)
		}
	}
	return ret
}

// returns sum of questions in q that have been answered exactly n times with 'yes'
func match(q questionaire, n int) int {
	sum := 0
	for _, v := range q {
		if v == byte(n) {
			sum++
		}
	}
	return sum
}

// returns sum of questions that have been answered with 'yes' by everyone
// takes slice of all strings of a group
func everyone(slice []string) int {
	n := len(slice)
	var group questionaire
	for _, singleV := range slice {
		for _, char := range []byte(singleV) {
			group.addQuestion(char)
		}
	}
	return match(group, n)
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readQuestionaires(file)
	check(err)
	defer file.Close()

	fmt.Println(m)
}
