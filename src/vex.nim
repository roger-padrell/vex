import vex/init, os, vex/setup, vex/clone, vex/cli, strutils, vex/commit, vex/branch

var arguments = commandLineParams()

if arguments.len() == 0:
  echo "Use `vex help` to display the help message"
elif arguments[0] == "init":
  init(arguments[1])
elif arguments[0] == "setup":
  discard setup()
elif arguments[0] == "clone":
  if arguments.len()>2:
    clone(arguments[1], arguments[2].split(".")[0], arguments[2].split(".")[1])
  elif arguments.len()>1:
    clone(arguments[1], "main", "lts")
  else:
    displayError "Missing arguments for `clone`"
elif arguments[0] == "commit":
  commit()
elif arguments[0] == "branch":
  branch()
elif arguments[0] == "setbranch" and arguments.len()>1:
  setBranch(arguments[1])
elif arguments[0] == "help":
  echo "Help is still in development. Read the documentation at https://roger-padrell.github.io/vex/"
else:
  echo "Use `vex help` to display the help message"