#!/bin/bash
set -ex  # Add -x for verbose output

# Parameters
ENVIRONMENT="$1"
RUN_NUMBER="$2"
ACTOR="$3"

# Debug information
echo "Current directory: $(pwd)"
echo "Environment: $ENVIRONMENT"
echo "Run Number: $RUN_NUMBER"
echo "Actor: $ACTOR"

# Create or update the deployment log with sections
if [ ! -f "Deployment-Log.md" ]; then
  # Create initial file with headers
  cat > Deployment-Log.md << EOL
# Deployment Log

This page tracks all deployments made through our GitHub Actions workflow.

## Staging Deployments

| Time | Run Number | Deployed By |
|------|------------|-------------|

## Production Deployments

| Time | Run Number | Deployed By |
|------|------------|-------------|
EOL
fi

# Create new entry
NEW_ENTRY="| $(date -u '+%Y-%m-%d %H:%M:%S UTC') | ${RUN_NUMBER} | ${ACTOR} |"
echo "New entry to add: ${NEW_ENTRY}"

# Add new deployment to appropriate section
if [ "$ENVIRONMENT" = "Staging" ]; then
  echo "Adding to Staging section..."
  sed -i "/## Staging Deployments/a\\${NEW_ENTRY}" Deployment-Log.md
else
  echo "Adding to Production section..."
  sed -i "/## Production Deployments/a\\${NEW_ENTRY}" Deployment-Log.md
fi

# Display the updated content
echo "Updated content:"
cat Deployment-Log.md

# Configure git and commit changes
echo "Checking git status before changes..."
git status

echo "Checking if there are actual changes in the file..."
if ! git diff --quiet Deployment-Log.md; then
    echo "Changes detected in Deployment-Log.md"
    echo "Configuring git..."
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    
    echo "Adding changes..."
    git add Deployment-Log.md
    
    echo "Git status after adding changes:"
    git status
    
    echo "Committing changes..."
    git commit -m "Log $ENVIRONMENT deployment #$RUN_NUMBER"
    
    echo "Pushing changes..."
    git push
    echo "Wiki update completed successfully."
else
    echo "No changes detected in Deployment-Log.md"
    echo "Current content of Deployment-Log.md:"
    cat Deployment-Log.md
    exit 1
fi
