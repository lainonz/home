# Custom Oh My Zsh Theme - Wizard Prompt
# Format: [🧙‍♂️] [username@hostname] >> directory [dynamic info] $

# Git status
ZSH_THEME_GIT_PROMPT_PREFIX="%F{240}on %F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}✓%f"

# Node info
function node_info() {
    if [[ -f "package.json" ]] && command -v node &> /dev/null; then
        echo "%F{240}⬢%F{green} $(node -v | sed 's/v//')%f"
    fi
}

# Python info
function python_info() {
    if [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" || -f "Pipfile" ]] && command -v python3 &> /dev/null; then
        echo "%F{240}🐍%F{blue} $(python3 --version | cut -d' ' -f2)%f"
    fi
}

# Rust info
function rust_info() {
    if [[ -f "Cargo.toml" ]] && command -v cargo &> /dev/null; then
        echo "%F{240}🦀%F{red} $(rustc --version | cut -d' ' -f2)%f"
    fi
}

# Go info
function go_info() {
    if [[ -f "go.mod" || -f "go.sum" || -f "main.go" ]] && command -v go &> /dev/null; then
        echo "%F{240}🐹%F{cyan} $(go version | cut -d' ' -f3 | sed 's/go//')%f"
    fi
}

# Dynamic context info
function dynamic_context() {
    local info=""
    info+=$(node_info)
    info+=$(python_info)
    info+=$(rust_info)
    info+=$(go_info)
    
    if [[ -n $info ]]; then
        echo "$info"
    fi
}

# Simple static prompt - no function calls to avoid conflicts
function build_prompt() {
    local git_info=$(git_prompt_info)
    local context=$(dynamic_context)
    
    local prompt="[%F{magenta}🧙‍♂️%f] [%F{cyan}%n%f@%F{yellow}%m%f] >> %F{green}%~%f"
    
    if [[ -n $git_info ]]; then
        prompt+=" $git_info"
    fi
    
    if [[ -n $context ]]; then
        prompt+=" [$context]"
    fi
    
    prompt+=" $"
    echo "$prompt"
}

PROMPT='$(build_prompt) '

# Right prompt disabled
RPROMPT=''