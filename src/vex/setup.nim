import cli, hosts, tables, curly, user, types, jsony, aes, os, strutils

let curl = newCurly()

const newUserKey = "new user.usernew"

proc setup*(): bool = 
    echo "Welcome to the VEX setup tool"

    # Host
    displayInfo "First, setup your host"
    let hostname = promptList(dontForcePrompt, "Choose your host", hostNames)
    var hosturl = ""
    if hostname != "custom":
        hosturl = hostTable[hostname]
    else:
        hosturl = promptCustom("URL to custom host","")
    displayInfo "Veryfing host..."
    let validhost = curl.get(hosturl)
    if validhost.body != "vexhost":
        displayError "Host is not valid, it did not give a valid response."
        return false;
    else:
        displaySuccess "Host is valid, proceeding"

    # User
    var username = ""
    var password = ""
    displayInfo "Now, setup your user"
    let userOption = promptList(dontForcePrompt, "Sign in or Create account", ["Sign in","Create account"]);
    if userOption == "Sign in":
        username = promptCustom("Username","")
        password = $getpass("Password: ")
        let hashed = hashPassword(username, password)
        displayInfo "Veryfing credentials..."
        let a: Auth = Auth(username: username, passwordHash: hashed)
        let str = $(a.toJson())
        let encrypted = str.encryptData(newUserKey)
        let correctAuth = curl.post(hosturl&"/auth", emptyHttpHeaders(), encrypted)
        if correctAuth.body == "200":
            displaySuccess "Credentials correct"
        else:
            displayError "Credentials incorrect, run the setup tool again"
            return false;
    elif userOption == "Create account":
        username = promptCustom("Username","")
        password = $getpass("Password: ")
        let id = generateID(username, password)[0..idLen-1]
        let u: User = User(id: id, username: username)
        let str = $(u.toJson())
        let encrypted = str.encryptData(newUserKey)
        let response = curl.post(hosturl&"/usr", emptyHttpHeaders(), encrypted)
        if response.body != "200":
            displayError "Username taken or server error"
            return false;
        displaySuccess "User created"

    displayInfo "Proceeding to store data..."
    let hashedPasswd = hashPassword(username, password)
    let id = generateID(username, password)[0..idLen-1]
    let data = username&"\n"&id&"\n"&hosturl&"\n"&hashedPasswd;
    writeFile(getAppDir()&"/config", data)
    displaySuccess "Setup completed"
    return true;

proc getStoredData*(): LocalData = 
    let filePath = getAppDir()&"/config";
    if not fileExists(filePath):
        quit("Config not found, run `vex setup`")
    let dt = readFile(filePath).split("\n");
    let res = LocalData(username: dt[0], id: dt[1], hoster: dt[2], hashedPassword: dt[3])
    return res;

if isMainModule:
    echo setup()