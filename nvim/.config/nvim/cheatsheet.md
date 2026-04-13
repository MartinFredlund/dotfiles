# Neovim Cheat Sheet

Leader key: `Space`

## Movement

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Left / down / up / right |
| `w` / `b` | Next / previous word |
| `e` | End of word |
| `0` / `$` | Start / end of line |
| `^` | First non-blank character |
| `gg` / `G` | Top / bottom of file |
| `{` / `}` | Previous / next paragraph |
| `Ctrl-d` | Scroll half-page down (centered) |
| `Ctrl-u` | Scroll half-page up (centered) |
| `%` | Jump to matching bracket |
| `5j` / `12k` | Jump 5 lines down / 12 up (relative numbers) |
| `n` / `N` | Next / prev search result (centered) |

## Modes

| Key | Action |
|-----|--------|
| `i` / `a` | Insert before / after cursor |
| `I` / `A` | Insert at start / end of line |
| `o` / `O` | New line below / above |
| `v` | Visual mode (select characters) |
| `V` | Visual line mode (select lines) |
| `Ctrl-v` | Visual block mode (select columns) |
| `Esc` | Back to normal mode + clear search highlights |

## Editing

| Key | Action |
|-----|--------|
| `dd` | Delete line |
| `yy` | Yank (copy) line |
| `p` / `P` | Paste after / before |
| `u` | Undo |
| `Ctrl-r` | Redo |
| `.` | Repeat last change |
| `ciw` | Change inner word |
| `ci"` | Change inside quotes |
| `diw` | Delete inner word |
| `>>` / `<<` | Indent / unindent line |
| `J` (visual) | Move selected lines down |
| `K` (visual) | Move selected lines up |
| `Space p` (visual) | Paste without overwriting register |

## Search & Replace

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `*` / `#` | Search word under cursor forward / backward |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all with confirmation |

## Windows & Splits

| Key | Action |
|-----|--------|
| `Ctrl-h/j/k/l` | Move focus between splits |
| `:vs` | Vertical split |
| `:sp` | Horizontal split |
| `Ctrl-w =` | Equalize split sizes |
| `Ctrl-w q` | Close split |

## Buffers

| Key | Action |
|-----|--------|
| `Space Space` | Find open buffers |
| `[b` / `]b` | Previous / next buffer |
| `Space bd` | Close buffer |

## Search (Telescope) — `Space s`

| Key | Action |
|-----|--------|
| `Space sf` | Find files |
| `Space sg` | Live grep (search text in project) |
| `Space sw` | Search word under cursor |
| `Space sh` | Search help |
| `Space sk` | Search keymaps |
| `Space sd` | Search diagnostics |
| `Space sr` | Resume last search |
| `Space s.` | Recent files |
| `Space sc` | Search commands |
| `Space ss` | Search Telescope pickers |
| `Space /` | Fuzzy search in current buffer |
| `Space s/` | Live grep in open files |
| `Space sn` | Search neovim config files |

Inside Telescope: `Ctrl-/` (insert) or `?` (normal) to see Telescope keymaps.

## LSP — `gr` prefix

| Key | Action |
|-----|--------|
| `grd` | Go to definition |
| `grr` | Go to references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grD` | Go to declaration |
| `grn` | Rename symbol |
| `gra` | Code action |
| `gO` | Document symbols |
| `gW` | Workspace symbols |
| `K` | Hover documentation (built-in) |
| `Ctrl-t` | Jump back after go-to |

## Diagnostics

| Key | Action |
|-----|--------|
| `[d` / `]d` | Previous / next diagnostic |
| `Space q` | Open diagnostic quickfix list |

## Git (gitsigns) — `Space h`

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next / previous git change |
| `Space hs` | Stage hunk |
| `Space hr` | Reset hunk |
| `Space hS` | Stage entire buffer |
| `Space hu` | Undo stage hunk |
| `Space hR` | Reset entire buffer |
| `Space hp` | Preview hunk |
| `Space hb` | Blame current line |
| `Space hd` | Diff against index |
| `Space hD` | Diff against last commit |

## Toggles — `Space t`

| Key | Action |
|-----|--------|
| `Space th` | Toggle inlay hints |
| `Space tb` | Toggle git blame line |
| `Space tD` | Toggle show deleted lines |

## Surround (mini.surround)

| Key | Action |
|-----|--------|
| `saiw)` | Surround word with `()` |
| `sd"` | Delete surrounding `"` |
| `sr"'` | Replace `"` with `'` |

## Text Objects (mini.ai)

| Key | Action |
|-----|--------|
| `va)` | Select around parentheses |
| `vi"` | Select inside quotes |
| `ci{` | Change inside braces |
| `daf` | Delete around function |

## Formatting

| Key | Action |
|-----|--------|
| `Space f` | Format buffer |
| (automatic) | Format on save (except C/C++) |

## Completion (blink.cmp) — Insert Mode

| Key | Action |
|-----|--------|
| `Ctrl-y` | Accept completion |
| `Ctrl-n` / `Ctrl-p` | Next / previous item |
| `Ctrl-space` | Toggle menu / docs |
| `Ctrl-e` | Dismiss menu |
| `Ctrl-k` | Toggle signature help |
| `Tab` / `Shift-Tab` | Navigate snippet stops |

## Commands

| Command | Action |
|---------|--------|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:Lazy` | Plugin manager |
| `:Mason` | LSP/tool installer |
| `:ConformInfo` | Check formatter status |
| `:checkhealth` | Diagnose issues |
| `:Tutor` | Built-in tutorial |

## Tips

- Press `Space` and wait to see all available keybinds (which-key)
- Yank (`y`) automatically copies to system clipboard
- Relative line numbers let you jump with `5j`, `12k`, etc.
- `:` then up arrow to browse command history
