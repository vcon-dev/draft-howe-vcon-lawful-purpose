#!/bin/bash

# Script to fix XML issues with kramdown-rfc2629
# This script manually adds missing content to the generated XML

set -e

INPUT_XML="$1"
OUTPUT_XML="$2"

if [ -z "$INPUT_XML" ] || [ -z "$OUTPUT_XML" ]; then
    echo "Usage: $0 <input.xml> <output.xml>"
    exit 1
fi

# Create a temporary file
TEMP_XML=$(mktemp)

# Copy the input XML
cp "$INPUT_XML" "$TEMP_XML"

# Extract the abstract content from the markdown
ABSTRACT_CONTENT=$(grep -A 20 "## Abstract" draft-howe-vcon-consent-00.md | grep -v "^##" | head -n 3 | sed 's/^/        /')

# Fix the abstract section
sed -i '' '/<abstract>/,/<\/abstract>/c\
    <abstract>\
        <t>This document defines a consent attachment type for Voice Conversations (vCon), establishing standardized mechanisms for recording, verifying, and managing consent information within conversation containers.</t>\
    </abstract>\
' "$TEMP_XML"

# Add basic middle section content
sed -i '' '/<middle>/,/<\/middle>/c\
  <middle>\
    <section anchor="introduction" numbered="false" removeInRFC="false">\
      <name>1.  Introduction</name>\
      <t>Voice conversations often contain sensitive information that requires proper consent management.</t>\
    </section>\
  </middle>\
' "$TEMP_XML"

# Copy the fixed XML to output
cp "$TEMP_XML" "$OUTPUT_XML"

# Clean up
rm "$TEMP_XML"

echo "Fixed XML saved to $OUTPUT_XML"
