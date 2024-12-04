#!/bin/bash

# Exit on any error
set -e

# Function to print a styled header with color, emojis, and extra spacing
print_header() {
    local message="$1"
    local color="\033[1;34m"  # Default color (blue)
    local reset="\033[0m"     # Reset color
    local emoji="🔵"          # Default emoji

    # Customize the color and emoji based on different header levels
    case "$message" in
        *"Checking for Required Files"*)
            color="\033[1;32m"  # Green for this section
            emoji="📂"
            ;;
        *"Setting Up Python Virtual Environment"*)
            color="\033[1;36m"  # Cyan for this section
            emoji="💻"
            ;;
        *"Loading .env and Setting Up Environment Variables"*)
            color="\033[1;35m"  # Magenta for this section
            emoji="🔑"
            ;;
        *"Creating Repository Folder"*)
            color="\033[1;33m"  # Yellow for this section
            emoji="📁"
            ;;
        *"Cloning Repositories from repos.txt"*)
            color="\033[1;31m"  # Red for this section
            emoji="🌐"
            ;;
        *"Running Python Script"*)
            color="\033[1;37m"  # White for this section
            emoji="🐍"
            ;;
        *"Script Execution Completed Successfully"*)
            color="\033[1;32m"  # Green for this section
            emoji="✅"
            ;;
        *)
            color="\033[1;34m"  # Default color (blue)
            emoji="🔵"
            ;;
    esac

    # Print header with extra newlines for visibility
    echo -e "\n\n${color}==============================================="
    echo -e "${color} ${emoji}  $message  ${emoji}"
    echo -e "${color}==============================================="
    echo -e "${reset}\n\n"
}

# Function to handle exit with a prompt for user input
exit_with_prompt() {
    echo -e "$1"
    echo "Press any key to quit..."
    read -s -n 1
    exit 1
}

# Print an initial header with the repo name, emoji, and subtitle
repo_name=$(basename "$(pwd)")
print_header "Welcome to the $repo_name Setup Script 🚀"
echo -e "\033[1;33mThis is a one-click install script that sets up your environment and extracts Looker data.\033[0m"
echo -e "\nPress any key to start..."
read -s -n 1
sleep 1  # Pause for 1 second

# Check if required files exist
print_header "Checking for Required Files"
sleep 1  # Pause for 1 second

required_files=("extraction/.env" "extraction/looker.ini" "extraction/looker_project.json" "extraction/repos.txt")
missing_files=()

for file in "${required_files[@]}"; do
    if [[ ! -f $file ]]; then
        missing_files+=("$file")
    fi
done

if [[ ${#missing_files[@]} -gt 0 ]]; then
    message="ERROR: The following required files are missing:"
    for file in "${missing_files[@]}"; do
        message+="\n- $file"
    done
    message+="\n\nPlease refer from '_example' files to create them."
    exit_with_prompt "$message"
fi

echo "All required files exist."

# Create and activate Python virtual environment
print_header "Setting Up Python Virtual Environment"
sleep 1  # Pause for 1 second
if [[ ! -d ".venv" ]]; then
    echo "Creating virtual environment in '.venv'..."
    python -m venv .venv || exit_with_prompt "ERROR: Failed to create virtual environment."
else
    echo "Virtual environment '.venv' already exists."
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate || exit_with_prompt "ERROR: Failed to activate virtual environment."
echo "Virtual environment activated."
echo "Installing requirements..."
pip install -r extraction/requirements.txt || exit_with_prompt "ERROR: Failed to install requirements."

# Change to the extraction directory and load the .env file
print_header "Loading .env and Setting Up Environment Variables"
sleep 1  # Pause for 1 second

cd extraction || exit_with_prompt "ERROR: Directory 'extraction' not found."

# Load the .env file
if [[ -f ".env" ]]; then
    set -o allexport
    source .env
    set +o allexport
    echo ".env file loaded. Environment variables set."
else
    exit_with_prompt "ERROR: .env file missing in 'extraction'."
fi

# Ensure the repository folder exists
print_header "Creating Repository Folder"
sleep 1  # Pause for 1 second

repo_folder="./repo"
if [[ ! -d $repo_folder ]]; then
    echo "Creating repository folder: $repo_folder..."
    mkdir -p "$repo_folder"
fi

echo "Repository folder created: $repo_folder"

# Parse each line in repos.txt and git clone each repo into repo_folder
print_header "Cloning Repositories from repos.txt"
sleep 1  # Pause for 1 second

echo "Processing repositories listed in repos.txt..."
while IFS= read -r repo_url || [[ -n "$repo_url" ]]; do
    if [[ -n "$repo_url" ]]; then
        # Extract the repository name
        repo_name=$(basename -s .git "$repo_url")
        target_dir="$repo_folder/$repo_name"

        # Clone the repository if it doesn't already exist
        if [[ ! -d $target_dir ]]; then
            echo "Cloning $repo_url into $target_dir..."
            git clone "$repo_url" "$target_dir" || exit_with_prompt "ERROR: Failed to clone $repo_url."
        else
            echo "Repository $repo_name already exists at $target_dir. Skipping..."
        fi
    fi
done < repos.txt

# Run the Python script
print_header "Running Python Script"
sleep 1  # Pause for 1 second

echo "Running the Python script: main.py..."
if [[ -f "main.py" ]]; then
    python main.py -t user || exit_with_prompt "ERROR: Python script 'main.py' failed."
    # python main.py || exit_with_prompt "ERROR: Python script 'main.py' failed."
else
    exit_with_prompt "ERROR: 'main.py' not found in 'extraction' directory."
fi

print_header "Script Execution Completed Successfully"
