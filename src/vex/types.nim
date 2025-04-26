type 
    Repo* = object
        name*: string
        ownerID*: string # User ID
        owner*: string
        version*: string
        hosted*: bool = false
        origin*: string = ""
        editors*: seq[string] = @[]


    LocalData* = object
        hashedPassword*: string
        username*: string
        hoster*: string # URL

    Auth* = object
        username*: string
        passwordHash*: string

    StoredData* = object
        username*: string
        id*: string
        hashedPassword*: string