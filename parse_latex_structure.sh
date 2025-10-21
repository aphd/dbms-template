#!/bin/bash

# Recursively parse a LaTeX file and all its \input{} dependencies for section structure
parse_file() {
    local file="$1"
    # Remove possible .tex extension for \input{} compatibility
    local basefile="${file%.tex}"
    # If file does not exist, try adding .tex
    if [ ! -f "$file" ]; then
        if [ -f "$basefile.tex" ]; then
            file="$basefile.tex"
        else
            echo "File $file not found."
            return
        fi
    fi
    # Read file line by line
    while IFS= read -r line; do
        # If line is an \input{...}, recursively parse the included file
        if [[ $line =~ \\input\{([^}]*)\} ]]; then
            included_file="${BASH_REMATCH[1]}"
            # Recursively parse the included file
            parse_file "$included_file"
        fi
        # Print section, subsection, subsubsection lines for later processing
        if [[ $line =~ \\section\{.*\} ]] || [[ $line =~ \\subsection\{.*\} ]] || [[ $line =~ \\subsubsection\{.*\} ]]; then
            echo "$line"
        fi
    done < "$file"
}

# Check if a file is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file.tex>"
    exit 1
fi

# Start recursive parsing and pipe to awk for formatting
parse_file "$1" | awk '
{
    if ($0 ~ /\\section\{/) {
        title = substr($0, index($0, "{") + 1)
        title = substr(title, 1, length(title) - 1)
        printf "[Section] %s\n", title
    } else if ($0 ~ /\\subsection\{/) {
        title = substr($0, index($0, "{") + 1)
        title = substr(title, 1, length(title) - 1)
        printf "  [Subsection] %s\n", title
    } else if ($0 ~ /\\subsubsection\{/) {
        title = substr($0, index($0, "{") + 1)
        title = substr(title, 1, length(title) - 1)
        printf "    [Subsubsection] %s\n", title
    }
}'
