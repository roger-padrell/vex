import argon2, libsha/sha256

const idLen* = 16

type 
    User* = object
        username*: string
        id*: string

proc hashPassword*(u: string, p: string): string = 
    var us = u;
    while us.len() < 8:
        us = us&u;
    let hashedPassword = argon2(p, us).enc
    return hashedPassword

proc generateID*(u: string, p: string): string =
    let hashedPassword = hashPassword(u, p)
    let rawId = u&";;"&hashedPassword
    let hashedID = sha256hexdigest(rawId)
    return hashedID;