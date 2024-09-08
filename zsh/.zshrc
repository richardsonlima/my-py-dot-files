# Definir cores
RED="%F{red}"
GREEN="%F{green}"
YELLOW="%F{yellow}"
BLUE="%F{blue}"
CYAN="%F{cyan}"
MAGENTA="%F{magenta}"
RESET="%F{reset}"
BOLD="%B"

# Mostrar o status da última execução do comando
setopt prompt_subst
function prompt_status() {
    if [[ $? == 0 ]]; then
        echo "%{$GREEN%}✔%{$RESET%}"  # Comando executado com sucesso
    else
        echo "%{$RED%}✘%{$RESET%}"  # Comando falhou
    fi
}

# Mostrar o branch Git atual
function git_prompt_info() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [ -n "$branch" ]; then
        echo "$YELLOW($branch)$RESET"
    fi
}

# Mostrar o Python venv ativo
function python_venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "$CYAN(venv:$(basename $VIRTUAL_ENV))$RESET"
    fi
}

# Definir o prompt PS1
export PS1='${BOLD}${CYAN}%n@%m${RESET} ${GREEN}%~${RESET} $(git_prompt_info) $(python_venv_info) $(prompt_status)
$ '

# Definir o prompt para a linha de comando contínua (segunda linha)
export PROMPT2="${YELLOW}>${RESET} "

# Define the HOME variable
export MY_HOME="$HOME"

# Path to your oh-my-zsh installation.
export ZSH="$MY_HOME/.oh-my-zsh"

# Load Zsh's Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Set Theme
ZSH_THEME="gnzh"

# Aliases for system and development tasks
alias pip="pip3"
alias cls="clear"
alias ll="ls -lah"
alias py="python3"
alias pip-upgrade="pip list --outdated | grep -v '^\(Package\|\-\-\-\)' | awk '{print $1}' | xargs -n1 pip install -U"
#alias activate="source venv/bin/activate"
#alias deactivate="deactivate"
unalias deactivate 2>/dev/null

# Docker & Kubernetes
alias dk="docker"
alias dps="docker ps"
alias k="kubectl"

# Python Versions Management with pyenv
export PYENV_ROOT="$MY_HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Poetry for Python Dependency Management
export PATH="$MY_HOME/.poetry/bin:$PATH"
alias poetry-act="poetry shell"

# Jupyter Notebooks & Lab
alias jn="jupyter notebook"
alias jl="jupyter lab"

# TensorFlow & PyTorch Environment Variables
export TF_CPP_MIN_LOG_LEVEL=2  # Suppress TensorFlow warnings
export TORCH_HOME="$MY_HOME/.torch"

# Kubernetes Context
alias kctx="kubectl config current-context"
alias kns="kubectl config set-context --current --namespace"

# Virtualenv and venv management
export WORKON_HOME=$MY_HOME/.virtualenvs
alias mkvenv="python3 -m venv"
alias rmvenv="rm -rf venv"
alias lsvenv="lsvirtualenv"

# Python linting and formatting
alias lint="flake8 ."
alias format="black ."
alias isort="isort ."

# Set pip to disable cache and enable progress bar
export PIP_NO_CACHE_DIR=1
export PIP_PROGRESS_BAR="on"

# Custom function to create a virtual environment and install requirements
mkvenv_and_install() {
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    fi
}

# Custom function to deactivate all Python environments
deactivate_all() {
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
    fi
    if [ -n "$(pyenv version-name)" ]; then
        pyenv deactivate
    fi
}

# Git Aliases for Efficiency
alias gcl="git clone"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gst="git status"
alias gco="git checkout"
alias gd="git diff"

# Python development environment setup (Data Science and ML focused)
export PYTHONPATH=$PYTHONPATH:$MY_HOME/projects/
export PYTHONSTARTUP=$MY_HOME/.pythonrc.py

# Setup Anaconda (if using)
export PATH="$MY_HOME/anaconda3/bin:$PATH"

