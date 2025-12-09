#!/usr/bin/env bash

# ============================================
# Create Test Files for find Practice
# ============================================
# Purpose: Generates directory structure with various file types
# Usage: ./create-test-files.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/../test-files-$(date +%Y%m%d-%H%M%S)"

echo "Creating test file structure in: $TEST_DIR"

# Create directory structure
mkdir -p "$TEST_DIR"/{docs,images,videos,code/{python,javascript,java},logs}

# Create various file types
echo "Sample text" > "$TEST_DIR/docs/readme.txt"
echo "More text" > "$TEST_DIR/docs/notes.txt"
echo "#!/bin/bash" > "$TEST_DIR/docs/script.sh"

touch "$TEST_DIR/images/photo1.jpg"
touch "$TEST_DIR/images/photo2.png"
touch "$TEST_DIR/images/diagram.svg"

touch "$TEST_DIR/videos/video1.mp4"
touch "$TEST_DIR/videos/video2.avi"

echo "print('Hello')" > "$TEST_DIR/code/python/hello.py"
echo "def test(): pass" > "$TEST_DIR/code/python/test.py"

echo "console.log('Hi')" > "$TEST_DIR/code/javascript/app.js"
echo "const x = 1;" > "$TEST_DIR/code/javascript/config.js"

echo "public class Main {}" > "$TEST_DIR/code/java/Main.java"
echo "public class Test {}" > "$TEST_DIR/code/java/Test.java"

echo "ERROR: Something failed" > "$TEST_DIR/logs/error.log"
echo "INFO: All good" > "$TEST_DIR/logs/info.log"

# Create files with different permissions
chmod 644 "$TEST_DIR/docs/readme.txt"
chmod 755 "$TEST_DIR/docs/script.sh"
chmod 600 "$TEST_DIR/logs/error.log"

# Create files of different sizes
dd if=/dev/zero of="$TEST_DIR/large-file.dat" bs=1M count=10 2>/dev/null
dd if=/dev/zero of="$TEST_DIR/small-file.dat" bs=1K count=10 2>/dev/null

echo ""
echo "✓ Test files created successfully!"
echo "Location: $TEST_DIR"
echo ""
echo "Try these find commands:"
echo "  find \"$TEST_DIR\" -name '*.py'"
echo "  find \"$TEST_DIR\" -type f -size +1M"
echo "  find \"$TEST_DIR\" -perm 755"
echo ""
echo "Cleanup: rm -rf \"$TEST_DIR\""
echo ""
