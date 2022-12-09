use std::io;
use std::io::BufRead;

#[derive(Debug)]
struct File {
    name: String,
    size: u64,
}

impl File {
    fn new(name: &str, size: u64) -> File {
        File {name: name.to_owned(), size}
    }
}

#[derive(Debug)]
struct Directory<'a> {
    name: &'a str,
    files: Vec<File>,
    directories: Vec<Directory<'a>>,
}

impl Directory<'_> {
    fn new(name: &str) -> Directory {
        Directory {
            name,
            files: Vec::new(),
            directories: Vec::new(),
        }
    }

}

trait Inode {
    fn size(&self) -> u64;
}

impl Inode for Directory<'_> {
    fn size(&self) -> u64 {
        self.files.iter().map(|f| f.size()).sum::<u64>()
        +
        self.directories.iter().map(|f| f.size()).sum::<u64>()
    }
}

impl Inode for File {
    fn size(&self) -> u64 {
        self.size
    }
}

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .map(|l| l.unwrap());

    let mut filesystem = Directory::new("/");

    // for line in input {
    //     if line.starts_with("$ cd") {
    //         let name = line.split_whitespace().last().unwrap();
    //         if name == "/" {
    //             continue;
    //         }
    //     }
    // }


    println!("{:?}", input.collect::<Vec<_>>())
}
