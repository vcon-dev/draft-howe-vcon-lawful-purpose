#!/bin/bash

# IETF Draft Validation Script
# This script performs comprehensive validation of IETF drafts

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

validate_front_matter() {
    print_info "Validating YAML front matter..."
    
    # Check for required fields
    local required_fields=("title" "abbrev" "category" "docname" "date" "consensus" "area" "workgroup")
    
    for field in "${required_fields[@]}"; do
        if ! grep -q "^${field}:" "$MD_SOURCE"; then
            print_error "Missing required field: $field"
            return 1
        fi
    done
    
    print_success "Front matter validation passed"
}

validate_references() {
    print_info "Validating references..."
    
    # Check for normative references
    if ! grep -q "normative:" "$MD_SOURCE"; then
        print_warning "No normative references section found"
    fi
    
    # Check for informative references
    if ! grep -q "informative:" "$MD_SOURCE"; then
        print_warning "No informative references section found"
    fi
    
    # Check for backmatter
    if ! grep -q "{backmatter}" "$MD_SOURCE"; then
        print_warning "No backmatter section found"
    fi
    
    print_success "References validation completed"
}

validate_structure() {
    print_info "Validating document structure..."
    
    # Check for main heading
    if ! grep -q "^# " "$MD_SOURCE"; then
        print_error "No main heading found"
        return 1
    fi
    
    # Check for abstract
    if ! grep -q "^## Abstract" "$MD_SOURCE"; then
        print_warning "No abstract section found"
    fi
    
    # Check for introduction
    if ! grep -q "^## 1. Introduction" "$MD_SOURCE"; then
        print_warning "No introduction section found"
    fi
    
    print_success "Structure validation completed"
}

validate_terminology() {
    print_info "Validating terminology..."
    
    # Check for terminology section
    if ! grep -q "^## .*Terminology" "$MD_SOURCE"; then
        print_warning "No terminology section found"
    fi
    
    # Check for RFC 2119 keywords
    local rfc2119_keywords=("MUST" "MUST NOT" "REQUIRED" "SHALL" "SHALL NOT" "SHOULD" "SHOULD NOT" "RECOMMENDED" "NOT RECOMMENDED" "MAY" "OPTIONAL")
    
    for keyword in "${rfc2119_keywords[@]}"; do
        if grep -q "$keyword" "$MD_SOURCE"; then
            print_info "Found RFC 2119 keyword: $keyword"
        fi
    done
    
    print_success "Terminology validation completed"
}

validate_security() {
    print_info "Validating security considerations..."
    
    # Check for security considerations section
    if ! grep -q "^## .*Security Considerations" "$MD_SOURCE"; then
        print_warning "No security considerations section found"
    fi
    
    print_success "Security validation completed"
}

validate_iana() {
    print_info "Validating IANA considerations..."
    
    # Check for IANA considerations section
    if ! grep -q "^## .*IANA Considerations" "$MD_SOURCE"; then
        print_warning "No IANA considerations section found"
    fi
    
    print_success "IANA validation completed"
}

validate_formatting() {
    print_info "Validating formatting..."
    
    # Check for proper line endings
    if file "$MD_SOURCE" | grep -q "CRLF"; then
        print_warning "File contains Windows line endings (CRLF)"
    fi
    
    # Check for trailing whitespace
    if grep -n " $" "$MD_SOURCE"; then
        print_warning "Found trailing whitespace"
    fi
    
    # Check for proper heading levels
    local heading_errors=0
    while IFS= read -r line; do
        if [[ $line =~ ^#{3,} ]]; then
            print_warning "Deep heading level found: $line"
            ((heading_errors++))
        fi
    done < <(grep "^#" "$MD_SOURCE")
    
    if [ $heading_errors -eq 0 ]; then
        print_success "Heading levels are appropriate"
    fi
    
    print_success "Formatting validation completed"
}

validate_content() {
    print_info "Validating content..."
    
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
    
    print_success "Content validation completed"
}

# Main validation function
main() {
    print_info "Starting comprehensive validation of $MD_SOURCE"
    
    if [ ! -f "$MD_SOURCE" ]; then
        print_error "Source file $MD_SOURCE not found"
        exit 1
    fi
    
    local errors=0
    
    # Run all validation functions
    validate_front_matter || ((errors++))
    validate_references || ((errors++))
    validate_structure || ((errors++))
    validate_terminology || ((errors++))
    validate_security || ((errors++))
    validate_iana || ((errors++))
    validate_formatting || ((errors++))
    validate_content || ((errors++))
    
    print_info "Validation completed with $errors error(s)"
    
    if [ $errors -eq 0 ]; then
        print_success "All validations passed!"
        exit 0
    else
        print_error "Validation failed with $errors error(s)"
        exit 1
    fi
}

# Run main function
main "$@" 