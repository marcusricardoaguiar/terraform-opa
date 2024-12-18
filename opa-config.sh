#!/bin/bash

# Read the Terraform plan into a variable
tfplan_content=$(cat tfplan.json)

# Create the input.json file with the wrapped "input" object
echo "{\"input\": $tfplan_content}" > input.json

echo "Wrapped tfplan.json into input.json"
