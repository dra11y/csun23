import json
import re

# Load the JSON file
with open('csun23.json', 'r') as f:
    data = json.load(f)

# Loop through each record and add the id attribute
for record in data:
    # Extract the integer at the end of the URL
    match = re.search(r'\d+$', record['url'])
    if match:
        id = int(match.group())
        # Add the id attribute to the record
        record['id'] = id


json_str = json.dumps(data, indent=2, separators=(",", ": "))
with open("csun23.json", "w") as f:
    # Write the JSON string to the file
    f.write(json_str)

