import tables

let hostTable*: Table[string,string] = initTable[string,string]();

var hostNames*: seq[string] = @[]

for k in keys(hostTable):
    hostNames.add(k)

hostNames.add("custom")