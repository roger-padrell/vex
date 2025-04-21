import strutils, random, argon2, libsha/sha256
randomize()

const idLen = 16

type 
    User* = object
        mail*: string
        username*: string
        id*: string

proc getpass(prompt: cstring) : cstring {.header: "<unistd.h>", importc: "getpass".}

proc generateID(u: string, p: string): string =
    var us = u;
    while us.len() < 8:
        us = us&u;
    let hashedPassword = argon2(p, us).enc
    let rawId = u&";;"&hashedPassword
    let hashedID = sha256hexdigest(rawId)
    return hashedID;


proc newUser*() = 
    stdout.write "Username: "
    let username = readLine(stdin)
    stdout.write "Email: "
    let mail = readLine(stdin)
    let pass = $getpass("Password: ")
    echo "Creating user..."
    let id = ($generateID(username, pass))[0..idLen]
    echo "User created, id:"
    echo "  "&id
    let user: User = User(mail: mail, username: username, id: id)
    
newUser()