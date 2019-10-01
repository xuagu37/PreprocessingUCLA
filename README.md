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

## Install ART
Download and extract  
https://www.nitrc.org/projects/art/  
Set path  
```bash
export ARTHOME=/home/xuagu37/ART  
export PATH=$ARTHOME/bin:$PATH  
```

## Head motion correction

## Registration to a brain template  

### FSL(epi_reg + flirt + fnirt)
https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=FSL;2064419a.1506

### ANTS-SyN

### ART
ART only works for the datatype short.
