# Makefile for IETF Draft Management
# This Makefile provides common tasks for working with IETF drafts

# Draft name (without version)
DRAFT_NAME = draft-howe-vcon-consent
DRAFT_VERSION = 00

# Source files
MD_SOURCE = $(DRAFT_NAME)-$(DRAFT_VERSION).md
XML_SOURCE = $(DRAFT_NAME)-$(DRAFT_VERSION).xml

# Output files
PDF_OUTPUT = $(DRAFT_NAME)-$(DRAFT_VERSION).pdf
TXT_OUTPUT = $(DRAFT_NAME)-$(DRAFT_VERSION).txt
HTML_OUTPUT = $(DRAFT_NAME)-$(DRAFT_VERSION).html

# Default target
.PHONY: all
all: build

# Build all formats
.PHONY: build
build: $(TXT_OUTPUT) $(HTML_OUTPUT) $(PDF_OUTPUT)

# Build text format from markdown
$(TXT_OUTPUT): $(MD_SOURCE)
	kramdown-rfc2629 $(MD_SOURCE) > temp.xml && ./scripts/fix-xml.sh temp.xml fixed.xml && xml2rfc --text -o $(TXT_OUTPUT) fixed.xml && rm temp.xml fixed.xml

# Build HTML format from markdown
$(HTML_OUTPUT): $(MD_SOURCE)
	kramdown-rfc2629 $(MD_SOURCE) > temp.xml && ./scripts/fix-xml.sh temp.xml fixed.xml && xml2rfc --html -o $(HTML_OUTPUT) fixed.xml && rm temp.xml fixed.xml

# Build PDF format from markdown
$(PDF_OUTPUT): $(MD_SOURCE)
	kramdown-rfc2629 $(MD_SOURCE) > temp.xml && ./scripts/fix-xml.sh temp.xml fixed.xml && xml2rfc --pdf -o $(PDF_OUTPUT) fixed.xml && rm temp.xml fixed.xml

# Build XML from markdown
$(XML_SOURCE): $(MD_SOURCE)
	kramdown-rfc2629 $(MD_SOURCE) -o $(XML_SOURCE)

# Validate XML
.PHONY: validate
validate: $(XML_SOURCE)
	xml2rfc --check $(XML_SOURCE)

# Clean generated files
.PHONY: clean
clean:
	rm -f $(TXT_OUTPUT) $(HTML_OUTPUT) $(PDF_OUTPUT) $(XML_SOURCE)

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build     - Build all output formats (txt, html, pdf)"
	@echo "  validate  - Validate the XML source"
	@echo "  clean     - Remove generated files"
	@echo "  help      - Show this help message"
	@echo ""
	@echo "Individual targets:"
	@echo "  $(TXT_OUTPUT)  - Build text format"
	@echo "  $(HTML_OUTPUT) - Build HTML format"
	@echo "  $(PDF_OUTPUT)  - Build PDF format"
	@echo "  $(XML_SOURCE)  - Build XML format"

# Increment version
.PHONY: bump-version
bump-version:
	@echo "Current version: $(DRAFT_VERSION)"
	@echo "Enter new version (e.g., 01): " && read version && \
	sed -i '' 's/$(DRAFT_VERSION)/$$version/g' $(MD_SOURCE) && \
	mv $(MD_SOURCE) $(DRAFT_NAME)-$$version.md && \
	echo "Version bumped to $$version"

# Check for common issues
.PHONY: check
check:
	@echo "Checking for common issues..."
	@echo "1. Checking for TODO items..."
	@grep -n "TODO" $(MD_SOURCE) || echo "No TODO items found"
	@echo "2. Checking for FIXME items..."
	@grep -n "FIXME" $(MD_SOURCE) || echo "No FIXME items found"
	@echo "3. Checking for unresolved references..."
	@grep -n "RFC[0-9]*" $(MD_SOURCE) | grep -v "RFC2119\|RFC3339\|RFC8174\|RFC8949" || echo "No unresolved RFC references found"
