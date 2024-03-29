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
        
        %% Method 1 antsIntermodalityIntrasubject.sh + antsRegistrationSyN.sh
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
        
        
        %% Method 2, epi_reg + flirt + fnirt
        system(['mkdir -p ', current_dir, 'FSL/']);
        
        FSL_dir = [current_dir, 'FSL/'];
        b02t1_dir = [FSL_dir, 'b02t1'];
        b02t1_mat_dir = [FSL_dir, 'b02t1.mat'];               
        t12mni_dir = [FSL_dir, 't12mni.nii.gz'];
        t12mni_mat_dir = [FSL_dir, 't12mni.mat'];
        t12mni_nonlinear_warp_dir = [FSL_dir, 't12mni_nonlinear_warp.nii.gz'];
        t12mni_nonlinear_dir = [FSL_dir, 't12mni_nonlinear.nii.gz'];
        t12mni_head_nonlinear_dir = [FSL_dir, 't12mni_head_nonlinear.nii.gz'];
        b02mni_warp_dir = [FSL_dir, 'b02mni_warp.nii.gz'];
        dwi2mni_dir = [FSL_dir, 'dwi2mni.nii.gz'];
        
        system(['epi_reg --epi=',  b0_dir, ' --t1=', T1_dir, ' --t1brain=', T1_brain_dir, ' --out=', b02t1_dir]);
        system(['flirt -in ', T1_brain_dir, ' -ref ', MNI152_brain_dir, ' -out ', t12mni_dir, ' -omat ', t12mni_mat_dir]);
        system(['fnirt --iout=', t12mni_head_nonlinear_dir, ' --in=', T1_dir, ' --aff=', t12mni_mat_dir,...
            ' --cout=', t12mni_nonlinear_warp_dir, ' --iout=', t12mni_nonlinear_dir,...
            ' --config=/usr/local/fsl/etc/flirtsch/T1_2_MNI152_2mm', ' --ref=', MNI152_dir, ' --refmask=', MNI152_brain_mask_dir]);
        system(['convertwarp --ref=', MNI152_brain_dir, ' --premat=', b02t1_mat_dir, ' --warp1=', t12mni_nonlinear_warp_dir, ' --out=', b02mni_warp_dir]);
        system(['applywarp --ref=', MNI152_brain_dir, ' --in=', dwi_head_motion_corrected_dir, ' --out=', dwi2mni_dir, ' --warp=', b02mni_warp_dir]);
        
        
    end
end



