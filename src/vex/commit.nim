import os, setup, cli, vexbox, toml_serialization, types, curly, jsony, tables, clone, aes

let curl = newCurly()

proc createRelCommit*(filePath: string, relativeTo: string, relativeToID: string): string = 
    let boxel: Box = relBox(filePath, openBox(relativeTo), relativeToID)
    let jsonobj = boxel.toJson()
    let jsonstr: string = $jsonobj
    return compress(jsonstr)

proc createRawCommit*(filePath: string): string = 
    let boxel: Box = rawBox(filePath)
    let jsonobj = boxel.toJson()
    let jsonstr: string = $jsonobj
    return compress(jsonstr)

proc commit*() = 
    displayInfo "Getting stored user data"
    let usrData = getStoredData()
    displayInfo "Done"

    # Read repo file
    displayInfo "Reading repo file..."
    if not fileExists("./.vex.toml"):
        displayError "Repo file does not exist, init the repo with `vex init`"
        quit()
    let repo: Repo = Toml.decode(readFile(getCurrentDir()&"/.vex.toml"), Repo)
    displayInfo "Done!"

    # Get from origin
    displayInfo "Getting latest commit from branch..."
    let url = repo.origin&"/data/"&repo.owner&"/"&repo.name;
    let response = curl.get(url)
    let repoData = response.body.fromJson(RepoFile)
    let branch = repoData.structure[repo.currentBranch]
    var newCommit = "";
    if branch.cont.len() != 0:
        let lastCommitID = branch.cont[branch.cont.len() - 1]
        displayInfo "Got latest commit from branch `"&branch.name&"`: "&lastCommitID;
        displayInfo "Fetching latest commit"
        displayInfo "Generating raw box from latest commit"
        # Get last commit box
        let lastCommit = cloneRaw(branch.name, lastCommitID)
        displayInfo "Done!"
        displayInfo "Generating new box relative to latest commit"
        # Create relative box
        newCommit = createRelCommit(getCurrentDir(), lastCommit, "vex:"&repo.origin&":"&repo.owner&"/"&repo.name&":"&branch.name&"."&lastCommitID)
        displayInfo "Done!"
    else:
        displayWarning "Branch has no commits, this will be the first"
        displayInfo "Generating new box from raw"
        newCommit = createRawCommit(getCurrentDir())
        displayInfo "Done"

    # Send
    displayInfo "Preparing auth and request"
    let a: Auth = Auth(username: usrData.username, passwordHash: usrData.hashedPassword)
    let req = CommitRequest(auth: a, repo: repo.name, box: newCommit, branch: branch.name)
    let commitURL = repo.origin&"/com/"&repo.owner&"/"&repo.name;
    let body: string = ($(req.toJson())).encryptData(usrData.id)
    displayInfo "Done! sending request"
    let commitReq = curl.post(commitURL, emptyHttpHeaders(), body)

    if commitReq.body == "200":
        displaySuccess "Commit sended and accepted"
    else:
        displayError commitReq.body

if isMainModule:
    commit()