# MSSA CCAD 8

Started on 10/24/2022  
Week 13: 2023.01.09 - 2022.01.13

## Week 13 - Git & GitHub

## Day 1 - 

On Day 1 we did basic GIT Training (mostly a review for us)

## GitTraining  

MSSA Git Training

### Morning

This is what we did this morning:

- Created a private Repo
- Talked briefly about markdown and made a markdown file
    - New line text is two spaces
    - Link requires [ ] around the friendly text and parens ( ) around the link  
    - [A link to google](https://www.google.com)

### Notes

Students had already set everything up and we've been using GIT from the start, so config and editor stuff was already completed.

### Commands 

The following commands were covered and demonstrated together against our repositories:

#### git clone  

Clone a remote repository to your local drive.  Change directory to your local folder and run the command:

```  
git clone your-remote-repo-url-here
```  

#### git add

Adding a file moves an untracked file or a tracked file with changes to staging to be ready for commit.  Use `git add .` for all changes, use `git add [filename]` for a specific file

```
git add .
git add [filename]
```  

#### git commit

Commit any files staged in the index and add them back to the working directory as a tracked and unmodified. Records the change into the commit history.

```
git commit -m "your commit message here"
git commit -am "your commit message here, also staged any changes for tracked files"
```  

#### git push

Push commits to the upstream remote

For untracked branches (new branch created locally or a new repo never pushed to GitHub)  

```
git push -u origin branchname
```

For tracked branches on the origin variable remote

```
git push
```  

#### git fetch

Fetch any changes from remote, including new branches

```
git fetch
```  

Fetch any changes from remote, including new branches, update any deleted branches as gone

```
git fetch --prune
```  

#### git pull

Get the local version of the branch up to date by fast-forwarding the changes onto the base on your local branch

```  
git pull
git pull --prune
```  

#### fetch && pull

You can run multiple commands with the `&&` in between them:

```
git fetch --prune && git pull
```  

#### remote

Find out what upstreams you are tracking

```
git remote -vv
```  

#### git status

Discern where files are in the current status of untracked/tracked, modified, staged, unmodified.

```
git status
git status -s
```

#### git log

Use the log to view your commit history on the local repository, including where current and remote branches exist

```
git log
git log --oneline
```  

#### git merge

When you merge, you bring two branches together and create a new commit to handle the resolution.  This commit is known as a merge commit.

1. Check out the branch to merge changes to:

    ```
    git checkout branchtomergeto
    ```  

1. Merge the changes from another branch:

    ```
    git merge branchtomerge
    ```

When there has been a conflict, use `abort` to go back to the state prior to the start of the merge:

```
git merge --abort
```  

If you've resolved all conflicts, you can continue the merge:

```
git merge --continue
```  

#### git branch

Moving between existing branches can be done with `checkout` or `switch`:

```
git checkout branchname
git switch branchname
```  

If the branch is not existing, you can't switch to it.  Instead, you must create it.  You can do this with a branch command

```  
git branch newbranchname
```  

Then you have to switch to it

```
git checkout newbranchname
git switch newbranchname
```

Or you can do this all in one command:

```
git checkout -b newbranchname
```  

this last command creates the branch and switches to it.

To list all branches

```
git branch -a
```

To see branches and if they are tracked at remote:

```
git branch -vv
```

To delete a branch safely, use the "small d" in the command:

```
git branch -d branchname
```  

To force delete a branch, use the capital D in the command:

```
git branch -D branchname
```  

### Reference

- [Recording changes to the repository](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository)  

### Afternoon

In the afternoon, we worked on our own projects.

1. Greg had a crlf question.

This led to running the following commands:

```
git config --global -e
```

Once there, we added the line

```text
autocrlf = true
```  

To configure for automatic line-ending handling.

Alternatively, the following command could have been run:

```  
git config --global core.autocrlf true
```  

1. Demo on delegates

Mark asked for a delegates demo, so I wanted to show that

### Upcoming Demos on the radar

- Encryption and Hashing and Salting a password
- User Identity/Authorization and MVC

## Lost track

I lost track of what we did, but the demos for encryption and git Bisect were completed

We completed all the GIT material and the two GIT challenges (except the ARM portion of the GitHub Actions challenge).

