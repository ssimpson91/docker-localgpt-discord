#!/bin/bash

# Directory where the source files are located
source_dir="./load"

# Directory where the source files should be moved to for processing
processing_dir="./SOURCE_DOCUMENTS"

# Directory where the source files should be moved to after processing
processed_dir="./ingested"

# Read all file names into an array
readarray -t all_files < <(find "$source_dir" -maxdepth 1 -type f)

# Get the total number of files
total_files=${#all_files[@]}

# Process in batches of 10
for ((i=0; i<total_files; i+=10)); do
    # Get up to 10 files from the array
    files_to_process=("${all_files[@]:i:10}")

    # Move and process files
    for file in "${files_to_process[@]}"; do
        mv "$file" "$processing_dir/"
    done

    # Run ingest.py for the batch
    python ingest.py

    # Move processed files to the processed directory
    mv "$processing_dir"/* "$processed_dir/"
done
