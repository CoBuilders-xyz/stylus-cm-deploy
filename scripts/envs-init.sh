#!/bin/bash

# Script to initialize environment files by copying .example files to their non-example versions
# Only copies if the target file doesn't already exist

set -e  # Exit on any error

# Define the directory containing the env files
ENV_DIR="src/docker"

# Check if the directory exists
if [ ! -d "$ENV_DIR" ]; then
    echo "Error: Directory $ENV_DIR does not exist"
    exit 1
fi

echo "Initializing environment files in $ENV_DIR..."

# Find all .example files using find command (handles hidden files properly)
found_files=false

while IFS= read -r -d '' example_file; do
    found_files=true
    
    # Get the target filename by removing .example extension
    target_file="${example_file%.example}"
    
    # Extract just the filename for display
    example_filename=$(basename "$example_file")
    target_filename=$(basename "$target_file")
    
    if [ -f "$target_file" ]; then
        echo "⏭️  Skipping $example_filename → $target_filename (target already exists)"
    else
        echo "📄 Copying $example_filename → $target_filename"
        cp "$example_file" "$target_file"
    fi
done < <(find "$ENV_DIR" -maxdepth 1 -name "*.example" -type f -print0)

if [ "$found_files" = false ]; then
    echo "No .example files found in $ENV_DIR"
fi

echo "✅ Environment files initialization complete!"
