# ASCIIFlow

A small Bash CLI for generating clean ASCII banners directly in the terminal.

<p align="left">
  <a href="https://github.com/MichaelAcostaDev/ASCIIFlow"><img alt="GitHub Repository" src="https://img.shields.io/badge/GitHub-ASCIIFlow-181717?logo=github" /></a>
  <a href="https://github.com/MichaelAcostaDev"><img alt="GitHub Profile" src="https://img.shields.io/badge/GitHub-MichaelAcostaDev-181717?logo=github" /></a>
  <a href="https://opensource.org/licenses/MIT"><img alt="MIT License" src="https://img.shields.io/badge/License-MIT-green.svg" /></a>
  <img alt="Bash" src="https://img.shields.io/badge/Language-Bash-4EAA25?logo=gnu-bash" />
</p>

## About

ASCIIFlow is a lightweight Bash utility for turning text into terminal-friendly ASCII banners. It stays intentionally small: one entrypoint, a few source files, no mandatory external dependencies, and a straightforward CLI.

The goal is simple: create a banner quickly, adjust the style, and keep the output clean enough for everyday shell use.

## Installation

```bash
git clone https://github.com/MichaelAcostaDev/ASCIIFlow.git
cd ASCIIFlow
chmod +x install.sh
./install.sh
```

The installer places the command in `~/.local/bin/asciiflow`.

If `~/.local/bin` is not in your `PATH`, add this to your shell startup file:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Usage

Generate a banner:

```bash
asciiflow "Hello"
```

Use a specific style:

```bash
asciiflow --style block "Arch Linux"
asciiflow --style minimal "Hello"
```

Short form:

```bash
asciiflow -s block "Hello"
```

List styles:

```bash
asciiflow --list
asciiflow -l
```

Random style:

```bash
asciiflow --random "ASCIIFlow"
```

Save and load a banner:

```bash
asciiflow --save welcome "Welcome"
asciiflow --load welcome
```

Help and version:

```bash
asciiflow --help
asciiflow --version
```

## Options

```text
-s, --style STYLE   Use a built-in style
-S, --save NAME     Save a banner
-L, --load NAME     Load a saved banner
-l, --list          List all styles
-r, --random        Pick a random style
-n, --no-color      Disable ANSI colors
-v, --version       Show version
-h, --help          Show help
```

Available styles:

```text
block
small
minimal
banner
slant
shadow
digital
```

## Credits

Michael Acosta / MichaelAcostaDev

## License

This project is licensed under the [MIT License](LICENSE).
