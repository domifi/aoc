use std::io;
use std::io::BufRead;
use std::collections::HashSet;

type Coord = (i64, i64);

#[derive(Debug, Copy, Clone)]
enum Dir {
    Left,
    Right,
    Up,
    Down,
}

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .flat_map(|l| {
            let l1 = l.unwrap();
            let line = l1.split_whitespace().collect::<Vec<_>>();
            let steps = line[1].parse().unwrap();
            let dir = match line[0] {
                "L" => Dir::Left,
                "R" => Dir::Right,
                "U" => Dir::Up,
                "D" => Dir::Down,
                _ => panic!("this case will not be reached"),
            };
            std::iter::repeat(dir).take(steps)
        });

    let mut head: (i64,i64) = (0,0);
    let mut tail: (i64,i64) = (0,0);
    let mut visited = HashSet::new();
    visited.insert(tail);
    for dir in input {
        (head, tail) = motion_with_tail(dir, head, tail);
        visited.insert(tail);
    }

    println!("{}", visited.len())
}

// "natural" coordinates. +y is up and +x is right
fn motion(dir: Dir, coord: Coord) -> Coord {
    let (x,y) = coord;
    match dir {
        Dir::Up => (x,y+1),
        Dir::Down => (x,y-1),
        Dir::Right => (x+1,y),
        Dir::Left => (x-1,y),
    }
}

// return: (head, tail)
fn motion_with_tail(dir: Dir, head: Coord, tail: Coord) -> (Coord, Coord) {
    let new_head = motion(dir, head);
    if distance(tail, new_head) > 1 {
        let new_tail = match dir {
            Dir::Up => (new_head.0, new_head.1-1),
            Dir::Down => (new_head.0, new_head.1+1),
            Dir::Right => (new_head.0-1, new_head.1),
            Dir::Left => (new_head.0+1, new_head.1),
        };
        return (new_head, new_tail);
    }
    (new_head, tail)
}

fn distance(a: Coord, b: Coord) -> u64 {
    let dx = a.0 - b.0;
    let dy = a.1 - b.1;
    std::cmp::max(dx.abs(), dy.abs()) as u64
}
