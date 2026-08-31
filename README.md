# ASCIIFlow

Generate beautiful large ASCII text banners directly from your terminal - a lightweight, dependency-free Bash tool.

<p align="left">
  <a href="https://github.com/MichaelAcostaDev/ASCIIFlow"><img alt="GitHub Repository" src="https://img.shields.io/badge/GitHub-ASCIIFlow-181717?logo=github" /></a>
  <a href="https://github.com/MichaelAcostaDev"><img alt="GitHub Profile" src="https://img.shields.io/badge/GitHub-MichaelAcostaDev-181717?logo=github" /></a>
  <a href="https://opensource.org/licenses/MIT"><img alt="MIT License" src="https://img.shields.io/badge/License-MIT-green.svg" /></a>
  <img alt="Bash" src="https://img.shields.io/badge/Language-Bash-4EAA25?logo=gnu-bash" />
</p>

## About

ASCIIFlow is a lightweight, pure-Bash CLI tool that renders text as large, multi-line ASCII art banners. Perfect for creating eye-catching terminal decorations, script headers, documentation, or just having fun with ASCII art.

**Key Philosophy:** Small, fast, portable, zero dependencies, readable code.

## Features

✨ **Multiple Fonts** - Block, Digital, Banner, Small  
🎨 **No Dependencies** - Pure Bash, works everywhere  
⚡ **Fast** - Instant rendering  
📦 **Portable** - Works on any Linux distribution  
🔤 **Rich Character Set** - A-Z, a-z, 0-9, punctuation  
🎯 **Simple CLI** - Intuitive, minimal options  

## Quick Start

### Installation

```bash
git clone https://github.com/MichaelAcostaDev/ASCIIFlow.git
cd ASCIIFlow
./install.sh
```

Then open a new terminal, or run:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Basic Usage

```bash
asciiflow "Hello"
```

Output:
```
█   █   █████   █       █        ███   
█   █   █       █       █       █   █  
█████   ████    █       █       █   █  
█   █   █       █       █       █   █  
█   █   █████   █████   █████    ███   
```

## Usage Guide

### Generate a Banner

```bash
asciiflow "Your Text"
```

### Choose a Font

```bash
asciiflow -f block "Hello"          # Default (bold, large)
asciiflow -f digital "Hello"        # 7-segment display style
asciiflow -f banner "Hello"         # Classic banner
asciiflow -f small "Hello"          # Compact
```

### List Available Fonts

```bash
asciiflow -l
```

### Get Help

```bash
asciiflow -h
```

### Check Version

```bash
asciiflow -v
```

## Command Reference

```
Usage:
  asciiflow "text"
  asciiflow -f FONT "text"
  asciiflow -l
  asciiflow -h
  asciiflow -v

Options:
  -f, --font FONT    Use a specific font (default: block)
  -l, --list         List available fonts
  -h, --help         Show help
  -v, --version      Show version

Examples:
  asciiflow "Hello"
  asciiflow -f digital "Arch Linux"
  asciiflow -f small "Test"
```

## Fonts

### block
Large, bold block letters - perfect for prominent headers.

### digital
Digital display style inspired by 7-segment displays.

### banner
Classic clean banner style.

### small
Compact version for space-constrained terminals.

## Examples

### Welcome Banner
```bash
asciiflow "Welcome to Linux"
```

### Project Header
```bash
asciiflow -f digital "MyProject"
```

### Documentation
```bash
asciiflow -f banner "Features"
```

## Architecture

ASCIIFlow uses a modular design for maintainability:

- **asciiflow** - Main entry point
- **src/cli.sh** - Command-line parsing
- **src/fonts.sh** - Font loading engine  
- **src/renderer.sh** - ASCII composition engine
- **fonts/*.font** - Font definitions

### Font File Format

Font files use a simple text format:

```
# Comment

@A
 ███ 
█   █
█████
█   █
█   █

@B
████ 
█   █
████ 
█   █
████ 
```

Each `@CHARACTER` marker is followed by ASCII art lines for that character.

## Uninstall

```bash
./uninstall.sh
```

Or manually:
```bash
rm ~/.local/bin/asciiflow
```

## Requirements

- **Bash** 4.0+
- Standard Unix tools (already on all Linux systems)
- UTF-8 terminal (recommended for best visuals)

## Compatibility

Tested and working on:
- ✅ Arch Linux
- ✅ Ubuntu / Debian  
- ✅ Fedora / RHEL
- ✅ Alpine Linux
- ✅ Any Linux with Bash 4.0+

## Performance

- **Rendering time**: <50ms for typical text
- **Memory usage**: Minimal (~100KB)
- **No external calls**: Standalone execution

## License

This project is licensed under the [MIT License](LICENSE).

## Author

Michael Acosta / [@MichaelAcostaDev](https://github.com/MichaelAcostaDev)

## Contributing

Contributions welcome! Feel free to submit issues, fork, or create pull requests.

---

**Made with ❤️ in Bash**
