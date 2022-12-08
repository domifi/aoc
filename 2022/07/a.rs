use std::io;
use std::io::BufRead;

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .collect::<Vec<_>>();

    let mut input2 = input.split(|l| l.is_empty());

    let mut stacks =
        parse_map(input2.next().expect("Failed finding Map")).unwrap();

    let instructions = input2.
        next().expect("Failed finding Instructions").
        iter().map(|i| parse_instruction(i).unwrap());

    for ins in instructions {
        let source_len = stacks[ins.from-1].len();
        let mut tmp = stacks[ins.from-1].split_off(source_len - ins.number);

        stacks[ins.to-1].append(&mut tmp);
    }

    let top: String = stacks.iter().map(|stack| stack.last().unwrap()).collect();

    println!("{}", top)
}
