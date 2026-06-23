// Rust playground — rustfmt formatting + treesitter highlighting.
// NOTE: no Rust LSP (rust-analyzer) is configured, so `gd`/`K` won't work here.
// This exercises treesitter + `<leader>ff` formatting. Install rust-analyzer
// via `:Mason` if you want full LSP.
struct User {
    name: String,
    age: u32,
}

impl User {
    fn greet(&self) -> String {
        format!("Hello, {}! You are {}.", self.name, self.age)
    }
}

fn main() {
    let user = User {
        name: String::from("Luke"),
        age: 30,
    };
    println!("{}", user.greet());
}
