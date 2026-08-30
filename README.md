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

That installs the tool into `$HOME/.local/bin/asciiflow`.

If `~/.local/bin` is not in your `PATH`, add this to your shell config:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then verify the installation:

```bash
asciiflow --version
```

## Usage

Generate a banner from text:

```bash
asciiflow "Hello"
```

Use a specific style:

```bash
asciiflow --style block "Arch Linux"
asciiflow --style minimal "Hello"
```

List available styles:

```bash
asciiflow --list
```

Preview all styles:

```bash
asciiflow --preview
```

Create a random banner:

```bash
asciiflow --random
```

Save and load a banner:

```bash
asciiflow --save welcome "Welcome"
asciiflow --load welcome
```

Disable colors:

```bash
asciiflow --no-color "Hello"
NO_COLOR=1 asciiflow "Hello"
```

## Examples

```bash
asciiflow "Michael"
asciiflow --style block "Linux"
asciiflow --style minimal "ASCIIFlow"
asciiflow --random
```

## Options

```text
--help, -h           Show help
--version, -v        Show version
--style STYLE        Select a built-in style
--color COLOR        Set a color name
--gradient NAME      Apply a gradient preset
--random             Pick a random style and color
--list               List available styles
--preview            Preview each built-in style
--save NAME TEXT     Save a banner to XDG storage
--load NAME          Load a saved banner
--no-color           Disable ANSI colors
```

Built-in styles:

```text
block
small
minimal
banner
slant
shadow
digital
```

Available gradients:

```text
sunset
ocean
aurora
fire
neon
purple
```

## Credits

Michael Acosta / MichaelAcostaDev

- GitHub: https://github.com/MichaelAcostaDev
- LinkedIn: https://www.linkedin.com/in/michael-acosta-dev/

## License

This project is licensed under the [MIT License](LICENSE).
