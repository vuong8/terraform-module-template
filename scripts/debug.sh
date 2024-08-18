LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
# Get the latest commit message
COMMIT_MESSAGE=$(git log -1 --pretty=%B)

# Function to check if the input is a valid release format
is_valid_release() {
    local input="$1"
    local pattern="^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$"

    # Use regex pattern to check the input
    if [[ "$input" =~ $pattern ]]; then
        return 0  # true, valid release format
    else
        return 1  # false, invalid release format
    fi
}

# Check and reset LATEST_TAG if necessary
if is_valid_release "$LATEST_TAG"; then
    # Extract version components
    MAJOR=$(echo $LATEST_TAG | sed 's/^v\([0-9]*\)\.[0-9]*\.[0-9]*$/\1/')
    MINOR=$(echo $LATEST_TAG | sed 's/^v[0-9]*\.\([0-9]*\)\.[0-9]*$/\1/')
    PATCH=$(echo $LATEST_TAG | sed 's/^v[0-9]*\.[0-9]*\.\([0-9]*\)$/\1/')
    echo "[$LATEST_TAG] mathch"
else
    # Set default version if no matched
    MAJOR=0
    MINOR=0
    PATCH=0
    echo "[$LATEST_TAG] not match"
fi
echo "before increase $MAJOR.$MINOR.$PATCH"
