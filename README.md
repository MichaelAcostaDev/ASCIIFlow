## ASCIIFlow

ASCIIFlow is a small Bash CLI for generating ASCII banners directly in the terminal. It keeps the interface simple, supports multiple built-in styles, and works without mandatory external dependencies.

## How can I use

```bash
asciiflow "Michael"
asciiflow --style block "Arch Linux"
asciiflow --style minimal "Hello"
asciiflow --random
asciiflow --list
asciiflow --preview
asciiflow --save my-banner "Welcome"
asciiflow --load my-banner
```

## Installation

```bash
git clone https://github.com/MichaelAcostaDev/ASCIIFlow.git
cd ASCIIFlow
chmod +x install.sh
./install.sh
```

If `~/.local/bin` is not on your `PATH`, add:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Credits

Michael Acosta / MichaelAcostaDev

GitHub: https://github.com/MichaelAcostaDev
LinkedIn: https://www.linkedin.com/in/michael-acosta-dev/

## License

MIT
