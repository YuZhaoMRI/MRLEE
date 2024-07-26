function MRLEE_recon(inputdir,outputdir)

maindir ='/media/huaxi/Elements1/HCPdata/Dtseries_file/';
outputdir='T:/fMRI_reconstruction_result/Motor/';

N_mask = 64984;
harmonics_nii=ft_read_cifti('./harmonics_normalized.dtseries.dtseries.nii');
eigenmap=single(harmonics_nii.dtseries);
eigenmap=eigenmap(1:N_mask,1:100);

%% load mask 
load('mask_p20.mat');
Mask_p20_spar_1=Mask_p20_spar(1:N_mask,1:30000);
mask_sm_1=full(Mask_p20_spar_1);
mask_sm_1=abs(mask_sm_1);
mask_sm_1=single(mask_sm_1);


Mask_p20_spar_2=Mask_p20_spar(1:N_mask,30001:N_mask);
mask_sm_2=full(Mask_p20_spar_2);
mask_sm_2=abs(mask_sm_2);
mask_sm_2=single(mask_sm_2);

mask_sm=[mask_sm_1,mask_sm_2];
clear Mask_p20_spar_1 Mask_p20_spar_2 Mask_p20_spar mask_sm_1 mask_sm_2

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


gw=gausswin(7,1.8);
gw=gw/sum(gw);
figure
plot(gw);

Task='Motor';
fmri_type='tfMRI';
subdir  = dir([maindir,Task]);
for i=3:length(subdir)
    disp(Task);disp(i-2);
    f1=subdir(i).name;

    root = [maindir,Task,'/',f1,'/MNINonLinear/Results/',fmri_type,'_',upper(Task1),'_RL/',fmri_type,'_',upper(Task1),'_RL_Atlas_MSMAll.dtseries.nii'];
    data_nii=ft_read_cifti(root);
    X_voi1=single(data_nii.dtseries);

    X_voi1(isnan(X_voi1))=0;    
    X_voi1= X_voi1';

    X_voi1 = X_voi1(1:end,1:N_mask); 
    X_voi1=X_voi1*mask25;
    X_voi1 = detrend(X_voi1,2); 
    clear mask25 

    %% z-score 1
    [Nt N]=size(X_voi1);
    mean_voi=mean(X_voi1);
    X_voi1=X_voi1-repmat(mean_voi,Nt,1);
    std_voi=std(X_voi1);
    std_voi(std_voi==0)=1;
    X_voi1=X_voi1./repmat(std_voi,Nt,1);
    X_voi1(isnan(X_voi1))=0;

    %% sigmoid function 
    mu = @(x,a)  (1./(1 + exp(-a*x))-0.5)*pi;  % tunable sigmoid function
    Xs_voi = mu(X_voi1, 3.0);
    clear X_voi1

    %% sum in 25 neighborhood
    act_ab=zeros(size(Xs_voi));
    act_cc=zeros(size(Xs_voi));
    for m=1:40
    eigen_vector=single(eigenmap(:,m));
    eigen_mask=(repmat(eigen_vector,1,N_mask)-repmat(eigen_vector',N_mask,1));
    eigen_mask=exp(-eigen_mask.^2./128);
    mask49=mask_sm.*eigen_mask;
    mask49=mask49(1:N_mask,1:N_mask);
    sum_mask=sum(mask49,1);
    sum_mask(sum_mask==0)=1;
    mask49=mask49./repmat(sum_mask,size(mask49,1),1);
    
    Xc_voi=exp(Xs_voi*1i);
    Xc_voi=Xc_voi*mask49;
    Xcc_voi=conv2(Xc_voi,gw,'same');
    Xim_voi=imag(Xcc_voi);
    
    Xab_voi=abs(Xcc_voi);
    
    % sum(Xab_voi(1,:)>act_ab(1,:))
    act_cc(Xab_voi>act_ab)=Xcc_voi(Xab_voi>act_ab);
    act_ab(Xab_voi>act_ab)=Xab_voi(Xab_voi>act_ab);
    clear eigen_mask Xc_voi Xcc_voi Xim_voi Xab_voi eigen_vector sum_mask mask49    
    end
    if ~exist([outputdir,'/',f1])
        mkdir([outputdir,'/',f1]);
    end
    filename=[outputdir,'/',f1,'/MNINonLinear/Results/',fmri_type,'_',upper(Task1),'_RL/',upper(Task1),'_RL_1200frame_m40_b128_act_cc.mat'];
    save(filename,'act_cc');
end



