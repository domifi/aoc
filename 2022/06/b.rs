use std::io;
use std::io::BufRead;

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .next().unwrap().unwrap();

    let marker = input
        .as_bytes()
        .windows(14)
        .zip(14..)
        .find(|sequence| !has_dups(sequence.0))
        .expect("no subsequence without duplicates found");

    println!("{:?}", marker.1)
}

fn has_dups(s: &[u8]) -> bool {
    s.iter().any(|c| 1 <
        s.iter()
        .filter(|e| e == &c)
        .count())
}
