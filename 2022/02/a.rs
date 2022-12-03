use std::io;
use std::io::BufRead;

/*
A X Rock
B Y Paper
C Z Scissors
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

fn grade_game(opponent: char, you: char) -> Result<u64, String> {
    match opponent {
        // Rock
        'A' => match you {
            'X' => hand_value(you).map(|v| v+3), // Rock
            'Y' => hand_value(you).map(|v| v+6), // Paper
            'Z' => hand_value(you), // Scissors
            _ => Err("Your hand doesn't exist".to_string())
        },
        // Paper
        'B' => match you {
            'X' => hand_value(you), // Rock
            'Y' => hand_value(you).map(|v| v+3), // Paper
            'Z' => hand_value(you).map(|v| v+6), // Scissors
            _ => Err("Your hand doesn't exist".to_string())
        },
        // Scissors
        'C' => match you {
            'X' => hand_value(you).map(|v| v+6), // Rock
            'Y' => hand_value(you), // Paper
            'Z' => hand_value(you).map(|v| v+3), // Scissors
            _ => Err("Your hand doesn't exist".to_string())
        },
        _ => Err("Opponents hand doesn't exist".to_string())
    }
}
