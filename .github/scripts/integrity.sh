#!/bin/bash

# Define the root directory to search Lua files
SEARCH_DIR="users/"

# Find all .lua files in the directory and its subdirectories
find "$SEARCH_DIR" -type f -name "*.lua" | while read -r lua_file; do
    # Extract lines containing .dds paths and process them
    grep -Fve "--" $lua_file | grep -oE 'HodorReflexes/users/[^"]+\.dds' |  while read -r dds_path; do
        echo "checking: $dds_path"
        relative_dds_path="${dds_path#HodorReflexes/}"
        # Check if the file exists
        if [[ ! -f "$relative_dds_path" ]]; then
            echo "Missing file: $relative_dds_path (referenced in $lua_file)"
            exit 1
        fi
    done
done

echo "Done!"