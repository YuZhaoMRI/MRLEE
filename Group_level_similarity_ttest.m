function Group_level_similarity_ttest(Recon_data_dir,Task,task_par)
Task='Motor';
task_par='neut';
maindir ='E:\cyh_matlab\HCPdata\coherence_result\';
subdir  = dir([maindir,Task]);
task_similarity_80=[];
rest_similarity_80=[];
p_n_map=[];
for m=3:length( subdir )
    disp(Task);disp(m-2);
    f1=subdir( m ).name;
    
    filename=[Recon_data_dir,Task,'\',f1,'\MNINonLinear\Results\tfMRI_',upper(Task),'_LR\',upper(Task),'_LR_176frame_m40_b128_act_cc.mat'];
    load(filename);
    Task_LR=imag(act_cc);
    clear act_cc;

    filename=[Recon_data_dir,Task,'\',f1,'\MNINonLinear\Results\tfMRI_',upper(Task),'_RL\',upper(Task),'_RL_176frame_m40_b128_act_cc.mat'];
    load(filename);
    Task_RL=imag(act_cc);
    clear act_cc;

    filename=[Recon_data_dir,'Rest1','/',f1,'/MNINonLinear/Results/rfMRI_REST1_LR/REST1_LR_1200frame_m40_b128_act_cc.mat'];
    load(filename);
    Rest_LR=imag(act_cc(6:6+size(Task_LR,1)-1,:));
    clear act_cc;

    filename=[Recon_data_dir,'Rest1','/',f1,'/MNINonLinear/Results/rfMRI_REST1_RL/REST1_RL_1200frame_m40_b128_act_cc.mat'];
    load(filename);
    Rest_RL=imag(act_cc(6:6+size(Task_LR,1)-1,:));
    clear act_cc;
  
    fname_LR=[Recon_data_dir,Task,'\',f1,'\MNINonLinear\Results\tfMRI_EMOTION_LR\EVs\',task_par,'.txt'];
    fname_RL=[Recon_data_dir,Task,'\',f1,'\MNINonLinear\Results\tfMRI_EMOTION_RL\EVs\',task_par,'.txt'];
    data_LR=readmatrix(fname_LR);
    data_RL=readmatrix(fname_RL);

    mask=sum(Task_LR,1);
    mask=double(mask~=0);
    re_mask=find(mask~=0);
    no_mask=find(mask==0);
    
    task_len=round(data_LR(:,2)./0.72)+10;
    task_start_LR=round(data_LR(:,1)./0.72);
    task_start_RL=round(data_RL(:,1)./0.72);
    task_dur_LR=[task_start_LR+5,task_start_LR+task_len-1+5];
    task_dur_RL=[task_start_RL+5,task_start_RL+task_len-1+5];
    task_dur_LR(task_dur_LR(:,2)>size(Task_LR,1),:)=[];
    task_dur_RL(task_dur_RL(:,2)>size(Task_RL,1),:)=[];

    Task_volume_LR=[];
    for i=1:size(task_dur_LR,1)
        Task_volume_LR=[Task_volume_LR;[task_dur_LR(i,1):task_dur_LR(i,2)]];
    end
    Task_volume_RL=[];
    for i=1:size(task_dur_RL,1)
        Task_volume_RL=[Task_volume_RL;[task_dur_RL(i,1):task_dur_RL(i,2)]];
    end
    

    task_len=task_len(1);

block1=Task_LR(Task_volume_LR(1,:),:);
block2=Task_LR(Task_volume_LR(2,:),:);
block3=Task_RL(Task_volume_RL(1,:),:);
block4=Task_RL(Task_volume_RL(2,:),:);
task_sim_vec=cat(3,block1,block2,block3,block4);

task_sim_vec=task_sim_vec-repmat(mean(task_sim_vec,1),task_len,1,1);
task_sim_vec=task_sim_vec./repmat(sqrt(sum(task_sim_vec.^2,1)),task_len,1,1);
task_mean=mean(task_sim_vec,3);
mean_dist=sqrt(sum(task_mean.^2,1));
task_mean_4=repmat(task_mean,1,1,size(task_sim_vec,3));
task_similarity=mean_dist./mean(sqrt(sum((task_sim_vec-task_mean_4).^2,1)),3);
task_similarity_80=[task_similarity_80;task_similarity];

task_sim_vec=cat(3,block1,block2,block3,block4);
p_n=sum(task_sim_vec,1);p_n=sum(p_n,3);
p_n_map=[p_n_map;p_n];

rest_similarity_null500=[];
rest_similarity=[];
for i=1:1
    block1=Rest_LR(Task_volume_LR(1,:),:);
    block2=Rest_LR(Task_volume_LR(2,:),:);
    block3=Rest_RL(Task_volume_RL(1,:),:);
    block4=Rest_RL(Task_volume_RL(2,:),:);

    rest_sim_vec=cat(3,block1,block2,block3,block4);
    rest_sim_vec=rest_sim_vec-repmat(mean(rest_sim_vec,1),task_len,1,1);
    rest_sim_vec=rest_sim_vec./repmat(sqrt(sum(rest_sim_vec.^2,1)),task_len,1,1);
    rest_mean=mean(rest_sim_vec,3);
    mean_dist=sqrt(sum(rest_mean.^2,1));
    rest_mean_4=repmat(rest_mean,1,1,size(rest_sim_vec,3));
    rest_similarity=mean_dist./mean(sqrt(sum((rest_sim_vec-rest_mean_4).^2,1)),3);
    rest_similarity_null500=[rest_similarity_null500;rest_similarity];
end
rest_similarity_80=[rest_similarity_80;mean(rest_similarity_null500,1)];
end

p_n_map_80=sum(p_n_map,1);
p_n_map_80(p_n_map_80>0)=1;

p_n_map_80(p_n_map_80<0)=-1;
[h,p,ci,stats]=ttest(task_similarity_80(:,re_mask),rest_similarity_80(:,re_mask),'Tail','right');
t=stats.tstat;
[h1, crit_p1, adj_ci_cvrg1, p_fdr]=fdr_bh(p,0.05,'pdep','yes');
P_value=zeros(1,64984);T_value=zeros(1,64984);
P_value(re_mask)=p_fdr;P_value(no_mask)=nan;
T_value(re_mask)=t;T_value(no_mask)=nan;

dif = sum(task_similarity_80,1)-sum(rest_similarity_80,1);

A_voi=zeros(1,64984);
A_voi(P_value<0.05)=T_value(P_value<0.05);
A_voi=A_voi.*p_n_map_80;
N_mask=64984;
data_nii=ft_read_cifti('E:\cyh_matlab\Coherence\HCP_data\Motor\100206\tfMRI100206_MOTOR_LR_Atlas_MSMAll.dtseries.nii');
X_voi=single(data_nii.dtseries);
X_voi=X_voi';
X_voi=X_voi*0;
X_voi(1,1:N_mask)=A_voi(:,:);
X_voi(2,1:N_mask)=P_value;
X_voi(3,1:N_mask)=dif;
data_nii.dtseries=double(X_voi');
new_name=['E:\cyh_matlab\Similarity_Groupttest_kmap_withmean_withmod_len10_norand_',task_par,'_mu30_b128_m40_MOTOR.dtseries.nii'];
ft_write_cifti(new_name,data_nii, 'parameter', 'dtseries');



