# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

# create a temporary copy of the code to build the package
rm -rf tmp_package_build_dir
mkdir -p tmp_package_build_dir
cp -r * tmp_package_build_dir

# modify folder structure to install DiscoPoP to /opt when installing the package
cd tmp_package_build_dir
mkdir opt
mkdir opt/DiscoPoP

mv * opt/DiscoPoP
mv opt/DiscoPoP/DEBIAN .

# add the Version tag to DEBIAN/control.raw to create DEBIAN/control
echo "$(cat DEBIAN/control.raw)" > DEBIAN/control
echo "Version: $(cat opt/DiscoPoP/discopop_library/global_data/version/VERSION)" >> DEBIAN/control
echo "" >> DEBIAN/control

# delete build folder if exists
rm -rf opt/DiscoPoP/build
# delete packages folder if exists
rm -rf opt/DiscoPoP/packages
# delete venv folder if exists
rm -rf opt/DiscoPoP/venv
# cleanup
rm -rf opt/DiscoPoP/tmp_packages_build_dir

# create packages folder
cd ..
mkdir -p packages
# build package
VERSION=$(cat discopop_library/global_data/version/VERSION)
PACKAGE_NAME="discopop-${VERSION}.deb"
dpkg-deb --build tmp_package_build_dir packages/${PACKAGE_NAME}
chmod 775 packages/${PACKAGE_NAME}

# cleanup
rm -rf tmp_package_build_dir
