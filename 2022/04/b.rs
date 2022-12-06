use std::io;
use std::io::BufRead;


#[derive(Debug)]
struct Section (u64, u64);

fn main() {
    let pairs: Vec<_> = io::stdin()
        .lock()
        .lines()
        .map(|l| line2pair(l.unwrap()))
        .collect();

    let sum = pairs
        .iter()
        .map(|pair| overlap(&pair.0, &pair.1))
        .filter(|b| *b)
        .count();

    println!("{}", sum)
}

fn line2pair(l: String) -> (Section, Section) {
    let numbers: Vec<u64> = l.split(&[',', '-'][..]).map(|e| e.parse().unwrap()).collect();
    (Section(numbers[0], numbers[1]), Section(numbers[2], numbers[3]))
}

fn overlap(left: &Section, right: &Section) -> bool {
    left.0 <= right.0 && right.0 <= left.1
    ||
    right.0 <= left.0 && left.0 <= right.1
}
