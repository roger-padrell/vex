# VEX - API documentation

## Table of contents
- [`vex setup`](#vex-setup)
- [`vex init`](#vex-init-path)
- [`vex clone`](#vex-clone-repo-branch-version)
- [`vex commit`](#vex-commit)
- [`vex branch`](#vex-branch)
- [`vex setbranch`](#vex-setbranch-branchname)
- [`vex help`](#vex-help)

## `vex setup`
Asks a set of prompts to create the vex configuration file with your authentication info for the server and your prefered origin. It logins or creates an user in that origin. It stores all in `config` in the following structure:
```txt
username
user's id
user's hashed password
```

## `vex init {path}`
Inits a VEX repo at `{path}` and creates a `.vex.toml` file there. 
It also publishes the repo at the origin defined by `config`.

## `vex clone {repo} {branch?} {version?}`
Clones and mounts a repository (`owner/reponame`) at `reponame` directory.
Branch and version are optional and are predefined to `main` and `lts` (latest commit/version in main branch).

## `vex commit`
Gets the last commit from this branch (defined at `.vex.toml:currentBranch`), compares to the current content of the repo and commits the diff as a relative vexbox to the origin (defined in `.vex.toml`).

## `vex branch`
Creates a new branch and starts it from an existing command if necessary.

## `vex setbranch {branchname}`
Sets the current branch of the repo to `branchname`. It does not check if the branch exists.

## `vex help`
Displays a ratherly unhelpful message that gets you to this documentation.