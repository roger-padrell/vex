import os, curly, vexbox, cli, toml_serialization, types, jsony, strutils, setup

let curl = newCurly()

proc cloneRaw*(branch: string, version: string): string = 
    # Read repo file
    if not fileExists("./.vex.toml"):
        displayError "Repo file does not exist, init the repo with `vex init`"
        quit()
    let repo: Repo = Toml.decode(readFile(getCurrentDir()&"/.vex.toml"), Repo)

    # Get that box
    let boxUrl = repo.origin&"/clone/"&repo.owner&"/"&repo.name&"/"&branch&"."&version;
    let box = (curl.get(boxUrl)).body

    # Use vexbox.toRaw and compress
    let rawBox = openBox(box).toRaw()
    let js = $(rawBox.toJson())
    let compressedBox = compress(js)

    return compressedBox

proc cloneRawRepo*(user: string, repo: string, branch: string, version: string, origin: string): string = 
    # Get that box
    let boxUrl = origin&"/clone/"&user&"/"&repo&"/"&branch&"."&version;
    let box = (curl.get(boxUrl)).body

    # Use vexbox.toRaw and compress
    let rawBox = openBox(box).toRaw()
    let js = $(rawBox.toJson())
    let compressedBox = compress(js)

    return compressedBox

proc clone*(reponame: string, branch: string, version: string, targetPath: string = reponame.split("/")[1], origin: string = getStoredData().hoster) = 
    displayInfo "Cloning version `"&version&"` from branch `"&branch&"`";
    let content = cloneRawRepo(reponame.split("/")[0], reponame.split("/")[1], branch, version, origin)
    displayInfo "Done!"
    displayInfo "Mounting it at: "&targetPath;
    mountAt(openBox(content), targetPath)
    displaySuccess "Done!"