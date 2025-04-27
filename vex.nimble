# Package

version       = "0.1.0"
author        = "Roger Padrell Casar"
description   = "A GIT alternative"
license       = "MIT"
srcDir        = "src"
bin           = @["vex"]


# Dependencies

requires "nim >= 2.2.2"
requires "argon2 >= 1.1.0"
requires "libsha >= 1.0"
requires "termstyle >= 0.1.0"
requires "jsony >= 1.1.5"
requires "vexbox >= 0.2.2"
requires "curly >= 1.1.1"
requires "nimAES >= 0.1.2"
requires "serialization >= 0.2.6"