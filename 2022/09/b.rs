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

    let mut rope: Vec<Coord> = std::iter::repeat((0,0)).take(10).collect();
    let mut visited = HashSet::new();
    visited.insert(rope[9]);
    for dir in input {
        rope[0] = motion(dir, rope[0]);
        for i in 1..10 {
            rope[i] = move_up(rope[i-1], rope[i]);
        }
        visited.insert(rope[9]);
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

fn distance(a: Coord, b: Coord) -> u64 {
    let dx = a.0 - b.0;
    let dy = a.1 - b.1;
    std::cmp::max(dx.abs(), dy.abs()) as u64
}

// moves the tail up, if neccessary
fn move_up(head: Coord, tail: Coord) -> Coord {
    if distance(tail, head) <= 1 {
        return tail;
    }

    let (hx,hy) = head;
    let (tx, ty) = tail;

    // this is awful
    if hx == tx && hy > ty { // head is N
        (tx, ty+1)
    } else if hx == tx && hy < ty { // head is S
        (tx, ty-1)
    } else if hy == ty && hx < tx { // head is W
        (tx-1, ty)
    } else if hy == ty && hx > tx { // head is E
        (tx+1, ty)
    } else if hx > tx && hy > ty { // head is NE
        (tx+1, ty+1)
    } else if hx > tx && hy < ty { // head is SE
        (tx+1, ty-1)
    } else if hx < tx && hy > ty { // head is NW
        (tx-1, ty+1)
    } else { // head is SW
        (tx-1, ty-1)
    }
}
