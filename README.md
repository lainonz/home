# Personal Dotfiles

🚀 My personal dotfiles configuration - managed setup scripts for Zsh, Tmux, and other tools.

## 📁 Structure

```
home/
├── README.md              # This file
├── setup.sh               # Main installer script
├── .gitignore             # Exclude patterns
├── zsh/                   # Zsh configuration
│   ├── .zshrc             # Main Zsh config
│   └── custom/            # Custom Oh My Zsh additions
│       └── themes/
│           └── wizard.zsh-theme
└── zellij/                # Zellij configuration
    ├── config.kdl         # Main Zellij config
    ├── layouts/           # Custom layouts
    ├── plugins/           # Custom plugins
    ├── scripts/           # Helper scripts
    ├── themes/            # UI themes
    └── zjstatus-themes/   # Status bar themes
```

## 🚀 Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/username/dotfiles/main/setup.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/username/dotfiles.git
cd dotfiles
./setup.sh
```

## ⚙️ Installation

Run the setup script and choose what to install:

```bash
./setup.sh
```

Available options:
1. **zsh** - Zsh shell with Oh My Zsh and custom configuration
2. **zellij** - Terminal multiplexer with custom layouts and themes
3. **all** - Install all available configurations

## 📋 Configurations

### Zsh

🧙‍♂️ Features:
- **Wizard Theme**: Clean prompt with context awareness
- **Dynamic Context**: Auto-detects Git/Node/Python/Rust/Go projects
- **Fuzzy Completion**: FZF integration with transparent UI
- **Smart Keybinds**: 
  - `Ctrl+R`: Search history
  - `Ctrl+F`: Search files
- **Syntax Highlighting**: Commands colored by context
- **Auto Suggestions**: Intelligent history completion

**Theme Preview:**
```
[🧙‍♂️] [user@hostname] >> ~/project/go-api [🐹 v1.25.7] $ ls
[🧙‍♂️] [user@hostname] >> ~/project/node-app [⬢ v20.18.0] $ npm test
```

**Context Indicators:**
- 🌿 Git: branch + status (`*` modified, `↑↓` ahead/behind)
- ⬢ Node.js: version (when `package.json` detected)
- 🐍 Python: version (when `requirements.txt`, `pyproject.toml`, etc.)
- 🦀 Rust: version (when `Cargo.toml` detected)
- 🐹 Go: version (when `go.mod`, `go.sum`, or `main.go` detected)

### Zellij

🦊 Features:
- **Terminal Multiplexer**: Modern terminal workspace manager
- **Custom Layouts**: Optimized layouts for development workflows
- **Status Bar**: Rich status information with zjstatus
- **Plugin System**: Extensible functionality
- **Session Management**: Persistent sessions across reboots
- **Theme Support**: Custom UI themes for better visual experience

**Usage:**
```bash
zellij  # Start new session
zellij attach  # List and attach to existing sessions
zellij ls  # List active sessions
```

## 🛠️ Management

### Adding New Configurations

1. Create directory: `config_name/`
2. Add your config files
3. Update `setup.sh` with new `install_config()` function
4. Add to main menu with appropriate number

Example for new config:
```bash
install_myconfig() {
    echo ""
    info "Installing MyConfig..."
    # Installation logic here
}
```

Update the menu in `main()`:
```bash
echo "Available configurations:"
echo "1) zsh"
echo "2) zellij"
echo "3) myconfig"  # New option
echo "4) all"
```

### Backup and Restore

The setup script automatically:
- Backups existing configurations to `~/.dotfiles-backup-YYYYMMDD-HHMMSS/`
- Creates symbolic links to repo files
- Preserves original configs

### Updating

```bash
cd ~/path/to/dotfiles
git pull
./setup.sh
```

## 🔧 Customization

### Zsh Theme

Edit `zsh/custom/themes/wizard.zsh-theme`:

```zsh
# Add new language support
function mylang_info() {
    if [[ -f "mylang.file" ]]; then
        echo "%F{240}🔧%F{cyan} version%f"
    fi
}

# Add to dynamic_context()
info+=$(mylang_info)
```

### FZF Style

Edit FZF options in `zsh/.zshrc`:

```zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded"
```

## 📦 Dependencies

**Required:**
- `curl` (downloader)
- `git` (version control)

**Auto-installed:**
- `zsh` (shell)
- `fzf` (fuzzy completion)
- `fd` (fast file search, optional)
- `zellij` (terminal multiplexer, optional)

**Package Managers Supported:**
- `pacman` (Arch Linux)
- `apt` (Ubuntu/Debian)
- `brew` (macOS)

## 🌿 Future Plans

- [ ] Neovim setup
- [ ] Git configuration
- [ ] Shell scripts
- [ ] System configurations
- [ ] Other terminal tools

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `./setup.sh`
5. Submit a pull request

## 📄 License

MIT License - feel free to fork and customize for your own setup!

---

**Happy configuring! ✨**