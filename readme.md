# review-git-actions

This application is to test git actions

# Log deployments in github wiki

## Create at least one Wiki Page

## Give permissions
The GitHub Actions needs permissions to write to the wiki. We need to use a GitHub token with the necessary permissions to push to the wiki. 

### Personal Account
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

### Organization Account
To create a WIKI_TOKEN for a GitHub organization account, follow these steps:

Go to Organization Settings:

Navigate to your GitHub organization
Click on "Settings" in the top menu
Create a Fine-grained Personal Access Token:

In the left sidebar, click "Developer settings"
Select "Personal access tokens" → "Fine-grained tokens"
Click "Generate new token"
Configure Token Settings:

Token name: WIKI_TOKEN (or any descriptive name)
Expiration: Choose an appropriate duration
Description: "Token for updating GitHub wiki via Actions"
Resource owner: Select your organization from the dropdown
Repository access: Select "Only select repositories"
Choose the specific repository that needs wiki access
Set Permissions:

Expand "Repository permissions"
Find "Contents" and set to "Read and write"
Find "Metadata" and set to "Read-only"
Find "Pages" and set to "Read and write"
Add Token to Repository:

Go to your repository settings
Navigate to "Secrets and variables" → "Actions"
Click "New repository secret"
Name: WIKI_TOKEN
Value: Paste the token you just generated
Click "Add secret"

### Scopes
For writing to a GitHub wiki through GitHub Actions, you need to select the following minimum scopes when creating your Personal Access Token (classic):

repo (Full control of private repositories) - This scope includes:

repo:status
repo_deployment
public_repo
repo:invite
security_events
workflow (Update GitHub Action workflows)

These scopes will give the token enough permissions to:

Clone the wiki repository
Push changes to the wiki
Work with GitHub Actions
When selecting the scopes on GitHub:

Check the box next to repo (it will automatically select all sub-scopes)
Check the box next to workflow