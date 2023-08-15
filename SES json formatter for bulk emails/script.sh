#!/bin/bash

# Read email addresses from the text file
email_list=$(cat emails.txt)

# Loop through the list of email addresses and create JSON files
for email in $email_list; do
    json_filename="result.json"
    
    # Create JSON data
    json_data="{\"email\": \"$email\",\"reason\":\"BOUNCE\"}"

    # Write JSON data to the JSON file
    echo "$json_data" >> "$json_filename"

    echo "JSON file created for: $email"
done

echo "JSON creation process completed."
