import os, types, termstyle, cli, tables, jsony, toml_serialization

var origins = initTable[string,string]()
origins["other"] = ""

proc init*(path: string) = 
    var defaultID = ""
    if not fileExists(getAppDir()&"user.id"):
        displayWarning "Default user not found. Configure it with `vex login`"
    else:
        defaultID = readFile(getAppDir()&"user.id");

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
    let owner = promptCustom("Owner ID", defaultID)
    let version = "0.0.0"
    let hosted = promptYesNo("Are you going to host it?")
    var origin = ""
    if hosted:
        origin = promptList(dontForcePrompt, "Where are you going to host it?", ["other"])
        if origin == "other":
            origin = promptCustom("URL","")
        else:
            origin = origins[origin]

    var res: Repo = Repo(name: name, owner: owner, version: version, hosted: hosted, origin: origin)
    echo "  ", $(res.toJson())

    let correct = promptYesNo("Is this correct?")
    if not correct:
        displayError "Run again to edit"
        quit(1)

    # Generate the .vex.toml file
    let tomlString = Toml.encode(res)
    writeFile(path&".vex.toml", tomlString)

    # Publish to origin if exists
    # ... to implement