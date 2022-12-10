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

impl Clone for File {
    fn clone(&self) -> Self {
        File::new(&self.name, self.size)
    }
}

#[derive(Debug)]
struct Directory {
    name: String,
    files: Vec<File>,
    directories: Vec<Directory>,
}

impl Clone for Directory {
    fn clone(&self) -> Self {
        Directory {
            name: self.name.clone(),
            files: self.files.clone(),
            directories: self.directories.clone()
        }
    }
}

impl Directory {
    fn new(name: &str) -> Directory {
        Directory {
            name: name.to_owned(),
            files: Vec::new(),
            directories: Vec::new(),
        }
    }

    fn add(&mut self, inode: &Inode) {
        match inode {
            Inode::File(f) => self.files.push(f.clone()),
            Inode::Dir(d) => self.directories.push(d.clone()),
        }
    }

    fn apply_ops(mut self, ops: &mut dyn Iterator<Item = Operation>) -> Self {
        while let Some(op) = ops.next() {
            match op {
                Operation::Cd(dir) => match dir.as_str() {
                    "/" => (),
                    ".." => break,
                    name => self.directories.push(Directory::new(name).apply_ops(ops)),
                },
                Operation::Ls(inodes) => inodes.iter().for_each(|i| self.add(i)),
            }
        }
        self
    }

    fn dir_sizes(&self) -> Vec<u64> {
        let mut subdirs = self.directories.iter().flat_map(|dir| dir.dir_sizes()).collect::<Vec<_>>();
        let this_dir = self.size();
        subdirs.push(this_dir);
        subdirs
    }

}

trait Size {
    fn size(&self) -> u64;
}

#[derive(Debug,Clone)]
enum Inode {
    Dir(Directory),
    File(File),
}

impl Size for Directory {
    fn size(&self) -> u64 {
        self.files.iter().map(|f| f.size()).sum::<u64>()
        +
        self.directories.iter().map(|f| f.size()).sum::<u64>()
    }
}

impl Size for File {
    fn size(&self) -> u64 {
        self.size
    }
}

#[derive(Debug)]
enum Operation {
    Cd(String),
    Ls(Vec<Inode>),
}

fn main() {
    let input = io::stdin()
        .lock()
        .lines()
        .map(|l| l.unwrap())
        .filter(|l| !l.eq("$ ls"));

    let mut ops: Vec<Operation> = Vec::new();
    let mut ls: Vec<Inode> = Vec::new();
    for line in input {
        let split = line.split_whitespace().collect::<Vec<_>>();
        match split[0] {
            "$" => {
                if !ls.is_empty() {
                    ops.push(Operation::Ls(ls));
                    ls = Vec::new();
                }
                ops.push(Operation::Cd(split[2].to_owned()))
            },
            "dir" => ls.push(Inode::Dir(Directory::new(split[1]))),
            _ => {
                let size = split[0].parse().unwrap();
                ls.push(Inode::File(File::new(split[1], size)))
            },
        }
    }
    if !ls.is_empty() {
        ops.push(Operation::Ls(ls));
    }

    let mut filesystem = Directory::new("/");
    filesystem = filesystem.apply_ops(&mut ops.into_iter());
    let sizes = filesystem.dir_sizes();

    println!("{}", sizes.iter().filter(|&&s| s <= 100_000).sum::<u64>())
}
