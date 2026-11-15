# Style guide

How Wabi's colours are meant to be used, so that every port looks like the same theme. When building or reviewing a port, use this as the reference.

The colours themselves live in [`palette/palette.json`](../palette/palette.json). This guide only talks about **roles** (`bg0`, `orange`, `comment`…), never hex values: each role has a value per variant (dark and light), and the generator fills them in.

## Principles

- **Calm first.** Most of the screen is neutral. Accents are used for meaning (a keyword, an error, the cursor), not decoration.
- **Orange is the signature.** The clay orange marks what's active or important: the cursor, keywords, focus, the active tab. Don't spread it everywhere.
- **One flat background.** Fixed parts of the UI share the editor background. Only things that float on top get a lifted surface.
- **Readable.** Every text colour must keep at least **4.5:1** contrast against `bg0` (WCAG AA). `node generator/build.js --check` verifies it.

## Roles

### Backgrounds

From the base outward. In the dark variant each step is lighter, in the light variant each step is darker, so the meaning is the same in both.

| Role | Use it for |
| --- | --- |
| `bg_dim` | The deepest surface: inactive window title bars. Use sparingly. |
| `bg0` | **The base.** Editor, terminal background, and all fixed chrome: sidebars, panels, tab bars, status bar, title bar. |
| `bg1` | **Floating UI**: menus, popups, autocomplete, hovers, notifications, inputs. Also the current-line highlight and code blocks. |
| `bg2` | Hover states, inactive selections, indent guides, rulers, subtle dividers. |
| `bg3` | Borders, the selected item in lists, bracket matches. |
| `bg4` | Invisibles (whitespace characters), the active indent guide, strong borders. |

### Foregrounds

| Role | Use it for |
| --- | --- |
| `fg0` | Emphasis: the active tab, headings, bold text, the selected item in a list. |
| `fg` | **Body text.** The default for everything that's read. |
| `fg1` | Secondary text: sidebar items, active line number, operators, properties, parameters. |
| `fg2` | Muted text: punctuation, descriptions, inactive tabs. Also, with transparency, scrollbar thumbs. |
| `comment` | Comments, line numbers, placeholders, disabled items. The faintest text that still passes 4.5:1. |

### Accents and meaning

| Role | Meaning | Typical UI use | Typical syntax use |
| --- | --- | --- | --- |
| `orange` | Signature, active | Cursor, focus, active-tab marker, primary buttons, badges | Keywords, tags, headings |
| `red` | Error, removal | Errors, deleted lines | Invalid code |
| `yellow` | Warning, change, search | Warnings, modified lines, search matches | Types, classes, attributes |
| `green` | Success, addition | Added lines | Strings |
| `aqua` | Hint, secondary info | Hints, tags (Obsidian) | Escapes, regex, `self`/`this`, namespaces |
| `blue` | Information, links | Info messages, links | Functions and methods |
| `purple` | Constants | | Numbers, booleans, constants, enum members |

The `bright_*` versions are for terminal bright colours and for hover states of accent elements (for example `bright_orange` on a hovered button).

### Semantic aliases

`accent`, `error`, `warning`, `info`, `hint`, `git_added`, `git_modified` and `git_removed` point at the accents above. Prefer them in templates when the meaning matters more than the colour: a port that says `{{error}}` will follow if the palette ever moves errors to another hue.

## Syntax highlighting

| Token | Role | Style |
| --- | --- | --- |
| Keywords, storage (`if`, `return`, `const`, `import`) | `orange` | |
| Functions, methods, function calls | `blue` | |
| Strings, template strings | `green` | |
| Escapes, regex, string interpolation | `aqua` | |
| Types, classes, interfaces, attributes, decorators | `yellow` | |
| Numbers, booleans, constants, enum members | `purple` | |
| `self` / `this`, built-in variables, namespaces, modules | `aqua` | |
| Variables | `fg` | |
| Parameters, properties, object keys | `fg1` | |
| Operators | `fg1` | |
| Punctuation, brackets, delimiters | `fg2` | |
| Comments | `comment` | italic |
| Doc comments | `fg2` | italic |
| Tags (HTML/XML) | `orange` | |
| Invalid code | `red` | |

### Markup (Markdown and similar)

| Token | Role | Style |
| --- | --- | --- |
| Headings | `orange` (Obsidian: H1 `orange`, the rest `fg0`) | bold |
| Bold | `fg0` | bold |
| Italic | (unchanged) | italic |
| Inline code, code blocks | `green` | |
| Links | `blue` (URLs in `aqua`) | |
| Quotes | `fg2` | italic |
| List markers | `orange` | |

## UI conventions

- **Cursor**: `orange`.
- **Selection**: `orange` at 20% opacity (`{{orange}}33`). Terminals are the exception: there the selection is `bg3` and keeps the text colour, because terminals can't blend colours.
- **Focus**: `orange` at 50% for focus borders.
- **Active tab**: marked with an `orange` line where the app supports it (VSCode). Where the background is the only cue (Zed), the active tab uses `bg1`.
- **Search**: matches in `yellow` at 25%, the current match in `orange` at 35%.
- **Diagnostics**: `error` / `warning` / `info` / `hint` for text and icons, and the same colours at 10% for backgrounds and 30% for borders.
- **Diff and git**: `git_added` / `git_modified` / `git_removed` for gutters and file names, at 15% for whole-line backgrounds.

### Transparency

Templates add opacity by appending two hex digits to a colour (`{{orange}}33`). Stick to these steps so ports feel consistent:

| Suffix | Opacity | Used for |
| --- | --- | --- |
| `1a` | 10% | Status backgrounds (error, warning…), inactive selection |
| `26` | 15% | Word highlights, diff text backgrounds, drop targets |
| `33` | 20% | Selection, scrollbar thumbs |
| `40` | 25% | Search matches |
| `4d` | 30% | Status borders |
| `59` | 35% | Current search match, hovered scrollbar |
| `80` | 50% | Focus borders |

For apps that need `rgba()`, use `{{key.rgb}}` and the same opacities, for example `rgba({{orange.rgb}}, 0.2)`.

## Terminal colours

| ANSI | Normal | Bright |
| --- | --- | --- |
| black | `ansi_black` | `ansi_bright_black` |
| red | `red` | `bright_red` |
| green | `green` | `bright_green` |
| yellow | `yellow` | `bright_yellow` |
| blue | `blue` | `bright_blue` |
| magenta | `purple` | `bright_purple` |
| cyan | `aqua` | `bright_aqua` |
| white | `ansi_white` | `ansi_bright_white` |

Background `bg0`, foreground `fg`, cursor `orange`. Black and white have their own keys because light themes swap them: black has to be dark to be readable on a light background.

Orange has no ANSI slot. Where the terminal allows it (Alacritty), it's exposed as indexed colour **16** (`orange`) and **17** (`bright_orange`).

## Dark and light

Every port ships both variants, and they must behave the same way: same roles, same rules. In the light variant the accents are darker so they keep the 4.5:1 contrast; the template doesn't need to know, because it only uses roles.
