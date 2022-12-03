use std::io;
use std::io::BufRead;

/*
A Rock
B Paper
C Scissors

X loose
Y tie
Z win
*/

fn main() {
    let input: Vec<Vec<char>> = io::stdin()
        .lock()
        .lines()
        .map(|l| {
            l.unwrap()
                .split_whitespace()
                .map(|c| c.to_string().chars().next().unwrap())
                .collect()
        })
        .collect();

    let result: u64 = input.iter().map(|line| grade_game(line[0], line[1]).unwrap()).sum();
    println!("{result}")
}

fn hand_value(c: char) -> Result<u64, String> {
    match c {
        'X' => Ok(1), // Rock
        'Y' => Ok(2), // Paper
        'Z' => Ok(3), // Scissors
        _ => Err("This hand doesn't exist".to_string())
    }
}

fn grade_game(opponent: char, outcome: char) -> Result<u64, String> {
    let rock = 'X';
    let paper = 'Y';
    let scissors = 'Z';

    match opponent {
        // Rock
        'A' => match outcome {
            'X' => hand_value(scissors), // loose
            'Y' => hand_value(rock).map(|v| v+3), // tie
            'Z' => hand_value(paper).map(|v| v+6), // win
            _ => Err("Your hand doesn't exist".to_string())
        },
        // Paper
        'B' => match outcome {
            'X' => hand_value(rock), // loose
            'Y' => hand_value(paper).map(|v| v+3), // tie
            'Z' => hand_value(scissors).map(|v| v+6), // win
            _ => Err("Your hand doesn't exist".to_string())
        },
        // Scissors
        'C' => match outcome {
            'X' => hand_value(paper), // loose
            'Y' => hand_value(scissors).map(|v| v+3), // tie
            'Z' => hand_value(rock).map(|v| v+6), // win
            _ => Err("Your hand doesn't exist".to_string())
        },
        _ => Err("Opponent's hand doesn't exist".to_string())
    }
}
