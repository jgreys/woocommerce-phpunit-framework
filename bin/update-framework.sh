#!/usr/bin/env bash
set -euo pipefail

# Update framework files from WooCommerce repository
# Usage: ./update-framework.sh [TAG] [VERSION]
#   TAG: WooCommerce git tag (e.g., 9.0.0, trunk)
#   VERSION: Target version directory (e.g., 5.0, or 'src' for current)
#
# Examples:
#   ./update-framework.sh 9.0.0        # Update src/ from WC 9.0.0
#   ./update-framework.sh trunk        # Update src/ from WC trunk
#   ./update-framework.sh 9.0.0 5.0    # Update versions/5.0/ from WC 9.0.0

TAG="${1:-trunk}"
VERSION="${2:-src}"
REMOTE_URL=${WC_REMOTE_URL:-"https://github.com/woocommerce/woocommerce.git"}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORK_DIR="${ROOT_DIR}/.tmp-wc"

# Determine target directory
if [ "$VERSION" = "src" ]; then
    TARGET_DIR="${ROOT_DIR}/src"
else
    TARGET_DIR="${ROOT_DIR}/versions/${VERSION}/src"
fi

echo "Updating framework to WooCommerce ${TAG}"
echo "Target: ${TARGET_DIR}"

# Create work directory
rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}"

# Clone WooCommerce at specific tag
echo "Cloning WooCommerce repository..."
if [ "${TAG}" = "trunk" ]; then
    git clone --depth=1 "${REMOTE_URL}" "${WORK_DIR}"
else
    git clone --depth=1 --branch "${TAG}" "${REMOTE_URL}" "${WORK_DIR}"
fi

# Determine source paths based on what exists in this version
FRAMEWORK_PATH=""
INCLUDES_PATH=""
TOOLS_PATH=""

if [ -d "${WORK_DIR}/plugins/woocommerce/tests/legacy/framework" ]; then
    FRAMEWORK_PATH="${WORK_DIR}/plugins/woocommerce/tests/legacy/framework"
    INCLUDES_PATH="${WORK_DIR}/plugins/woocommerce/tests/legacy/includes"
    TOOLS_PATH="${WORK_DIR}/plugins/woocommerce/tests/Tools"
elif [ -d "${WORK_DIR}/tests/legacy/framework" ]; then
    FRAMEWORK_PATH="${WORK_DIR}/tests/legacy/framework"
    INCLUDES_PATH="${WORK_DIR}/tests/legacy/includes"
    TOOLS_PATH="${WORK_DIR}/tests/Tools"
elif [ -d "${WORK_DIR}/tests/framework" ]; then
    FRAMEWORK_PATH="${WORK_DIR}/tests/framework"
    INCLUDES_PATH="${WORK_DIR}/tests/includes"
    TOOLS_PATH="${WORK_DIR}/tests/Tools"
else
    echo "Error: Could not find framework directory in WooCommerce ${TAG}"
    rm -rf "${WORK_DIR}"
    exit 1
fi

echo "Source framework: ${FRAMEWORK_PATH}"
if [ -d "${INCLUDES_PATH}" ]; then
    echo "Source includes: ${INCLUDES_PATH}"
fi
if [ -d "${TOOLS_PATH}" ]; then
    echo "Source tools: ${TOOLS_PATH}"
fi

# Sync framework files
mkdir -p "${TARGET_DIR}"
rsync -a --delete "${FRAMEWORK_PATH}/" "${TARGET_DIR}/"

# Sync includes files if they exist
if [ -d "${INCLUDES_PATH}" ]; then
    mkdir -p "${TARGET_DIR}/includes"
    rsync -a "${INCLUDES_PATH}/" "${TARGET_DIR}/includes/"
fi

# Sync Tools files if they exist
if [ -d "${TOOLS_PATH}" ]; then
    mkdir -p "${TARGET_DIR}/Tools"
    rsync -a "${TOOLS_PATH}/" "${TARGET_DIR}/Tools/"
fi

# Clean up
rm -rf "${WORK_DIR}"

# Count files
FILE_COUNT=$(find "${TARGET_DIR}" -name "*.php" | wc -l | tr -d ' ')
echo ""
echo "✓ Successfully synced ${FILE_COUNT} framework files"
echo "✓ WooCommerce ${TAG} → ${TARGET_DIR}"
