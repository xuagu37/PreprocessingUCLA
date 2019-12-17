%%
clear
close all
path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin', ':/home/xuagu37/ANTs/bin/ANTS-build/Examples'];
setenv('PATH', path1);
setenv('ANTSPATH', '/home/xuagu37/ANTs/bin/ANTS-build/Examples');
listing = dir('/mnt/wd12t/Data_bank/UCLA/sub-*');

for i = 1:272
    
    %% Set dir
    T1_dir = [listing(i).folder, '/', listing(i).name, '/anat/',  listing(i).name, '_T1w.nii.gz'];
    current_dir = [listing(i).folder, '/', listing(i).name, '/dwi/'];
    dwi_dir = [current_dir, listing(i).name, '_dwi.nii.gz'];
    
    if (exist(dwi_dir, 'file'))
        
        %% Bet
        b0_dir = [current_dir, listing(i).name, '_b0.nii.gz'];
        T1_brain_dir = [listing(i).folder, '/', listing(i).name, '/anat/',  listing(i).name, '_T1w_brain.nii.gz'];
        
        system(['fslroi ', dwi_dir, ' ', b0_dir, ' ', ' 0 1']);
        system(['bet ', T1_dir, ' ', T1_brain_dir, ' -m -f 0.3 -g -0.29']);
        
        %% Head motion correction
        dwi_head_motion_corrected_dir = [current_dir, listing(i).name, '_dwi_head_motion_corrected.nii.gz'];
        
        system(['eddy_correct ', dwi_dir, ' ', dwi_head_motion_corrected_dir, ' 0']);
        
        %% antsIntermodalityIntrasubject.sh + antsRegistrationSyN.sh
        system(['mkdir -p ', current_dir, 'ANTS/']);
        
        ANTS_dir = [current_dir, 'ANTS/'];
        MNI152_brain_dir = '/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz';
        b02t1_dir = [ANTS_dir, 'b02t1'];
        t12mni_dir = [ANTS_dir, 't12mni'];
        dwi2mni_dir = [ANTS_dir, 'dwi2mni.nii.gz'];
        b02t1_mat_dir = [ANTS_dir, 'b02t10GenericAffine.mat'];
        b02t1_warp_dir = [ANTS_dir, 'b02t11Warp.nii.gz'];
        t12mni_mat_dir = [ANTS_dir, 't12mni0GenericAffine.mat'];
        t12mni_warp_dir = [ANTS_dir, 't12mni1Warp.nii.gz'];        
        T1_brain_mask_dir = [listing(i).folder, '/', listing(i).name, '/anat/',  listing(i).name, '_T1w_brain_mask.nii.gz'];
        
        system(['antsIntermodalityIntrasubject.sh -d 3 -r ', T1_brain_dir, ' -i ', b0_dir, ' -x ', T1_brain_mask_dir, ' -t 2 -o ', b02t1_dir]);
        system(['antsRegistrationSyN.sh -d 3 -f ', MNI152_brain_dir, ' -m ', T1_brain_dir, ' -o ', t12mni_dir, ' -n 10']);
        system(['antsApplyTransforms -d 3 -r ', MNI152_brain_dir, ' -i ', dwi_head_motion_corrected_dir, ' -e 3 -t ', t12mni_warp_dir,...
            ' -t ', t12mni_mat_dir, ' -t ', b02t1_warp_dir, ' -t ', b02t1_mat_dir, ' -o ', dwi2mni_dir]);
             
        
        
    end
end



