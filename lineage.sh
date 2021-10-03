#!/bin/bash

source ~/.profile

cd ~/android/lineage/.repo/local_manifests
git fetch
git reset --hard origin/lineage-18.1
cd ../..
repo sync -c --force-sync -j$(nproc) --no-tags --prune
###
cd build/soong
git reset --hard
git fetch https://github.com/masemoel/build_soong_legion-r 11
git cherry-pick b45c5ae22f74f1bdbb9bfbdd06ecf7a25033c78b
git cherry-pick e020f2130224fbdbec1f83e3adfd06a9764cca87
cd ../..
###
source build/envsetup.sh
mka clean
lunch lineage_dumpling-user
mka bacon -j$(nproc)
