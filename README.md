# PreprocessingUCLA  
We provide a preprocessing pipeline for the UCLA data (https://openneuro.org/datasets/ds000030/versions/00016).

## Install ANTs
```bash
cd ~  
git clone https://github.com/stnava/ANTs.git  
mkdir ~/ANTs/bin  
cp ~/PreprocessingUCLA/code/build.sh ~/ANTs/bin 
cd ~/ANTs/bin  
sh build.sh
```
Hit "c" and hit "c" again and hit "g", see https://github.com/ANTsX/ANTs/wiki/Compiling-ANTs-on-Linux-and-Mac-OS#run-cmake-to-configure-the-build  
Copy scripts to bin  
```bash
cp /home/xuagu37/ANTs/Scripts/. /home/xuagu37/ANTs/bin/ANTS-build/Examples   
```
Set path  
```bash
export ANTSPATH=/home/xuagu37/ANTs/bin/ANTS-build/Examples  
export PATH=${ANTSPATH}:$PATH  
```

