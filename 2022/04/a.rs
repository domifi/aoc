use std::io;
use std::io::BufRead;


struct Section (u64, u64);

fn main() {
    let input: Vec<Vec<_>> = io::stdin()
        .lock()
        .lines()
        .map(|l|
            l.unwrap()
            .split(',')
            .map(|pair| pair.to_string())
            .collect())
        .collect();

    let pairs: Vec<(Section, Section)> = input
        .iter()
        .map(|pair| {
            let foo = pair.iter().map(|f| f.split('-'));
            //(foo.next().unwrap(), foo.next().unwrap())
        }).collect();

    println!("{:?}", input)
}
