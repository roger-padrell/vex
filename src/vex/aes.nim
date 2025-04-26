import nimAES, strutils, std/algorithm

const paddingChar: char = '.'

proc countLeading*(s: string, subs: char): int =
    result = 0
    for c in s:
        if c == subs:
            inc(result)
        else:
            break

proc paddingKey(original: string, target: int = 16): string = 
    let olen = original.len();
    if olen == target:
        return original;
    elif olen < target:
        let change = target-olen;
        return original & paddingChar.repeat(change)
    else:
        return original[0..target-1]
 
proc paddingBlock(original: string, blockSize: int = 16): string = 
    let olen = original.len();
    if float(int(olen/blockSize)) == float(olen/blockSize):
        return original;
    else:
        let targetSize = (int(olen/blockSize)*blockSize)+(1*blockSize);
        let change = targetSize-olen;
        return original & paddingChar.repeat(change)

proc removeBlockPadding(withPadding: string): string = 
    var without = withPadding.reversed().join("");
    without.removePrefix(paddingChar.repeat(without.countLeading(paddingChar)))
    return without.reversed().join("")

proc encryptData*(data: string, key: string): string = 
    # Padding key and data
    let pkey = paddingKey(key)
    let pdata = paddingBlock(data)
    let iv = pkey.reversed().join("")
    var aes = initAES()
    discard aes.setEncodeKey(pkey)

    return aes.encryptCBC(iv, pdata)

proc decryptData*(encrypted: string, key: string): string = 
    # Padding key and data
    let pkey = paddingKey(key)
    let pdata = paddingBlock(encrypted)
    let iv = $pkey.reversed().join("")
    var aes = initAES()
    discard aes.setDecodeKey(pkey)
    
    let decrypted = aes.decryptCBC(iv, pdata)
    return decrypted.removeBlockPadding();