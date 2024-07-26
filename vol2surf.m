function vol2surf(inputdir,outputdir,task_par)
N_mask=64984;
volume_mask='E:/cyh_matlab/Coherence/HCP_data/Motor/105620/MNINonLinear/Results/tfMRI_MOTOR_LR/tfMRI_MOTOR_LR.nii.gz';
nii_str=load_nii(volume_mask);
vol1=double(nii_str.img);
vol_2d=reshape(vol1,91*109*91,size(vol1,4));
vol=vol_2d(:,1);
mask_index=find(vol>0);
%lf rf lh rh t
if task_par=='lf'
    volume_fname='beta_0001.nii';
    surface_fname='glm_lf_Motor.dtseries.nii';
elseif task_par=='rf'
    volume_fname='beta_0002.nii';
    surface_fname='glm_rf_Motor.dtseries.nii';
elseif task_par=='lh'
    volume_fname='beta_0003.nii';
    surface_fname='glm_lh_Motor.dtseries.nii';
elseif task_par=='rh'
    volume_fname='beta_0004.nii';
    surface_fname='glm_rh_Motor.dtseries.nii';
elseif task_par=='t'
    volume_fname='beta_0005.nii';
    surface_fname='glm_t_Motor.dtseries.nii';
end

sublist=dir(inputdir);
root='E:\cyh_matlab\Coherence\HCP_data\Motor\100206\tfMRI100206_MOTOR_LR_Atlas_MSMAll.dtseries.nii';
data_nii=ft_read_cifti(root);
X_voi=single(data_nii.dtseries);
X_voi=X_voi';
X_voi=X_voi*0;
for i=3:length(sublist)
    beta=load_nii([inputdir,sublist(i).name,'\1st_leval\',volume_fname]);
    beta=beta.img;
    beta_1d=reshape(beta,91*109*91,1);
    X_voi(1,1:N_mask)=beta_1d(mask_index(1:N_mask));
    
    if ~exist(fullfile(outputdir,sublist(i).name))
       mkdir(fullfile(outputdir,sublist(i).name));
    end

    new_name=[outputdir,sublist(i).name,'/',surface_fname];
    data_nii.dtseries=double(X_voi');
    ft_write_cifti(new_name,data_nii, 'parameter', 'dtseries');
end

