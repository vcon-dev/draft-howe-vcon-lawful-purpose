# Voice Conversation (vCon) Consent Attachment - IETF Draft

This repository contains the Internet-Draft for the Voice Conversation (vCon) Consent Attachment specification.

## Overview

This document defines a consent attachment type for Voice Conversations (vCon), establishing standardized mechanisms for recording, verifying, and managing consent information within conversation containers. The consent attachment addresses privacy compliance challenges through structured metadata including consenting parties, temporal validity periods, and cryptographic proof mechanisms.

## Quick Start

### Prerequisites

The following tools are required to work with this IETF draft:

- **kramdown-rfc2629**: Converts markdown to RFC XML format
- **xml2rfc**: Converts RFC XML to various output formats

### Installation

On macOS with Homebrew:

```bash
# Install kramdown-rfc2629 (Ruby gem)
gem install kramdown-rfc2629

# Install xml2rfc
brew install xml2rfc
```

### Building the Draft

#### Using Make

```bash
# Build all formats (txt, html, pdf)
make build

# Build specific format
make draft-howe-vcon-consent-00.txt
make draft-howe-vcon-consent-00.html
make draft-howe-vcon-consent-00.pdf

# Validate the XML
make validate

# Clean generated files
make clean

# Show help
make help
```

#### Using the Build Script

```bash
# Build all formats with validation
./scripts/build.sh build

# Validate only
./scripts/build.sh validate

# Check for common issues
./scripts/build.sh check

# Clean generated files
./scripts/build.sh clean

# Show help
./scripts/build.sh help
```

### Available Commands

| Command | Description |
|---------|-------------|
| `make build` | Build all output formats |
| `make validate` | Validate the XML source |
| `make clean` | Remove generated files |
| `make check` | Check for common issues |
| `make help` | Show available commands |
| `make bump-version` | Increment draft version |

## File Structure

```
.
├── draft-howe-vcon-consent-00.md    # Main markdown source
├── draft-howe-vcon-consent-00.xml   # Generated XML (gitignored)
├── draft-howe-vcon-consent-00.txt   # Generated text format (gitignored)
├── draft-howe-vcon-consent-00.html  # Generated HTML format (gitignored)
├── draft-howe-vcon-consent-00.pdf   # Generated PDF format (gitignored)
├── Makefile                         # Build automation
├── scripts/
│   └── build.sh                     # Enhanced build script
├── .github/
│   └── workflows/                   # GitHub Actions
└── README.md                        # This file
```

## Development Workflow

1. **Edit the markdown source**: Modify `draft-howe-vcon-consent-00.md`
2. **Build and validate**: Run `make build` or `./scripts/build.sh build`
3. **Check for issues**: Run `make check` or `./scripts/build.sh check`
4. **Review output**: Check the generated files in your preferred format
5. **Commit changes**: Add the markdown source to git (generated files are ignored)

## Version Management

To create a new version of the draft:

```bash
make bump-version
```

This will prompt you for the new version number and update the filename accordingly.

## Validation

The build process includes several validation steps:

- **Markdown structure**: Checks for YAML front matter and main heading
- **XML validation**: Uses xml2rfc to validate the generated XML
- **Common issues**: Checks for TODO, FIXME, and unresolved references

## GitHub Actions

This repository includes GitHub Actions workflows for:

- **Automatic building**: Builds all formats on push
- **Validation**: Validates the draft on pull requests
- **Publishing**: Publishes to GitHub Pages

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes to the markdown source
4. Build and validate your changes
5. Submit a pull request

## References

- [IETF Internet-Draft Guidelines](https://www.ietf.org/standards/ids/)
- [RFC 7991: The "xml2rfc" Version 3 Vocabulary](https://tools.ietf.org/html/rfc7991)
- [kramdown-rfc2629 Documentation](https://github.com/cabo/kramdown-rfc2629)

## License

This work is licensed under the IETF Trust Legal Provisions (TLP).
