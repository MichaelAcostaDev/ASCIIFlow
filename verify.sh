#!/bin/bash
set -e

cd /mnt/c/Users/micha/OneDrive/Escritorio/programacion/Linux/ASCIIFlow

echo "ASCIIFlow Comprehensive Verification"
echo "===================================="
echo ""

# Test 1: Basic rendering
echo "Test 1: Basic Rendering (block font)"
bash asciiflow "Hello" > /tmp/test1.txt
lines=$(wc -l < /tmp/test1.txt)
echo "Lines produced: $lines"
if [[ $lines -ge 5 ]]; then
  echo "✓ PASS: Block font produces multi-line output"
else
  echo "✗ FAIL: Not enough lines"
fi
echo ""

# Test 2: Different font
echo "Test 2: Different Font (digital)"
bash asciiflow -f digital "Test" > /tmp/test2.txt
lines=$(wc -l < /tmp/test2.txt)
echo "Lines produced: $lines"
if [[ $lines -ge 5 ]]; then
  echo "✓ PASS: Digital font works"
else
  echo "✗ FAIL: Digital font issue"
fi
echo ""

# Test 3: List fonts
echo "Test 3: List Fonts"
fonts=$(bash asciiflow -l | wc -l)
echo "Fonts listed: $fonts"
if [[ $fonts -ge 4 ]]; then
  echo "✓ PASS: All fonts listed"
else
  echo "✗ FAIL: Missing fonts"
fi
echo ""

# Test 4: Help flag
echo "Test 4: Help Flag"
help=$(bash asciiflow -h | wc -l)
echo "Help lines: $help"
if [[ $help -gt 10 ]]; then
  echo "✓ PASS: Help works"
else
  echo "✗ FAIL: Help incomplete"
fi
echo ""

# Test 5: Version flag
echo "Test 5: Version Flag"
version=$(bash asciiflow -v)
echo "Version: $version"
if [[ "$version" == *"ASCIIFlow"* ]]; then
  echo "✓ PASS: Version works"
else
  echo "✗ FAIL: Version issue"
fi
echo ""

# Test 6: Numbers
echo "Test 6: Numbers Rendering"
bash asciiflow "12345" > /tmp/test6.txt
lines=$(wc -l < /tmp/test6.txt)
echo "Lines produced: $lines"
if [[ $lines -ge 5 ]]; then
  echo "✓ PASS: Numbers render correctly"
else
  echo "✗ FAIL: Number rendering issue"
fi
echo ""

# Test 7: Long text
echo "Test 7: Long Text"
bash asciiflow "ASCIIFlow" > /tmp/test7.txt
lines=$(wc -l < /tmp/test7.txt)
chars=$(wc -c < /tmp/test7.txt)
echo "Lines: $lines, Characters: $chars"
if [[ $lines -ge 5 && $chars -gt 100 ]]; then
  echo "✓ PASS: Long text renders"
else
  echo "✗ FAIL: Long text issue"
fi
echo ""

# Test 8: Small font
echo "Test 8: Small Font"
bash asciiflow -f small "Text" > /tmp/test8.txt
lines=$(wc -l < /tmp/test8.txt)
echo "Small font lines: $lines"
if [[ $lines -ge 3 ]]; then
  echo "✓ PASS: Small font works"
else
  echo "✗ FAIL: Small font issue"
fi
echo ""

echo "===================================="
echo "Verification Complete!"
