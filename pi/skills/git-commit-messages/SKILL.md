---
name: git-commit-messages
description: Write git commit messages in this user's house style - Conventional Commits, 50/72 wrapping, explain why not what. Use whenever writing, amending, or reviewing a commit message, or when running git commit.
---

# Commit messages

Conventional Commits, wrapped 50/72. No exceptions, no house dialects.

## Format

```
<type>(<optional scope>): <subject>
<blank line>
<body wrapped at 72 columns>
<blank line>
<optional footers>
```

## Hard rules

1. **Subject: 50 characters ideal, 72 absolute maximum.** If you cannot fit
   it in 72, the commit is doing too much - split it.
2. **Body: wrap at 72 columns.** Every line. This is the one width used
   everywhere; do not widen it for tables, paths, or benchmark numbers.
3. Subject starts with a type from the list below, then `: `.
4. Subject is imperative mood, lowercase after the colon, no trailing period.
   "add cache", not "added cache" or "Adds cache.".
5. Blank line between subject and body. Always.
6. Body explains **why** and what changed at a conceptual level. The diff
   already shows what. Do not narrate the diff line by line.
7. Wrap `identifiers`, paths, and flags in backticks.
8. No emoji, no "Co-authored-by" or tool attribution unless asked.

## Types

| Type       | Use for                                                |
|------------|--------------------------------------------------------|
| `feat`     | new capability                                         |
| `fix`      | corrects broken behaviour                              |
| `perf`     | faster or lighter, same behaviour                      |
| `refactor` | restructure, no behaviour change                       |
| `docs`     | documentation only                                     |
| `test`     | tests only                                             |
| `build`    | build system, dependencies, packaging                  |
| `ci`       | CI configuration and pipelines                         |
| `chore`    | housekeeping that fits nothing above                   |
| `revert`   | reverts a previous commit                              |

Scope is optional and is a short noun for the area touched: `feat(herdr):`,
`fix(nvim):`, `perf(zsh):`. Use it when the repo has clear subsystems.

Breaking changes get a `!` before the colon and a `BREAKING CHANGE:` footer:

```
feat(install)!: drop Windows PowerShell 5.1 support
```

## Body shape

Two or three short paragraphs at most, separated by blank lines:

1. The problem or the reason this change exists.
2. What the change does about it.
3. Anything a future reader would trip over - a caveat, a follow-up, a
   deliberate omission.

Prefer prose. Use a bullet list only when the commit genuinely touches
several unrelated-but-atomic things, and keep bullets to one or two lines.

Numbers and measurements belong in the body when they justify the change,
but as prose, not tables:

> Split-to-first-prompt drops from 3.5s to 1.1s, most of it the shell
> switch rather than the profile tuning.

## Footers

Only when they carry information:

```
Refs: #123
Closes: #123
BREAKING CHANGE: config key `shell` renamed to `default_shell`
```

## Checklist before committing

- [ ] Subject <= 72 chars, ideally <= 50
- [ ] Valid type prefix, imperative mood, no trailing period
- [ ] Blank line after subject
- [ ] Every body line <= 72 chars
- [ ] Body says why, not a retelling of the diff
- [ ] Staged files match the message - one logical change per commit

## Verifying width

Check a message before or after committing:

```bash
git log -1 --format=%B | awk 'length > 72 {print length": "$0}'
```

Silence means it passes. To rewrap a message you are drafting:

```bash
fmt -w 72 <<'EOF'
...body text...
EOF
```

## Examples

Good:

```
perf(herdr): pin panes to x64 pwsh

New panes had no explicit shell and fell back to Windows PowerShell
5.1, which spends roughly two seconds running the stock `conda init`
hook before it ever draws a prompt.

Pin `default_shell` to PowerShell 7.6.5 and skip login-shell startup.
Split-to-first-prompt drops from 3.5s to 1.1s.

The path is absolute because `pwsh.exe` on PATH resolves to an older
x86 build; that can go once the stray MSI is uninstalled.
```

Bad, and why:

```
fix: pin herdr panes to x64 pwsh so splits open in ~1s
```
Subject is 54 chars - within the max, but it smuggles the benchmark
into the subject. That belongs in the body.

```
Update config
```
No type, not specific, no body.

```
feat: added new keybindings for the herdr multiplexer configuration file
```
Past tense, 71 chars of filler, and "configuration file" says nothing
the diff does not.
