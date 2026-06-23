# Python playground — pylsp LSP (flake8 diagnostics), isort+black formatting.
# Try: `K` to hover on greet, `gd` to jump to a definition, `<leader>la` for
# code actions, `<leader>ff` to format. flake8 warnings show inline.
from dataclasses import dataclass


@dataclass
class User:
    name: str
    age: int

    def greet(self) -> str:
        return f"Hello, {self.name}! You are {self.age}."


def main() -> None:
    user = User(name="Luke", age=30)
    print(user.greet())


if __name__ == "__main__":
    main()
