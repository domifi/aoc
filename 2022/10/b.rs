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
    // (Sprite position, during cycle)
    let sprite_positions = std::iter::once(1).chain(
        input.map(|op| {
        match op {
            Op::Noop => register,
            Op::Addx(i) => { register += i; register },
        }
    }));

    let mut crt_pos = 0;
    for sprite_pos in sprite_positions {
        if crt_pos >= 40 {
            crt_pos = 0;
            println!();
        }
        if (crt_pos - sprite_pos).abs() <= 1 {
            print!("█");
        } else {
            print!(" ");
        }
        crt_pos += 1;
    }
    println!();
}
