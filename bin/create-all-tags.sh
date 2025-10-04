#!/usr/bin/env bash
set -euo pipefail

# Create all version tags for the package
# This script helps you create git tags for each framework version
# Each tag will have the src/ directory populated with the appropriate files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
MAPPING_FILE="${ROOT_DIR}/versions.json"

echo "=== WooCommerce PHPUnit Framework - Tag Creator ==="
echo ""
echo "This script will help you create git tags for each framework version."
echo "For each version, you'll need to:"
echo "  1. Extract the framework files to src/"
echo "  2. Commit the changes"
echo "  3. Create a git tag"
echo ""
echo "Press Ctrl+C at any time to stop."
echo ""

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Install it first:"
    echo "  macOS: brew install jq"
    echo "  Ubuntu: sudo apt-get install jq"
    exit 1
fi

# Get versions
VERSIONS=$(jq -r '.versions | keys[]' "${MAPPING_FILE}")

for VERSION in ${VERSIONS}; do
    echo "========================================="
    echo "Framework Version ${VERSION}"
    echo "========================================="

    # Get metadata
    WC_VERSIONS=$(jq -r ".versions[\"${VERSION}\"].wc_versions" "${MAPPING_FILE}")
    REFERENCE_TAG=$(jq -r ".versions[\"${VERSION}\"].reference_tag" "${MAPPING_FILE}")

    echo "WooCommerce: ${WC_VERSIONS}"
    echo "Reference: ${REFERENCE_TAG}"
    echo ""

    # Ask if user wants to create this version
    read -p "Create version ${VERSION}? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping version ${VERSION}"
        echo ""
        continue
    fi

    # Extract files
    echo "Extracting files for version ${VERSION}..."
    ./bin/update-framework.sh "${REFERENCE_TAG}"

    # Update composer.json description
    jq ".description = \"WooCommerce PHPUnit Framework v${VERSION} - Compatible with WooCommerce ${WC_VERSIONS}\" | .extra = {\"woocommerce-versions\": \"${WC_VERSIONS}\", \"framework-version\": \"${VERSION}\", \"extracted-from\": \"${REFERENCE_TAG}\"}" \
        composer.json > composer.json.tmp && mv composer.json.tmp composer.json

    echo ""
    echo "Files extracted to src/"
    echo "Review the files, then we'll commit and tag."
    echo ""
    read -p "Ready to commit and tag? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping commit/tag for version ${VERSION}"
        echo "You can do it manually later:"
        echo "  git add ."
        echo "  git commit -m 'feat: Framework v${VERSION} for WooCommerce ${WC_VERSIONS}'"
        echo "  git tag -a ${VERSION}.0 -m 'Release ${VERSION}.0 - WooCommerce ${WC_VERSIONS}'"
        echo ""
        continue
    fi

    # Commit only essential files (exclude bin/, .github/, and other non-essential files)
    git add src/ composer.json LICENSE README.md USAGE.md VERSIONS.md versions.json .gitignore
    git commit -m "feat: Framework v${VERSION} for WooCommerce ${WC_VERSIONS}

- Extracted from WooCommerce ${REFERENCE_TAG}
- Compatible with WooCommerce ${WC_VERSIONS}
- Includes $(find src -name '*.php' | wc -l | tr -d ' ') framework files"

    # Tag
    git tag -a "${VERSION}.0" -m "Release ${VERSION}.0 - WooCommerce ${WC_VERSIONS}

Framework version ${VERSION} extracted from WooCommerce ${REFERENCE_TAG}
Compatible with WooCommerce versions ${WC_VERSIONS}

This release provides the WooCommerce PHPUnit testing framework including:
- Base test case classes (WC_Unit_Test_Case, WC_REST_Unit_Test_Case, etc.)
- Helper classes for creating test data
- Mock classes for testing
- All necessary traits and utilities"

    echo "✓ Created commit and tag ${VERSION}.0"
    echo ""
done

echo "========================================="
echo "Summary"
echo "========================================="
echo "Created tags:"
git tag -l "*.0.0"
echo ""
echo "To push all tags to GitHub:"
echo "  git push origin --tags"
echo ""
echo "After pushing, GitHub Actions will create releases automatically!"
