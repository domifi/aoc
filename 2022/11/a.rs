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
        .collect::<Vec<_>>();

    let chunks = input
        .split(|l| l.is_empty());

    println!("{:#?}", chunks);
}

fn parse_monkey(monkey: &Vec<String>) -> Result<Monkey, String> {

    let items: Vec<u64> = monkey[1]
        .split(&[' ', ','][..])
        .filter(|e| !e.is_empty())
        .skip(2)
        .map(|e| e.parse().unwrap())
        .collect();

    let test_num: u64 = monkey[3].split_whitespace().last().unwrap().parse().unwrap();
    let test = |x: u64| (x % test_num) == 0;
    let target_true: usize = monkey[4].split_whitespace().last().unwrap().parse().unwrap();
    let target_false: usize = monkey[5].split_whitespace().last().unwrap().parse().unwrap();

    // op_tokens = ["old", "*", "13"]
    let op_tokens = monkey[2].split_whitespace().skip(3).collect::<Vec<_>>();
    let op1: fn(u64,u64) -> u64 = match op_tokens[1] {
        "+" => |x,y| x+y,
        _ => |x,y| x*y
    };
    let op: Box<dyn Fn()> = match (op_tokens[0], op_tokens[1]) {
        ("old", "old") => Box(|x| op1(x,x)),
        ("old", a) => |x| op1(a.parse().unwrap(), x),
        (a, "old") => |x| op1(a.parse().unwrap(), x),
        (a,b) => |_| op1(a.parse().unwrap(), b.parse().unwrap())
    }

    Err("foo".to_string())
}
