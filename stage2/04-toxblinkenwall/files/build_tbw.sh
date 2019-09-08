#! /bin/bash

id -a
pwd

echo "==============================="
export _git_branch_=$(cat /_GIT_BRANCH_)
echo "GIT: current branch is:"
echo $_git_branch_
export _git_project_username_=$(cat /_GIT_PROJECT_USERNAME_)
echo "GIT: current username is:"
echo $_git_project_username_
echo "==============================="

cd /home/pi/
rm -Rf barcode_scan/.git # remove previous install
rm -Rf tmp/

git clone https://github.com/zoff99/barcode_scan tmp
cd tmp
git checkout "master"

cd ..
mkdir -p barcode_scan/
cp -a tmp/*  barcode_scan/
cp -a tmp/.gitignore barcode_scan/
cp -a tmp/.git barcode_scan/
rm -Rf tmp/

cd
export _HOME_="/home/pi/"
echo $_HOME_


export _SRC_=$_HOME_/src/
export _INST_=$_HOME_/inst/

export CF2=" -O3 -ggdb3 -marm -mtune=arm1176jzf-s -march=armv6 -mfpu=vfp -mfloat-abi=hard "
export CF3="" # " -funsafe-math-optimizations "
export VV1=" VERBOSE=1 V=1 "

echo "option: +NOcache+"
sudo rm -Rfv $_SRC_
sudo rm -Rfv $_INST_

mkdir -p $_SRC_
mkdir -p $_INST_
sudo chown -R pi:pi $_SRC_
sudo chown -R pi:pi $_INST_

export LD_LIBRARY_PATH=$_INST_/lib/
export PKG_CONFIG_PATH=$_INST_/lib/pkgconfig



cd $_HOME_/barcode_scan/

export WARN01=" -Wall -Wextra -Wno-unused-result -Wno-pointer-sign -Wno-unused-parameter -Wno-unused-variable "
export CFLAGS=" $WARN01 -std=gnu99 -I$_INST_/include/ \
  -L$_INST_/lib -O3 -g3 -fstack-protector-all -fPIC -export-dynamic "

gcc $CFLAGS \
scan_bar_codes.c \
-std=gnu99 \
-o scan_bar_codes

res2=$?

ls -hal scan_bar_codes
file scan_bar_codes
ldd scan_bar_codes


echo "dir looks like this :"
echo "----------------------------"
ls -al $_HOME_/barcode_scan/
echo "----------------------------"

## ----------------------------------------


cd $_HOME_

if [ $res2 -eq 0 ]; then
 echo "compile: OK"
else
 echo "compile: ** ERROR **"
 exit 2
fi


echo "build ready"
