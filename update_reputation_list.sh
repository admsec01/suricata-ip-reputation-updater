#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 [-u URL]"
  echo "  -u URL    URL of the IP list to download"
  exit 1
}

# Parse command-line options
while getopts ":u:" opt; do
  case ${opt} in
    u )
      url=$OPTARG
      ;;
    \? )
      usage
      ;;
  esac
done

# Check if URL is provided
if [ -z "$url" ]; then
  echo "Error: URL is required."
  usage
fi

# Define file paths
temp_file="temp_ip_list.txt"
filtered_file="temp_ip_list.filtered"
reputation_file="/etc/suricata/iprep/reputation.list"

# Download the IP list
echo "Downloading IP list from $url..."
curl -s "$url" -o "$temp_file"

# Check if the download was successful
if [ ! -f "$temp_file" ]; then
  echo "Failed to download the IP list."
  exit 1
fi

# Filter out comments and headers, extract valid IPs
echo "Filtering valid IP addresses..."
grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$temp_file" > "$filtered_file"

# Remove localhost IPs
echo "Removing localhost IPs..."
grep -vE '^127\.0\.0\.' "$filtered_file" > "$filtered_file.cleaned"

# Backup the old reputation list
if [ -f "$reputation_file" ]; then
  echo "Backing up the old reputation list..."
  cp "$reputation_file" "$reputation_file.bak"
fi

# Create or clear the reputation file
> "$reputation_file"

# Process each IP address in the cleaned file
while IFS= read -r ip; do
  # Ensure the IP is not empty
  if [ -n "$ip" ]; then
    echo "${ip},10,100" >> "$reputation_file"
  fi
done < "$filtered_file.cleaned"

# Clean up temporary files
rm "$temp_file" "$filtered_file" "$filtered_file.cleaned"

echo "Reputation list has been updated to $reputation_file"

