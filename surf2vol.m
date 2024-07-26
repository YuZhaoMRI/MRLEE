function surf2vol(inputdir,outputdir)
N_mask = 64984;
volume_mask='E:/cyh_matlab/Coherence/HCP_data/Motor/105620/MNINonLinear/Results/tfMRI_MOTOR_LR/tfMRI_MOTOR_LR.nii.gz';
nii_str=load_nii(volume_mask);
vol1=double(nii_str.img);
vol_2d=reshape(vol1,91*109*91,size(vol1,4));
vol=vol_2d(:,1);
mask_index=find(vol>0);

load('mask25.mat');
Mask_N25_spar_1=Mask_N25_spar(1:30000,1:N_mask);
mask25=full(Mask_N25_spar_1);
mask25=mask25';
sum_mask=sum(mask25,1);
sum_mask(sum_mask==0)=1;
mask25=mask25./repmat(sum_mask,size(mask25,1),1);
mask25_1=single(mask25);

Mask_N25_spar_2=Mask_N25_spar(30001:N_mask,1:N_mask);
mask25=full(Mask_N25_spar_2);
mask25=mask25';
sum_mask=sum(mask25,1);
sum_mask(sum_mask==0)=1;
mask25=mask25./repmat(sum_mask,size(mask25,1),1);
mask25_2=single(mask25);

mask25=[mask25_1,mask25_2];
clear Mask_N25_spar_1 Mask_N25_spar_2 Mask_N25_spar mask25_1 mask25_2


Task='Motor';
fmri_type='rfMRI';
maindir ='E:/cyh_matlab/HCPdata/Dtseries_file/S1200_Retest/Retest/';
outputdir ='E:/cyh_matlab/HCPdata/volumeseries_file/S1200_Retest/Retest/';
subdir  = dir([maindir,Task]);
% subdir  = dir(maindir);

for i=3:length(subdir)
    disp(Task);disp(i-2);
    f1=subdir(i).name;

    root = [maindir,Task,'/',f1,'/MNINonLinear/Results/',fmri_type,'_',upper(Task1),'_RL/',fmri_type,'_',upper(Task1),'_RL_Atlas_MSMAll.dtseries.nii'];

    data_nii=ft_read_cifti(root);
    X_voi1=single(data_nii.dtseries);
    X_voi1(isnan(X_voi1))=0;
    X_voi1= X_voi1';

    %% remove first 5 ponits, smooth and detrend
    X_voi1=X_voi1(:,1:N_mask)*mask25;
    vol_2d=vol_2d.*0;
    vol_2d(mask_index(1:N_mask),:)=X_voi1';
    vol_new=reshape(vol_2d,91,109,91,size(vol1,4));
    nii_str.img=vol_new;
    if ~exist(fullfile(outputdir,Task,f1))
        mkdir(fullfile(outputdir,Task,f1));
    end
    file_n=fullfile(outputdir,Task,f1,'surf2vol_RL_Motor.nii');
    save_nii(nii_str,file_n);

end
end

