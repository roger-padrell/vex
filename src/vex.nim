import vex/init, os

var arguments = commandLineParams()

if arguments[0] == "init":
  init(arguments[1])