import os
from termcolor import colored

# initialize colored console output
if os.name != "posix":
	os.system("color")

# execute unit tests and generate code coverage report
print(colored("\n====== EXECUTE PYTEST ======", "blue"))
os.system("coverage run --source=. -m unittest discover")
print(colored("\n====== CODE COVERAGE REPORT ======", "blue"))
os.system("coverage report -m --omit=executeDevTests.py")

# execute mypy type check
print(colored("\n====== EXECUTE MYPY TYPE CHECK ======", "blue"))
os.system("python -m mypy .")

# execute radon code metric checks
print(colored("\n====== EXECUTE RADON CYCLOMATIC COMPLEXITY ======", "blue"))
os.system("radon cc . -a -nc")

# execute pycodestyle
print(colored("\n====== EXECUTE PYCODESTYLE ======", "blue"))
os.system("python -m pycodestyle --ignore=E501 .")