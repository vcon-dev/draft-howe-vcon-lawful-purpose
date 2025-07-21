#!/bin/bash

# IETF Draft Development Environment Setup Script
# This script helps set up the development environment for IETF drafts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

check_os() {
    print_info "Detecting operating system..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_success "Detected macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        print_success "Detected Linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        print_success "Detected Windows"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

check_dependencies() {
    print_info "Checking for required dependencies..."

    local missing_deps=()

    # Check for kramdown-rfc2629
    if ! command -v kramdown-rfc2629 &> /dev/null; then
        missing_deps+=("kramdown-rfc2629")
    else
        print_success "kramdown-rfc2629 is installed"
    fi

    # Check for xml2rfc
    if ! command -v xml2rfc &> /dev/null; then
        missing_deps+=("xml2rfc")
    else
        print_success "xml2rfc is installed"
    fi

    # Check for git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    else
        print_success "git is installed"
    fi

    # Check for make
    if ! command -v make &> /dev/null; then
        missing_deps+=("make")
    else
        print_success "make is installed"
    fi

    if [ ${#missing_deps[@]} -eq 0 ]; then
        print_success "All dependencies are available"
        return 0
    else
        print_warning "Missing dependencies: ${missing_deps[*]}"
        return 1
    fi
}

install_dependencies() {
    print_info "Installing missing dependencies..."

    case $OS in
        "macos")
            install_dependencies_macos
            ;;
        "linux")
            install_dependencies_linux
            ;;
        "windows")
            install_dependencies_windows
            ;;
    esac
}

install_dependencies_macos() {
    print_info "Installing dependencies on macOS..."

    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed. Please install it first:"
        print_info "Visit: https://brew.sh"
        exit 1
    fi

    # Install xml2rfc
    if ! command -v xml2rfc &> /dev/null; then
        print_info "Installing xml2rfc..."
        brew install xml2rfc
    fi

    # Install kramdown-rfc2629
    if ! command -v kramdown-rfc2629 &> /dev/null; then
        print_info "Installing kramdown-rfc2629..."
        gem install kramdown-rfc2629
    fi
}

install_dependencies_linux() {
    print_info "Installing dependencies on Linux..."

    # Detect package manager
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
    else
        print_error "Unsupported package manager. Please install dependencies manually."
        exit 1
    fi

    # Install xml2rfc
    if ! command -v xml2rfc &> /dev/null; then
        print_info "Installing xml2rfc..."
        case $PKG_MANAGER in
            "apt")
                sudo apt-get update && sudo apt-get install -y xml2rfc
                ;;
            "yum"|"dnf")
                sudo $PKG_MANAGER install -y xml2rfc
                ;;
        esac
    fi

    # Install kramdown-rfc2629
    if ! command -v kramdown-rfc2629 &> /dev/null; then
        print_info "Installing kramdown-rfc2629..."
        gem install kramdown-rfc2629
    fi
}

install_dependencies_windows() {
    print_info "Installing dependencies on Windows..."

    print_warning "Windows installation requires manual setup:"
    print_info "1. Install Python and pip"
    print_info "2. Run: pip install xml2rfc"
    print_info "3. Install Ruby and gem"
    print_info "4. Run: gem install kramdown-rfc2629"
    print_info "5. Install Git for Windows"
    print_info "6. Install Make for Windows"
}

setup_git_hooks() {
    print_info "Setting up Git hooks..."

    if [ ! -d ".git" ]; then
        print_warning "Not a Git repository. Skipping Git hooks setup."
        return
    fi

    # Create pre-commit hook
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for IETF draft validation

echo "Running pre-commit validation..."

# Run validation script
if [ -f "scripts/validate.sh" ]; then
    ./scripts/validate.sh
    if [ $? -ne 0 ]; then
        echo "Validation failed. Please fix issues before committing."
        exit 1
    fi
fi

echo "Pre-commit validation passed."
EOF

    chmod +x .git/hooks/pre-commit
    print_success "Git pre-commit hook installed"
}

test_build() {
    print_info "Testing build process..."

    # Clean any existing generated files
    make clean 2>/dev/null || true

    # Try to build text and HTML formats only
    if make draft-howe-vcon-consent-00.txt draft-howe-vcon-consent-00.html; then
        print_success "Build test passed (text and HTML formats)"
        print_info "Note: PDF generation requires additional dependencies (WeasyPrint)"
    else
        print_error "Build test failed"
        return 1
    fi
}

show_next_steps() {
    print_success "Setup completed successfully!"
    echo ""
    print_info "Next steps:"
    echo "1. Edit the markdown source: draft-howe-vcon-consent-00.md"
    echo "2. Build the draft: make build"
    echo "3. Validate the draft: ./scripts/validate.sh"
    echo "4. Check for issues: ./scripts/build.sh check"
    echo ""
    print_info "Available commands:"
    echo "  make build     - Build all output formats"
    echo "  make validate  - Validate the XML source"
    echo "  make clean     - Remove generated files"
    echo "  make help      - Show all available commands"
    echo ""
    print_info "For more information, see README.md"
}

# Main setup function
main() {
    print_info "Setting up IETF draft development environment..."

    check_os

    if ! check_dependencies; then
        print_info "Installing missing dependencies..."
        install_dependencies

        # Check again after installation
        if ! check_dependencies; then
            print_error "Failed to install all dependencies"
            exit 1
        fi
    fi

    setup_git_hooks

    if test_build; then
        show_next_steps
    else
        print_error "Setup completed but build test failed"
        print_info "Please check the error messages above"
        exit 1
    fi
}

# Run main function
main "$@"
