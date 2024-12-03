#!/bin/bash

# Exit on any error
set -e

# Function to handle exit with a prompt for user input
exit_with_prompt() {
    echo -e "$1"
    echo "Press any key to quit..."
    read -n 1 -s
    exit 1
}

# Step -1: Create and activate Python virtual environment
echo "Setting up Python virtual environment..."
if [[ ! -d ".venv" ]]; then
    echo "Creating virtual environment in '.venv'..."
    python -m venv .venv || exit_with_prompt "ERROR: Failed to create virtual environment."
    # install reqs 
else
    echo "Virtual environment '.venv' already exists."
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate || exit_with_prompt "ERROR: Failed to activate virtual environment."
echo "Virtual environment activated."
echo "installing requirements"
pip install -r extraction/requirements.txt || exit_with_prompt "ERROR: Failed to install requirements."

# Check if required files exist
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

# Step 0: cd into dir ./extraction and load the .env file to set the env vars
cd extraction || exit_with_prompt "ERROR: Directory 'extraction' not found."
echo "Changing to 'extraction' directory..."

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
repo_folder="./repo"
if [[ ! -d $repo_folder ]]; then
    echo "Creating repository folder: $repo_folder..."
    mkdir -p "$repo_folder"
fi

# Step 1: Parse each line in repos.txt and git clone each repo into repo_folder
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

echo "Running the Python script: main.py..."
if [[ -f "main.py" ]]; then
    python main.py || exit_with_prompt "ERROR: Python script 'main.py' failed."
else
    exit_with_prompt "ERROR: 'main.py' not found in 'extraction' directory."
fi

echo "Script execution completed successfully."
