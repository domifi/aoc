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

    let vis_map: Vec<Vec<bool>> = map.iter()
        .zip(0..)
        .map(|(line,y)| line.iter()
            .zip(0..)
            .map(|(_, x)| visible(&map, x, y).unwrap())
            .collect())
        .collect();

    println!("{:?}", vis_map.iter().flatten().filter(|&&e| e).count())
}

// m[y][x] is x to the right and y down
fn visible(m: &Map, x: usize, y: usize) -> Result<bool, String> {
    match (x, y) {
        (_, 0) => Ok(true),
        (0, _) => Ok(true),
        (x, _) if x == m[0].len()-1 => Ok(true),
        (_, y) if y == m.len()-1 => Ok(true),
        (x,y) => Ok({
            let height = m[y][x];
            static DIRECTIONS: [Direction; 4] = [
                Direction::North,
                Direction::East,
                Direction::South,
                Direction::West
            ];
            DIRECTIONS.iter().map(|dir|
                get_line_max(m, x, y, dir).unwrap())
            .any(|e| e < height)
        }),
    }
}

enum Direction {
    North,
    East,
    South,
    West
}

fn get_line_max(m: &Map, x: usize, y: usize, dir: &Direction) -> Result<u32, String> {
    let msg = "Couldn't find tree in map";
    m.get(y).expect(msg).get(x).expect(msg);
    match dir {
        Direction::East => Ok(*m[y].iter().skip(x+1).max().unwrap()),
        Direction::West => Ok(*m[y].iter().take(x).max().unwrap()),
        Direction::South => Ok(m.iter().skip(y+1).map(|line| line[x]).max().unwrap()),
        Direction::North => Ok(m.iter().take(y).map(|line| line[x]).max().unwrap()),
    }
}
