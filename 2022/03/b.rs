use std::io;
use std::io::BufRead;

fn main() {
    let input: Vec<String> = io::stdin()
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .collect();

    let groups = input
        .chunks_exact(3)
        .map(|g| commonalities(&g[0], &g[1], &g[2]).unwrap())
        .collect::<Vec<_>>();

    println!("{:?}", groups.iter().sum::<u64>())
}

fn commonalities(s1: &str, s2: &str, s3: &str) -> Result<u64, String> {
    for c in s1.chars() {
        if s2.contains(c) && s3.contains(c) {
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
