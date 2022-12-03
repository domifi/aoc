use std::io;
use std::io::BufRead;

fn main() {
    // let input : Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap().parse::<u32>().unwrap()).collect();
    let input : Vec<_> = io::stdin().lock().lines().map(|l| l.unwrap()).collect();
    let mut max = 0;
    let mut accumulator = 0;

    for line in input.iter() {
        if line.len() == 0 {
            if accumulator > max {
                max = accumulator;
            }
            accumulator = 0;
        } else {
            accumulator += line.parse::<i32>().unwrap();
        }
    }
    println!("{max}")
}
