// Go playground — gopls LSP, goimports+gofumpt formatting, treesitter, DAP.
// Try: `gd` on Greet, `K` to hover, `<leader>la` code actions, `<leader>lr`
// to rename, `<leader>gt` to run tests, `<leader>ge` to add an if-err block.
// Save the file to auto-format (goimports will add/remove imports).
package main

import "fmt"

// User is a simple value type.
type User struct {
	Name string
	Age  int
}

// Greet returns a friendly greeting for the user.
func (u User) Greet() string {
	return fmt.Sprintf("Hello, %s! You are %d.", u.Name, u.Age)
}

func main() {
	u := User{Name: "Luke", Age: 30}
	fmt.Println(u.Greet())
}
