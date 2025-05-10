# review-git-actions

This application is to test git actions

# Log deployments in github wiki

## Create Wiki Page for deployment
Format available in  https://github.com/deebuj/review-git-actions/blob/main/.github/wiki/Deployment-Log.md

## Give permissions
The GitHub Actions bot needs permissions to write to the wiki. We need to use a GitHub token with the necessary permissions to push to the wiki. Let's modify the workflow to use a Personal Access Token (PAT) that has wiki permissions.

First, you'll need to create a Personal Access Token:

Go to GitHub Settings -> Developer Settings -> Personal Access Tokens -> Tokens (classic)
Generate a new token with the wiki permission
Copy the token
Then add this token as a repository secret:

Go to your repository settings
Navigate to Settings -> Secrets and variables -> Actions
Click "New repository secret"
Name it WIKI_TOKEN
Paste your PAT as the value