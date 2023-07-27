#!/bin/bash
# Script to download papers from https://rentry.org/LocalModelsPapers
# Place all the URL lines (including the date prefix) into a .md file

input_file="input.md"
output_dir="downloaded_pdfs"

mkdir -p "$output_dir"

while IFS= read -r line; do
    url=$(echo "$line" | sed -E 's/.*\((.*)\)/\1/')
    name=$(echo "$line" | sed -E 's/.*\|\[(.*)\].*/\1/')

    download_url=$(echo "$url" | sed -E 's/\/abs\//\/pdf\//')".pdf"

    aria2c -d "$output_dir" -o "$name.pdf" "$download_url"

    echo "Downloaded: $name.pdf"

done < "$input_file"
