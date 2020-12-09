package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"
)

type questionaire [26]bool

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

// marks that a question has been answered with yes
// returns whether it has already been answered
func (q *questionaire) addQuestion(char byte) bool {
	id := (byte(char) - byte('a')) % 26
	ret := !(*q)[id]
	(*q)[id] = true
	return ret
}

func readQuestionaire(s string) questionaire {
	var ret questionaire
	for _, v := range []byte(s) {
		ret.addQuestion(v)
	}
	return ret
}

func readQuestionaires(r io.Reader) ([]questionaire, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(newlineSplit)
	var result []questionaire
	for scanner.Scan() {
		text := strings.ReplaceAll(scanner.Text(), "\n", "")
		result = append(result, readQuestionaire(text))
	}

	return result, scanner.Err()
}

func boolToInt(b bool) int {
	if b {
		return 1
	}
	return 0
}

func answers(slice []questionaire) int {
	sum := 0
	for _, v := range slice {
		for _, vv := range v {
			sum += boolToInt(vv)
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

	fmt.Println(answers(m))
}
