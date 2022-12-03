use std::io;
use std::io::BufRead;

fn main() {
    let input: Vec<_> = io::stdin().lock()
        .lines()
        .map(|l| l.unwrap().parse().ok())
        .collect();
    let backpacks: Vec<Vec<u64>> = input
        .split(|l| l.is_none())
        .map(|group| group
            .iter()
            .map(|l| l.unwrap())
            .collect()
        ).collect();

    let sums: Vec<u64> = backpacks.iter().map(|b| b.iter().sum()).collect();
    //println!("{:?}", sums);
    //println!("{:?}", max_k(&sums, 3).unwrap());
    println!("{:?}", max_k(&sums, 3).unwrap().iter().sum::<u64>())
}

fn max_k(values: &Vec<u64>, k: usize) -> Result<Vec<u64>, String> {
    if values.len() < k {
        return Err("Not enough elements in vector".to_string())
    }
    let mut ret = vec![values[0], values[1], values[2]];
    ret.sort();
    for candidate in &values[k..] {
        let smallest_max = ret.first().unwrap();
        if candidate > smallest_max {
            ret[0] = *candidate;
            ret.sort();
        }
    }
    Ok(ret)
}
