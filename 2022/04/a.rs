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
        .map(|pair| contains(&pair.0, &pair.1) || contains(&pair.1, &pair.0))
        .filter(|b| *b)
        .count();

    println!("{}", sum)
}

fn line2pair(l: String) -> (Section, Section) {
    let numbers: Vec<u64> = l.split(&[',', '-'][..]).map(|e| e.parse().unwrap()).collect();
    (Section(numbers[0], numbers[1]), Section(numbers[2], numbers[3]))
}

fn contains(outer: &Section, inner: &Section) -> bool {
    outer.0 <= inner.0 && inner.1 <= outer.1
}
