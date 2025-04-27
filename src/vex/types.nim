import user, tables

type 
    Repo* = object
        name*: string
        ownerID*: string # User ID
        owner*: string # Username
        origin*: string = ""
        editors*: seq[string] = @[]
        currentBranch*: string = "main"

    LocalData* = object
        hashedPassword*: string
        username*: string
        id*: string
        hoster*: string # URL

    Auth* = object
        username*: string
        passwordHash*: string

    RepoRequest* = object
        repo*: Repo
        auth*: Auth

    RepoBranch* = object
        name*: string
        cont*: seq[string] = @[] # VexBox id's / hashes

    RepoFile* = object
        owner*: User
        structure*: Table[string, RepoBranch] = {"main": RepoBranch(name: "main")}.toTable
        name*: string

    CommitRequest* = object
        auth*: Auth
        repo*: string
        box*: string # Compressed VexBox
        branch*: string = "main"

    BranchRequest* = object
        auth*: Auth
        reponame*: string
        username*: string
        branchName*: string
        fromCommit*: string = "none" # commit id