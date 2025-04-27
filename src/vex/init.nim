import os, types, cli, jsony, toml_serialization, setup, aes, curly

let curl = newCurly()

proc init*(path: string) = 
    let usrData = getStoredData()

    # Checks at directory
    if dirExists(path):
        var blank = true
        for i in walkDir(path):
            blank = false;
            break;
        if not blank:
            displayWarning "The directory is not empty. Vex won't remove anything, the contents of it will stay in it and be used in the repo"
    else:
        displayHint "Directory does not exist, creating it..."
        createDir(path)
        displaySuccess "Directory created"

    # Start prompts
    display "Starting creation of repo at: ", path
    let name = promptCustom("Repo name", path.splitPath()[1])

    var res: Repo = Repo(name: name, ownerID: usrData.id, origin: usrData.hoster, owner: usrData.username)
    echo "  ", $(res.toJson())

    let correct = promptYesNo("Is this correct?")
    if not correct:
        displayError "Run again to edit"
        quit(1)

    # Generate the .vex.toml file
    let tomlString = Toml.encode(res)
    writeFile(path&"/.vex.toml", tomlString)

    # Publish to origin if exists
    # Create Auth
    let a: Auth = Auth(username: usrData.username, passwordHash: usrData.hashedPassword)
    let url = usrData.hoster&"/new/"&usrData.username&"/"&name;
    let reqObj: RepoRequest = RepoRequest(auth: a, repo: res);
    let body = ($(reqObj.toJson())).encryptData(usrData.id)
    let request = curl.post(url, emptyHttpHeaders(), body)
    if request.body == "200":
        displaySuccess "Repo created at hoster '"&usrData.hoster&"'"
    else:
        displayError request.body