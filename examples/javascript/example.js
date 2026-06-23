// JavaScript playground — prettier formatting + treesitter highlighting.
// NOTE: no JS LSP is configured (only formatting + treesitter). Use `<leader>ff`
// or `:w` to format. Install ts_ls / eslint via `:Mason` for full LSP.
class User {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }

  greet() {
    return `Hello, ${this.name}! You are ${this.age}.`;
  }
}

const user = new User("Luke", 30);
console.log(user.greet());
