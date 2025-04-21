type 
    Repo* = object
        name*: string
        owner*: string # User ID
        version*: string
        hosted*: bool = false
        origin*: string = ""
        editors*: seq[string] = @[]
