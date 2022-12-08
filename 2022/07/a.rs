use std::io;
use std::io::BufRead;

#[derive(Debug)]
struct File<'a> {
    name: &'a str,
    size: u64,
}

#[derive(Debug)]
struct Directory<'a> {
    name: &'a str,
    contens: &'a Vec<Result<File<'a>, Directory<'a>>>,
}

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .map(|l| l.unwrap());

    let marker = input
        .as_bytes()
        .windows(14)
        .zip(14..)
        .find(|sequence| !has_dups(sequence.0))
        .expect("no subsequence without duplicates found");

    println!("{:?}", marker.1)
}
