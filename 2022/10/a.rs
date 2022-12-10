use std::io;
use std::io::BufRead;

#[derive(Debug, Copy, Clone)]
enum Op {
    Noop,
    Addx(i64),
}

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .flat_map(|l| {
            let l1 = l.unwrap();
            let line = l1.split_whitespace().collect::<Vec<_>>();
            match line[0] {
                "noop" => vec![Op::Noop],
                _ => vec![Op::Noop, Op::Addx(line[1].parse().unwrap())]
            }
        });

    let mut register: i64 = 1;
    let mut states = input.map(|op| {
        match op {
            Op::Noop => register,
            Op::Addx(i) => { register += i; register },
        }
    }).zip(2..);

    let mut result = states.nth(20-2).unwrap().0 * 20;
    while let Some((value, index)) = states.nth(40-1) {
        result += value * index;
    }

    println!("{}", result)
}
