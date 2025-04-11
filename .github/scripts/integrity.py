#!/usr/bin/env python3

import os
import re
import sys

# Define the search directory
SEARCH_DIR = "users"

# Compile regex patterns
dds_pattern = re.compile(r'HodorReflexes/users/[^"]+\.dds')
comment_pattern = re.compile(r'^\s*#|--')

# Track missing files
missing_files = []

# Walk through all files in the directory
for root, _, files in os.walk(SEARCH_DIR):
    for file_name in files:
        if not file_name.endswith(".lua"):
            continue

        lua_file_path = os.path.join(root, file_name)

        with open(lua_file_path, 'r', encoding='utf-8') as file:
            for line_number, line in enumerate(file, start=1):
                # Skip comment lines
                if comment_pattern.search(line):
                    continue

                # Find all .dds paths in the line
                for match in dds_pattern.findall(line):
                    relative_dds_path = match[len("HodorReflexes/"):]
                    if not os.path.isfile(relative_dds_path):
                        missing_files.append((relative_dds_path, lua_file_path, line_number))

# Report results
if missing_files:
    for path, lua_file, line_number in missing_files:
        print(f"Missing file: {path} (referenced in {lua_file}:{line_number})")
    sys.exit(1)
else:
    print("All referenced .dds files are present.")
    sys.exit(0)