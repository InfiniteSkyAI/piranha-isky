#!/bin/bash
set -euo pipefail

# --- Configuration ---
DOMAIN="infinitesky"
REPO="infinitesky"
ACCOUNT_ID="602906786063"
REGION="us-east-2"

# 1. Authenticate
echo "Authenticating with AWS CodeArtifact..."
aws codeartifact login \
    --tool twine \
    --domain "$DOMAIN" \
    --domain-owner "$ACCOUNT_ID" \
    --repository "$REPO" \
    --region "$REGION"

# 2. Locate the wheel
WHEEL_PATH=$(ls dist/polyglot_piranha_isky-*.whl 2>/dev/null | head -n 1 || true)

if [ -z "$WHEEL_PATH" ]; then
    echo "Error: No wheel found in dist/"
    echo "Did you run ./make_wheel.sh first?"
    exit 1
fi

echo "Found wheel: $WHEEL_PATH"

# 3. Upload to CodeArtifact
uvx twine upload --repository codeartifact --non-interactive --verbose "$WHEEL_PATH"

echo "Done! Install with:"
echo "uv pip install polyglot-piranha-isky --extra-index-url https://$DOMAIN-$ACCOUNT_ID.d.codeartifact.$REGION.amazonaws.com/pypi/$REPO/simple"
