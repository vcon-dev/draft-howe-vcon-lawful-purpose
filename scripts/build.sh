#!/bin/bash

# IETF Draft Build Script
# This script provides additional functionality for building and validating IETF drafts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DRAFT_NAME="draft-howe-vcon-consent"
DRAFT_VERSION="00"
MD_SOURCE="${DRAFT_NAME}-${DRAFT_VERSION}.md"

# Functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    print_info "Checking dependencies..."
    
    if ! command -v kramdown-rfc2629 &> /dev/null; then
        print_error "kramdown-rfc2629 is not installed"
        exit 1
    fi
    
    if ! command -v xml2rfc &> /dev/null; then
        print_error "xml2rfc is not installed"
        exit 1
    fi
    
    print_success "All dependencies are available"
}

validate_markdown() {
    print_info "Validating markdown source..."
    
    if [ ! -f "$MD_SOURCE" ]; then
        print_error "Source file $MD_SOURCE not found"
        exit 1
    fi
    
    # Check for basic markdown structure
    if ! grep -q "^---" "$MD_SOURCE"; then
        print_warning "No YAML front matter found"
    fi
    
    if ! grep -q "^# " "$MD_SOURCE"; then
        print_warning "No main heading found"
    fi
    
    print_success "Markdown validation completed"
}

build_xml() {
    print_info "Building XML from markdown..."
    kramdown-rfc2629 "$MD_SOURCE" -o "${DRAFT_NAME}-${DRAFT_VERSION}.xml"
    print_success "XML built successfully"
}

validate_xml() {
    print_info "Validating XML..."
    xml2rfc --check "${DRAFT_NAME}-${DRAFT_VERSION}.xml"
    print_success "XML validation completed"
}

build_formats() {
    print_info "Building output formats..."
    
    # Build text format
    print_info "Building text format..."
    kramdown-rfc2629 "$MD_SOURCE" | xml2rfc --text -o "${DRAFT_NAME}-${DRAFT_VERSION}.txt" -
    
    # Build HTML format
    print_info "Building HTML format..."
    kramdown-rfc2629 "$MD_SOURCE" | xml2rfc --html -o "${DRAFT_NAME}-${DRAFT_VERSION}.html" -
    
    # Build PDF format
    print_info "Building PDF format..."
    kramdown-rfc2629 "$MD_SOURCE" | xml2rfc --pdf -o "${DRAFT_NAME}-${DRAFT_VERSION}.pdf" -
    
    print_success "All formats built successfully"
}

check_issues() {
    print_info "Checking for common issues..."
    
    # Check for TODO items
    if grep -q "TODO" "$MD_SOURCE"; then
        print_warning "Found TODO items:"
        grep -n "TODO" "$MD_SOURCE"
    fi
    
    # Check for FIXME items
    if grep -q "FIXME" "$MD_SOURCE"; then
        print_warning "Found FIXME items:"
        grep -n "FIXME" "$MD_SOURCE"
    fi
    
    # Check for unresolved references
    if grep -q "RFC[0-9]*" "$MD_SOURCE"; then
        print_info "Found RFC references:"
        grep -n "RFC[0-9]*" "$MD_SOURCE" | grep -v "RFC2119\|RFC3339\|RFC8174\|RFC8949" || print_info "All RFC references appear to be resolved"
    fi
}

clean() {
    print_info "Cleaning generated files..."
    rm -f "${DRAFT_NAME}-${DRAFT_VERSION}.txt"
    rm -f "${DRAFT_NAME}-${DRAFT_VERSION}.html"
    rm -f "${DRAFT_NAME}-${DRAFT_VERSION}.pdf"
    rm -f "${DRAFT_NAME}-${DRAFT_VERSION}.xml"
    print_success "Cleanup completed"
}

show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  build     Build all output formats (default)"
    echo "  validate  Validate the source and XML"
    echo "  clean     Remove generated files"
    echo "  check     Check for common issues"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build     # Build all formats"
    echo "  $0 validate  # Validate source and XML"
    echo "  $0 clean     # Clean generated files"
}

# Main script logic
case "${1:-build}" in
    "build")
        check_dependencies
        validate_markdown
        build_xml
        validate_xml
        build_formats
        check_issues
        print_success "Build completed successfully"
        ;;
    "validate")
        check_dependencies
        validate_markdown
        build_xml
        validate_xml
        print_success "Validation completed"
        ;;
    "clean")
        clean
        ;;
    "check")
        check_issues
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac 