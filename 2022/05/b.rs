use std::fmt::Display;
use std::io;
use std::io::BufRead;
use std::iter;

#[derive(Debug)]
struct Instruction {
    number: usize,
    from: usize,
    to: usize,
}


impl Display for Instruction {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "move {} from {} to {}", self.number, self.from, self.to)
    }
}

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

fn parse_map(map: &[String]) -> Result<Vec<Vec<char>>, String> {
    let message = "Couldn't parse starting stack configurations";
    let num_stacks = map
        .last().expect(message)
        .split_whitespace()
        .last().expect(message)
        .parse().expect(message);

    let mut stacks: Vec<Vec<char>> = iter::repeat_with(Vec::new).take(num_stacks).collect();


    for line in map.iter().rev() {
        if line.contains('[') {
            let chars = line.char_indices().collect::<Vec<_>>();

            for (i, c) in chars {
                if c.is_alphabetic() {
                    stacks[(i-1)/4].push(c);
                }
            }
        }
    }
    Ok(stacks)
}

fn parse_instruction(s: &str) -> Result<Instruction, String> {
    let nums: Vec<usize> = s
        .split(|c: char| !c.is_numeric())
        .filter(|e| !e.is_empty())
        .map(|n| n.parse().unwrap())
        .collect();
    Ok(Instruction {
        number: nums[0],
        from: nums[1],
        to: nums[2]
    })
}
