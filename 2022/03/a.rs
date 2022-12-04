use std::io;
use std::io::BufRead;

fn main() {
    let input: Vec<(String, String)> = io::stdin()
        .lock()
        .lines()
        .map(|l| half(&l.unwrap()))
        .collect();

    let sum = input.iter()
        .map(|pair| commonalities(&pair.0, &pair.1).unwrap())
        .sum::<u64>();

    println!("{sum}")
}

fn half(s: &String) -> (String, String) {
    let middle = s.len() / 2;
    (s[0..middle].to_string(), s[middle..].to_string())
}

fn commonalities(s1: &str, s2: &str) -> Result<u64, String> {
    for c in s1.chars() {
        if s2.contains(c) {
            return char_to_priority(c)
        }
    }
    Err("No common items".to_string())
}

fn char_to_priority(c: char) -> Result<u64, String> {
    let ascii = c as u64;
    if ascii >= 'a' as u64 && ascii <= 'z' as u64 {
        Ok(ascii - ('a' as u64) + 1)
    } else if ascii >= 'A' as u64 && ascii <= 'Z' as u64 {
        Ok(ascii - ('A' as u64) + 27)
    } else {
        Err("Character out of range".to_string())
    }
}
