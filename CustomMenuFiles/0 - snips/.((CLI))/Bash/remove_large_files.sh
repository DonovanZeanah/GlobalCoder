#!/bin/bash

# Set the minimum file size threshold (in bytes)
threshold=1000000 # 1 MB

# Find large files in your Git history
large_files=$(git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | awk -v threshold="$threshold" '/^blob/ { if ($3 > threshold) print substr($0,53)}')

# Backup your repository, as the following commands will modify the history
echo "Backing up the repository to repo_backup.git"
cp -R .git repo_backup.git

# Remove each large file
for file in $large_files; do
  echo "Removing $file from Git history"
  git filter-branch --index-filter "git rm --cached --ignore-unmatch $file" --prune-empty --tag-name-filter cat -- --all
done

# Clean up the repository
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now --aggressive
