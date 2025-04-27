import cli, types, curly, jsony, aes, setup, toml_serialization, os, tables

let curl = newCurly()

proc branch*() = 
    displayInfo "Loading config and `.vex.toml`..."
    let usr = getStoredData()
    let repo: Repo = Toml.decode(readFile(getCurrentDir()&"/.vex.toml"), Repo)
    displayInfo "Done"
    let name = promptCustom("Branch name","notmain")
    let hasCommit = promptYesNo("Select an existing commit to be the starting commit for this branch?")
    var initialCommitBranch = ""
    var initialCommitID = ""
    displayInfo "Getting repo data"
    let repoData = curl.get(repo.origin&"/data/"&repo.owner&"/"&repo.name).body.fromJson(RepoFile)
    let a: Auth = Auth(username: usr.username, passwordHash: usr.hashedPassword)
    var req: BranchRequest
    if hasCommit:
        # Select branch and commit
        var branches: seq[string] = @[]
        for b in repoData.structure.keys():
            branches.add(b)
        initialCommitBranch = promptList(dontForcePrompt, "From which branch is the commit?", branches)
        var ids = repoData.structure[initialCommitBranch].cont;
        ids.add("LTS")
        initialCommitID = promptList(dontForcePrompt, "Select the commit id (LTS for latest)", ids)
        if initialCommitID == "LTS":
            initialCommitID = ids[ids.len() - 2]

        req = BranchRequest(auth: a, reponame: repo.name, username: usr.username, branchName: name, fromCommit: initialCommitID)

    else:
        # Not initial commitlet a: Auth = Auth(username: usr.username, passwordHash: usr.hashedPassword)
        req = BranchRequest(auth: a, reponame: repo.name, username: usr.username, branchName: name)

    # Run request
    displayInfo "Creating request..."
    let commitURL = repo.origin&"/branch/"&repo.owner&"/"&repo.name;
    let body: string = ($(req.toJson())).encryptData(usr.id)
    displayInfo "Done!"
    displayInfo "Sending request..."
    let branchReq = curl.post(commitURL, emptyHttpHeaders(), body)

    if branchReq.body == "200":
        displaySuccess "Branch created"
    else:
        displayError branchReq.body

proc setBranch*(name: string) = 
    var repo: Repo = Toml.decode(readFile(getCurrentDir()&"/.vex.toml"), Repo);
    repo.currentBranch = name;
    writeFile(getCurrentDir()&"/.vex.toml", Toml.encode(repo))