type 
    Repo* = object
        name*: string
        ownerID*: string # User ID
        owner*: string
        version*: string
        hosted*: bool = false
        origin*: string = ""
        editors*: seq[string] = @[]
