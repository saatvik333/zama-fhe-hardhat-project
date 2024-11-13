#!/bin/bash

# Define the input, output, and environment variable files
INPUT_FILE="docker-compose/docker-compose-full.yml.template"
OUTPUT_FILE="docker-compose/docker-compose-full.yml"
DOCKER_ENV_FILE="docker-compose/.env.docker"

# Create a temporary file to work with
TEMP_FILE=$(mktemp)
# Copy the contents of the input file to the temporary file
cp "$INPUT_FILE" "$TEMP_FILE"

# Read each line from the environment file
while IFS= read -r line
do
    # Skip empty lines or lines that start with a comment
    [[ $line =~ ^[[:space:]]*$ || $line =~ ^# ]] && continue

    # Extract the key and value from the line
    key=$(echo "$line" | cut -d= -f1)
    value=$(echo "$line" | cut -d= -f2-)

    # Trim any leading or trailing whitespace from the key and value
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)

    # Escape special characters in the value for use in sed
    value=$(printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g')

    # Replace occurrences of the key in the temporary file with the value
    sed -i.bak "s|\${$key}|$value|g" "$TEMP_FILE"
done < "$DOCKER_ENV_FILE"

# Move the modified temporary file to the output file location
mv "$TEMP_FILE" "$OUTPUT_FILE"

# Print a message indicating the process is complete
echo "Processed $INPUT_FILE and wrote result to $OUTPUT_FILE"