# Node.js for working with frontend (optional)
export NVM_DIR="$MY_HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Fast access to ML/DL Projects
alias cdml="cd $MY_HOME/projects/machine_learning"
alias cddata="cd $MY_HOME/projects/data_engineering"
alias cdmlops="cd $MY_HOME/projects/mlops"

# Environment for data processing tools
export SPARK_HOME=/usr/local/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Angular CLI autocompletion
source <(ng completion script)

# Python auto-completion
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit
eval "$(register-python-argcomplete pip)"
eval "$(register-python-argcomplete python)"
eval "$(register-python-argcomplete poetry)"

# SDKMAN Configuration
export SDKMAN_DIR="$MY_HOME/.sdkman"
[[ -s "$MY_HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$MY_HOME/.sdkman/bin/sdkman-init.sh"

# Conda Initialization
__conda_setup="$('$MY_HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$MY_HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$MY_HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$MY_HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# >>> conda initialize >>>
# <<< conda initialize <<<

# Preferred editor for local and remote sessions
export EDITOR="vim"

# Path adjustments
PATH="$PATH:/opt/homebrew/bin/"

# --- Function to activate Python venvs based on context ---
activate_venv() {
    # Remover o alias 'deactivate' se existir
    unalias deactivate 2>/dev/null

    local CONTEXT=$1

    if [[ "$CONTEXT" == "llm" ]]; then
        source "$HOME/python-llm-development/venv-3.11-llm-development/bin/activate"
        echo "Activated venv for LLM Development"
    elif [[ "$CONTEXT" == "dev" ]]; then
        source "$HOME/python-development/venv-3.11-development/bin/activate"
        echo "Activated venv for General Python Development"
    elif [[ "$CONTEXT" == "notebooks" ]]; then
        source "$HOME/python-notebooks/venv-3.11-jupyter_notebooks-development/bin/activate"
        echo "Activated venv for Python Notebooks"
    elif [[ "$CONTEXT" == "general" ]]; then
        source "$HOME/venv-3.11-general_purpose-development/bin/activate"
        echo "Activated general-purpose venv"
    else
        echo "Invalid context. Please use one of the following: llm, dev, notebooks, general."
    fi
}

# --- How to Use ---
# To activate a Python virtual environment based on the context, use:
# activate_venv <context>
# Available contexts:
# - llm: for LLM Development
# - dev: for General Python Development
# - notebooks: for Jupyter Notebooks
# - general: for the general-purpose venv


# --- Informative Message on Required Homebrew Packages ---
echo -e "\033[1;32m🍺 \033[0m \033[1;36mTo ensure your development environment works perfectly, install the following Homebrew packages:\033[0m"
echo ""
echo -e "\033[1;33m➜ Core Packages:\033[0m"
echo -e "  - \033[1;32m✅ brew install python\033[0m: Installs the latest version of Python."
echo -e "  - \033[1;32m✅ brew install pyenv\033[0m: Python version management."
echo -e "  - \033[1;32m✅ brew install pyenv-virtualenv\033[0m: Virtual environment management for pyenv."
echo ""
echo -e "\033[1;33m➜ Development Tools:\033[0m"
echo -e "  - \033[1;32m✅ brew install poetry\033[0m: Python dependency management tool."
echo -e "  - \033[1;32m✅ brew install argcomplete\033[0m: Provides shell autocompletion for Python scripts."
echo ""
echo -e "\033[1;33m➜ System Tools:\033[0m"
echo -e "  - \033[1;32m✅ brew install git\033[0m: Version control system."
echo -e "  - \033[1;32m✅ brew install docker\033[0m: Containerization platform."
echo -e "  - \033[1;32m✅ brew install kubectl\033[0m: Command-line tool for interacting with Kubernetes clusters."
echo ""
echo -e "\033[1;33m➜ Optional Tools:\033[0m"
echo -e "  - \033[1;32m✅ brew install nvm\033[0m: Node.js version management."
echo -e "  - \033[1;32m✅ brew install sdkman\033[0m: SDK manager for Java and other JVM-related tools."
echo ""
echo -e "\033[1;32m==> \033[0m \033[1;36mRun the above commands to install the necessary packages.\033[0m"


# --- Function to check if a Homebrew package is installed ---
check_brew_package() {
    if brew list -1 | grep -q "^$1\$"; then
        echo -e "  - \033[1;32m✅ $1 is already installed.\033[0m"
        return 0
    else
        echo -e "  - \033[1;31m❌ $1 is not installed. Installing now...\033[0m"
        brew install $1
        return 1
    fi
}

# --- Start of the script ---
echo -e "\033[1;32m🍺 \033[0m \033[1;36mChecking if your development environment is set up correctly and installing missing packages automatically:\033[0m"
echo ""

echo -e "\033[1;33m➜ Core Packages:\033[0m"
check_brew_package "python"
check_brew_package "pyenv"
check_brew_package "pyenv-virtualenv"
echo ""

echo -e "\033[1;33m➜ Development Tools:\033[0m"
check_brew_package "poetry"
check_brew_package "argcomplete"
echo ""

echo -e "\033[1;33m➜ System Tools:\033[0m"
check_brew_package "git"
check_brew_package "docker"
check_brew_package "kubectl"
echo ""

echo -e "\033[1;33m➜ Optional Tools:\033[0m"
check_brew_package "nvm"
check_brew_package "sdkman"
echo ""

echo -e "\033[1;32m==> \033[0m \033[1;36mAll required packages have been installed or were already present.\033[0m"



# --- Informative Message on .zshrc load ---
echo -e "\033[1;32m🍺 \033[0m \033[1;36mZSH Customization Loaded Successfully!\033[0m"
echo -e "\033[1;32m👉 \033[0m \033[1;36mAvailable functionalities:\033[0m"
echo ""
echo -e "\033[1;33m🐍 Python Virtual Environment Management\033[0m"
echo -e "  - Use \033[1;33m'activate_venv <context>'\033[0m to activate venvs:"
echo -e "    - \033[1;32mllm\033[0m: LLM Development"
echo -e "    - \033[1;32mdev\033[0m: General Python Development"
echo -e "    - \033[1;32mnotebooks\033[0m: Jupyter Notebooks"
echo -e "    - \033[1;32mgeneral\033[0m: General Purpose"
echo ""
echo -e "\033[1;33m⚙️ Alias Shortcuts\033[0m"
echo -e "  - \033[1;32mpip, cls, ll, py\033[0m: Simplified commands for pip, clear, ls, and python."
echo -e "  - \033[1;32mdk, dps\033[0m: Docker management aliases."
echo -e "  - \033[1;32mk, kctx, kns\033[0m: Kubernetes management aliases."
echo -e "  - \033[1;32mgcl, ga, gc, gp\033[0m: Git shortcuts for clone, add, commit, and push."
echo ""
echo -e "\033[1;33m📦 Python and Project Management Tools\033[0m"
echo -e "  - \033[1;32mpyenv\033[0m: Manage multiple Python versions."
echo -e "  - \033[1;32mpoetry\033[0m: Dependency management with Poetry."
echo ""
echo -e "\033[1;33m🧹 Code Linting and Formatting\033[0m"
echo -e "  - \033[1;32mlint, format, isort\033[0m: Lint code with flake8, format with black, and sort imports with isort."
echo ""
echo -e "\033[1;33m💾 Data Processing and Machine Learning\033[0m"
echo -e "  - TensorFlow and PyTorch environments configured."
echo -e "  - \033[1;32mSPARK_HOME\033[0m: Set for Apache Spark."
echo ""
echo -e "\033[1;33m🔧 Development Environment Setup\033[0m"
echo -e "  - \033[1;32mNode.js\033[0m: NVM (Node Version Manager) configured."
echo -e "  - \033[1;32mSDKMAN\033[0m: Manage SDKs like Java."
echo -e "  - \033[1;32mConda\033[0m: Initializes Conda environments if available."

echo -e "\033[1;32m==> \033[0m \033[1;36mEnsure all required packages are installed to avoid issues.\033[0m"
