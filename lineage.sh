#!/bin/bash

source ~/.profile

cat << EOF
+++ Updating local_manifests...

EOF
cd ~/android/lineage/.repo/local_manifests
git fetch
git reset --hard origin/lineage-18.1
cd ../..
cat << EOF

+++ Updating repositories...

EOF
repo sync -c --force-sync -j$(nproc) --no-tags --prune
###
cat << EOF

+++ Patching build/soong...

EOF
cd build/soong
git reset --hard
git fetch https://github.com/masemoel/build_soong_legion-r 11
git cherry-pick b45c5ae22f74f1bdbb9bfbdd06ecf7a25033c78b
git cherry-pick e020f2130224fbdbec1f83e3adfd06a9764cca87
cat << EOF

+++ Patching build/core...

EOF
cd ../core
wget https://github.com/kylothow/android_build/commit/a6464bdbdc356c8be63cbad6bdd9cbab51cf76d6.patch
patch -N < a6464bdbdc356c8be63cbad6bdd9cbab51cf76d6.patch
rm a6464bdbdc356c8be63cbad6bdd9cbab51cf76d6.patch
rm -f Makefile.rej
cd ../..
###
source build/envsetup.sh
cat << EOF

+++ Cleaning previous build...

EOF
mka clean -j$(nproc)
cat << EOF
+++ Preparing build...

EOF
lunch lineage_dumpling-user
cat << EOF

+++ Starting build...

EOF
mka bacon -j$(nproc)
