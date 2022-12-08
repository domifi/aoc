use std::cmp::Ordering;
use std::io;
use std::io::BufRead;

// m[y][x] is x to the right and y down
type Map = Vec<Vec<u32>>;

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .map(|l| l.unwrap().chars().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let map: Map = input.iter()
        .map(|l| l.iter()
            .map(|c| c
                .to_digit(10).unwrap())
            .collect())
        .collect();

    let scores: Vec<Vec<_>> = map.iter()
        .zip(0..)
        .map(|(line,y)| line.iter()
            .zip(0..)
            .map(|(_, x)| scenic_score(&map, x, y).unwrap())
            .collect())
        .collect();

    println!("{}", scores.iter().flatten().max().unwrap())
}

enum Direction {
    North,
    East,
    South,
    West
}

fn get_line(m: &Map, x: usize, y: usize, dir: &Direction) -> Result<Vec<u32>, String> {
    let msg = "Couldn't find tree in map";
    m.get(y).expect(msg).get(x).expect(msg);
    match dir {
        Direction::East => Ok(m[y].iter().skip(x+1).cloned().collect()),
        Direction::West => Ok(m[y].iter().take(x).rev().cloned().collect()),
        Direction::South => Ok(m.iter().skip(y+1).map(|line| line[x]).collect()),
        Direction::North => Ok(m.iter().take(y).map(|line| line[x]).rev().collect()),
    }
}

fn scenic_score(m: &Map, x: usize, y: usize) -> Result<u64, String> {
    static DIRECTIONS: [Direction; 4] = [
        Direction::North,
        Direction::East,
        Direction::South,
        Direction::West
    ];
    let height = m[y][x];
    let mut score = 1;
    for dir in DIRECTIONS.iter(){
        let mut visible = 0;
        for tree in get_line(m, x, y, dir).unwrap() {
            match tree.cmp(&height) {
                Ordering::Less => visible += 1,
                _ => {visible += 1; break},
            }
        }
        score *= visible;
    }
    Ok(score)
}
