#!/bin/bash
# =============================================================================
# Export Obsidian notes for Claude Projects Knowledge Base
# =============================================================================
# Usage: ./scripts/export-for-claude.sh [vault_path] [output_file]
#
# This script combines all markdown notes into a single file optimized for
# uploading to Claude Projects Knowledge Base.
# =============================================================================

set -e

# Configuration
VAULT_PATH="${1:-.}"
OUTPUT_FILE="${2:-_claude_export.md}"
MAX_FILE_SIZE_KB=500  # Skip files larger than this (likely not notes)
EXCLUDE_PATTERNS=(
    ".obsidian"
    ".git"
    ".trash"
    "_claude_export.md"
    "node_modules"
    ".DS_Store"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}📚 Obsidian → Claude Export${NC}"
echo "================================"
echo "Vault: $VAULT_PATH"
echo "Output: $OUTPUT_FILE"
echo ""

# Change to vault directory
cd "$VAULT_PATH"

# Build exclude pattern for find
EXCLUDE_ARGS=""
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    EXCLUDE_ARGS="$EXCLUDE_ARGS -path '*/$pattern' -prune -o -path '*/$pattern/*' -prune -o"
done

# Create output file with header
cat > "$OUTPUT_FILE" << 'HEADER'
# Obsidian Vault Export for Claude

This document contains all notes from the Obsidian vault, formatted for use
as a Claude Projects Knowledge Base.

**Export date:** EXPORT_DATE
**Total notes:** NOTE_COUNT

---

## Table of Contents

TOC_PLACEHOLDER

---

HEADER

# Replace export date
sed -i "s/EXPORT_DATE/$(date '+%Y-%m-%d %H:%M:%S')/" "$OUTPUT_FILE"

# Find all markdown files
echo -e "${YELLOW}🔍 Scanning for markdown files...${NC}"

# Create temporary file for TOC
TOC_FILE=$(mktemp)
CONTENT_FILE=$(mktemp)
NOTE_COUNT=0

# Find and process files
while IFS= read -r -d '' file; do
    # Skip if file is too large
    file_size=$(du -k "$file" | cut -f1)
    if [ "$file_size" -gt "$MAX_FILE_SIZE_KB" ]; then
        echo -e "${YELLOW}⏭️  Skipping large file: $file ($file_size KB)${NC}"
        continue
    fi

    # Get relative path
    rel_path="${file#./}"

    # Skip excluded patterns
    skip=false
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ "$rel_path" == *"$pattern"* ]]; then
            skip=true
            break
        fi
    done

    if [ "$skip" = true ]; then
        continue
    fi

    # Extract title (first H1 or filename)
    title=$(grep -m1 "^# " "$file" 2>/dev/null | sed 's/^# //' || basename "$file" .md)

    # Add to TOC
    echo "- [$title](#$(echo "$rel_path" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]'))" >> "$TOC_FILE"

    # Add content
    echo "" >> "$CONTENT_FILE"
    echo "---" >> "$CONTENT_FILE"
    echo "" >> "$CONTENT_FILE"
    echo "## 📄 $rel_path" >> "$CONTENT_FILE"
    echo "" >> "$CONTENT_FILE"
    cat "$file" >> "$CONTENT_FILE"
    echo "" >> "$CONTENT_FILE"

    NOTE_COUNT=$((NOTE_COUNT + 1))
    echo -e "${GREEN}✓${NC} $rel_path"

done < <(find . -name "*.md" -type f -print0 2>/dev/null)

# Replace placeholders in output
sed -i "s/NOTE_COUNT/$NOTE_COUNT/" "$OUTPUT_FILE"

# Insert TOC
if [ -s "$TOC_FILE" ]; then
    sed -i "/TOC_PLACEHOLDER/r $TOC_FILE" "$OUTPUT_FILE"
    sed -i "/TOC_PLACEHOLDER/d" "$OUTPUT_FILE"
else
    sed -i "s/TOC_PLACEHOLDER/(No notes found)/" "$OUTPUT_FILE"
fi

# Append content
cat "$CONTENT_FILE" >> "$OUTPUT_FILE"

# Cleanup
rm -f "$TOC_FILE" "$CONTENT_FILE"

# Final stats
OUTPUT_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)

echo ""
echo "================================"
echo -e "${GREEN}✅ Export complete!${NC}"
echo "   Notes exported: $NOTE_COUNT"
echo "   Output file: $OUTPUT_FILE"
echo "   File size: $OUTPUT_SIZE"
echo ""
echo -e "${YELLOW}📤 Next steps:${NC}"
echo "   1. Go to claude.ai → Projects"
echo "   2. Open your project (or create new)"
echo "   3. Click 'Add to project knowledge'"
echo "   4. Upload: $OUTPUT_FILE"
echo ""
