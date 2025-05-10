#!/bin/bash

# Parameters
ENVIRONMENT=$1
RUN_NUMBER=$2
ACTOR=$3

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

# Create a temporary file
cp Deployment-Log.md temp.md

# Add new deployment to appropriate section
if [ "$ENVIRONMENT" = "Staging" ]; then
  # Find the Staging section and add entry after its header
  awk '/## Staging Deployments/{p=NR+3}(NR==p){print "| '"$(date -u '+%Y-%m-%d %H:%M:%S UTC')"' | '"$RUN_NUMBER"' | '"$ACTOR"' |\n" $0;next}1' Deployment-Log.md > temp.md
else
  # Find the Production section and add entry after its header
  awk '/## Production Deployments/{p=NR+3}(NR==p){print "| '"$(date -u '+%Y-%m-%d %H:%M:%S UTC')"' | '"$RUN_NUMBER"' | '"$ACTOR"' |\n" $0;next}1' Deployment-Log.md > temp.md
fi

# Replace original file with updated content
mv temp.md Deployment-Log.md

# Configure git
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git add Deployment-Log.md
git commit -m "Log $ENVIRONMENT deployment #$RUN_NUMBER"
git push
