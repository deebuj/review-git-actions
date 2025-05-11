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

## staging Deployments

| Time | Run Number | Deployed By |
|------|------------|-------------|

## production Deployments

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
  # Create new content with entry after staging table header
  awk -v entry="$NEW_ENTRY" '
    BEGIN { in_staging = 0; done = 0 }
    /## staging Deployments/ { in_staging = 1 }
    /## production Deployments/ { in_staging = 0 }
    /\|------|------------|-------------\|/ {
      print $0
      if (in_staging && !done) {
        print entry
        done = 1
      }
      next
    }
    { print }
  ' Deployment-Log.md > temp.md
else
  echo "Adding to production section..."
  # Add entry after production table header
  awk -v entry="$NEW_ENTRY" '
    BEGIN { in_production = 0; done = 0 }
    /## production Deployments/ { in_production = 1 }
    /\|------|------------|-------------\|/ {
      print $0
      if (in_production && !done) {
        print entry
        done = 1
      }
      next
    }
    { print }
  ' Deployment-Log.md > temp.md
fi

mv temp.md Deployment-Log.md

# Display the updated content
echo "Updated content:"
cat Deployment-Log.md

# Always commit changes since we're creating a new file
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
