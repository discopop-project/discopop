import requests
import pkg_resources  # part of setuptools
from packaging.version import Version

def run()->None:
    print("Checking for updates..")
    try:
        # read current version    
        version = pkg_resources.require("hotspot_analyzer")[0].version
        # read latest version
        url="https://api.github.com/repos/discopop-project/Hotspot-Detection/releases/latest"
        response = requests.get(url).json()
        latest_tag_name = response["tag_name"]
        if latest_tag_name.startswith("v"):
            latest_version = latest_tag_name[1:]
        else:
            latest_version = latest_tag_name
        # compare semantic versioning
        if(Version(latest_version) > Version(version)):
            print("\tA newer version was found!")
            print("\tInstalled:", version)
            print("\tLatest:   ", latest_version)
        else:
            print("\tdone.")

    except Exception as ex:
        print("\tfailed with: " + str(ex))

