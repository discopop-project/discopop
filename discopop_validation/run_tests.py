import os
from termcolor import colored

# initialize colored console output
if os.name != "posix":
    os.system("color")

# execute unit tests and generate code coverage report
print(colored("\n====== EXECUTE PYTEST ======", "blue"))
os.system("coverage run --source=. -m unittest discover -s . -t ../..")
print(colored("\n====== CODE COVERAGE REPORT ======", "blue"))
os.system("coverage report -m --omit=executeDevTests.py")