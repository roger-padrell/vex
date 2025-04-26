import vex/init, os, vex/setup

var arguments = commandLineParams()

if arguments.len() == 0:
  echo "Use `vex help` to display the help message"
elif arguments[0] == "init":
  init(arguments[1])
elif arguments[0] == "setup":
  discard setup()
elif arguments[0] == "help":
  echo "Help is still in development. Read the documentation at https://roger-padrell.github.io/vex/"
else:
  echo "Use `vex help` to display the help message"