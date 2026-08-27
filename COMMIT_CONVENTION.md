# Commit Message Convention

Conventional Commits, wrapped 50/72. The authoritative version of this
rule lives in `pi/skills/git-commit-messages/SKILL.md`, which is linked
into `~/.pi/agent/skills/` so agents pick it up automatically.

## Format

```
<type>(<optional scope>): <subject>

<body wrapped at 72 columns>

<optional footers>
```

## Rules

- Subject: 50 characters ideal, 72 absolute maximum.
- Body: every line wrapped at 72 columns.
- Blank line between subject and body.
- Imperative mood, lowercase after the colon, no trailing period.
- Body explains why, not a retelling of the diff.

## Types

`feat`, `fix`, `perf`, `refactor`, `docs`, `test`, `build`, `ci`,
`chore`, `revert`. Scope is optional: `feat(herdr):`, `fix(nvim):`.

Breaking changes take a `!` before the colon and a `BREAKING CHANGE:`
footer.

## Example

```
feat(hypr): assign apps to fixed workspaces

Window placement was left to focus order, so the same app landed on a
different workspace every session and muscle memory never formed.

Pin Firefox, the terminal, Chrome, Slack, Cursor, and 1Password to
named workspaces via Hyprland window rules.
```

## Checking a message

```bash
git log -1 --format=%B | awk 'length > 72 {print length": "$0}'
```

Silence means it passes.
