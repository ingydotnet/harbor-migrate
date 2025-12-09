# Harbor Helm Chart Migration Tool - YAMLScript Refactoring

A project to refactor a Harbor Helm chart migration tool into idiomatic, clean YAMLScript code.

## Overview

This repository contains a YAMLScript implementation of a Harbor registry configuration migration tool. The goal is to refactor the code to be more idiomatic, maintainable, and serve as a showcase of clean YAMLScript practices.

The tool migrates Harbor registry configuration files from legacy Helm chart formats to the newer chart structure, handling schema changes, deprecated features, and providing detailed migration reports.

## Features

- **Automated Migration**: Converts legacy `values.yaml` files to the new chart format
- **Comprehensive Validation**: Detects deprecated and unsupported features
- **Detailed Reporting**: Provides categorized migration reports (Errors, Warnings, Info)
- **Component Mapping**: Handles all Harbor components:
  - Core
  - Portal
  - Registry
  - Jobservice
  - Exporter
  - Trivy scanner
  - Metrics/ServiceMonitor
- **Configuration Migration**:
  - Database (external PostgreSQL required)
  - Redis/Valkey
  - Storage (filesystem, S3, etc.)
  - Ingress and TLS
  - Images and resource specifications

## Prerequisites

- GNU Make

The Makefile automatically installs YAMLScript if not present. To run the script directly without Make, install [YAMLScript](https://yamlscript.org/) manually.

## Installation

```bash
git clone <repository-url>
cd harbor-migrate
```

## Usage

### Basic Usage

```bash
ys harbor-migrate.ys <input-values.yaml> [output-values.yaml]
```

The tool writes:
- **Migrated YAML** to stdout (or specified output file)
- **Migration report** to stderr

### Examples

**Output to stdout:**
```bash
ys harbor-migrate.ys values-original.yaml
```

**Write to a file:**
```bash
ys harbor-migrate.ys values-original.yaml values-new.yaml
```

**Separate migrated values and error report:**
```bash
ys harbor-migrate.ys values-original.yaml > values-new.yaml 2> migration-report.txt
```

**Using Make:**
```bash
make test
```

This will migrate `values-original.yaml` to `values-new.yaml` and capture the migration report in `migrate-errors.txt`, then compare against the expected outputs.

## Migration Report

The tool generates a detailed migration report with three severity levels:

- **ERROR**: Requires manual intervention before deployment
- **WARNING**: Should be reviewed and may need configuration changes
- **INFO**: Successfully migrated but review recommended

Example output:
```
=== Migration Report ===
Errors: 1 Warnings: 2 Info: 1
[ERROR] database.type: Internal database is not supported.
  Action: Deploy external PostgreSQL
[WARNING] expose.tls.certSource: certSource='auto' is not supported.
  Action: Configure tls.certManager
[WARNING] trivy: Trivy is now a subchart.
  Action: Configure under trivy.*
[INFO] redis.type: Internal Redis migrated to Valkey subchart
  Action: Review valkey.* settings
```

## Known Migration Issues

### Errors (Require Action)

- **Internal Database**: Not supported in new chart - deploy external PostgreSQL
- **Notary**: Deprecated - migrate to Sigstore/cosign
- **ChartMuseum**: Deprecated - use OCI artifact support

### Warnings (Review Recommended)

- **Auto TLS Certificates**: `certSource='auto'` not supported - configure `tls.certManager`
- **Trivy Configuration**: Now a subchart - move settings under `trivy.*`
- **Internal TLS**: Not implemented - consider service mesh
- **Non-Ingress Expose Types**: Only ingress type is supported

### Info (Review Settings)

- **Redis to Valkey**: Internal Redis migrated to Valkey subchart - review `valkey.*` settings

## Project Structure

```
.
├── harbor-migrate.ys       # Main migration script
├── Makefile                # Build and test targets
├── values-original.yaml    # Example input file
├── values-migrated.yaml    # Expected output for testing
├── migrated-errors.txt     # Migration report output
└── README.md               # This file
```

## Development

### Running Tests

```bash
make test
```

This compares the output of migrating `values-original.yaml` against the expected `values-migrated.yaml`.

### Cleaning Build Artifacts

```bash
make clean
```

## How It Works

The migration script:

1. Loads the legacy values YAML file
2. Maps configuration to new schema:
   - Direct field mappings (external URL, admin password, etc.)
   - Ingress configuration with TLS
   - Storage and persistence settings
   - Database configuration (validates external DB)
   - Redis/Valkey migration
   - Component-specific settings (core, portal, registry, etc.)
3. Detects deprecated/unsupported features
4. Generates migration warnings and errors
5. Outputs cleaned configuration (removes nil values)
6. Displays migration report

## Refactoring Goals

This project aims to improve the YAMLScript implementation with:

- **Idiomatic YAMLScript**: Use YAMLScript best practices and conventions
- **Code Clarity**: Improve readability and maintainability
- **Better Organization**: Logical grouping of related functions
- **Consistent Naming**: Follow YAMLScript naming conventions
- **Documentation**: Add comments for complex logic
- **Error Handling**: Robust validation and error messages
- **Testability**: Structure code for easier testing

### Current Status

The migration tool is functional and includes:
- Complete migration logic for all Harbor components
- Validation and warning system
- Test suite with example files

### Refactoring Opportunities

Areas for improvement:
- Function naming consistency (kebab-case vs camelCase)
- Code organization and modularization
- Documentation and inline comments
- Error handling patterns
- Data transformation patterns
- Testing coverage

## Contributing

Contributions are welcome! Areas to focus on:
- Refactoring functions to be more idiomatic
- Improving code organization
- Adding documentation
- Expanding test coverage

Please ensure tests pass before submitting pull requests:
```bash
make test
```

## License

[Add your license information here]

## Support

For issues or questions about:
- Harbor registry: Visit [Harbor documentation](https://goharbor.io/docs/)
- YAMLScript: Visit [YAMLScript documentation](https://yamlscript.org/)
- This migration tool: [Open an issue]
