use std::io;
use std::io::BufRead;

#[derive(Debug)]
struct Monkey {
    items: Vec<u64>,
    op: fn(u64) -> u64,
    test: fn(u64) -> bool,
    target_true: usize,
    target_false: usize,
}

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .;

    println!("{:#?}", input.collect::<Vec<_>>());
}
