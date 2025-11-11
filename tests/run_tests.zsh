#!/bin/zsh

# Test runner for zsh-plugin-manager

set -e

# Set up test environment
export ZPLUGINDIR="$(mktemp -d)"
export TEST_DIR="$ZPLUGINDIR"

# Source the plugin
source ../zsh-plugin-manager.zsh

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

passed=0
failed=0

run_test() {
    local test_name="$1"
    local test_cmd="$2"
    echo -n "Running $test_name... "
    if eval "$test_cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        ((passed++))
    else
        echo -e "${RED}FAIL${NC}"
        ((failed++))
    fi
}

# Run individual tests
source test_help.zsh
source test_list.zsh
source test_install.zsh
source test_remove.zsh
source test_update.zsh
source test_source.zsh

# Cleanup
rm -rf "$ZPLUGINDIR"

echo
echo "Tests completed: $passed passed, $failed failed"

if [[ $failed -gt 0 ]]; then
    exit 1
fi