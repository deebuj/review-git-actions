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
if [ "$ENVIRONMENT" = "staging" ]; then
  echo "Adding to staging section..."
  sed -i "/## staging Deployments/a ${NEW_ENTRY}" Deployment-Log.md
else
  echo "Adding to Production section..."
  sed -i "/## production Deployments/a ${NEW_ENTRY}" Deployment-Log.md
fi

# Display the updated content
echo "Updated content:"
cat Deployment-Log.md

# Configure git and commit changes
git status
echo "Configuring git..."
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git add Deployment-Log.md
git status
echo "Committing changes..."
git commit -m "Log $ENVIRONMENT deployment #$RUN_NUMBER"
echo "Pushing changes..."
git push
echo "Wiki update completed."
