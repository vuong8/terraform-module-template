#! /bin/bash

REPO="$1"  # Replace with your GitHub repository

# Get the latest tag
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
# Get the latest commit message
COMMIT_MESSAGE=$(git log -1 --pretty=%B)

local pattern='^v([0-9]+)\.([0-9]+)\.([0-9]+)$'
# Check and reset LATEST_TAG if necessary
 if [[ "$version" =~ $pattern ]]; then
    # Extract version components
    MAJOR=$(echo $LATEST_TAG | sed 's/^v\([0-9]*\)\.[0-9]*\.[0-9]*$/\1/')
    MINOR=$(echo $LATEST_TAG | sed 's/^v[0-9]*\.\([0-9]*\)\.[0-9]*$/\1/')
    PATCH=$(echo $LATEST_TAG | sed 's/^v[0-9]*\.[0-9]*\.\([0-9]*\)$/\1/')
else
    # Set default version if no matched
    MAJOR=1
    MINOR=0
    PATCH=0
fi

# Increment version based on commit message
if echo "$COMMIT_MESSAGE" | grep -q "\[MAJOR\]"; then
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
elif echo "$COMMIT_MESSAGE" | grep -q "\[MINOR\]"; then
    MINOR=$((MINOR + 1))
    PATCH=0
else
    PATCH=$((PATCH + 1))
fi

# Construct the new version tag
NEW_VERSION="v$MAJOR.$MINOR.$PATCH"

# Define GitHub release variables
RELEASE_NAME="Release $NEW_VERSION"
RELEASE_BODY="Release notes for $NEW_VERSION $COMMIT_MESSAGE"

echo "Creating new release $NEW_VERSION"

# Create the release via GitHub API
curl -X POST \
    -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    -d @- https://api.github.com/repos/$REPO/releases <<EOF
{
    "tag_name": "$NEW_VERSION",
    "name": "$RELEASE_NAME",
    "body": "$RELEASE_BODY",
    "draft": false,
    "prerelease": false
}
EOF

# Verify the release creation
curl -H "Authorization: token $GH_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/$REPO/releases/tags/$NEW_VERSION