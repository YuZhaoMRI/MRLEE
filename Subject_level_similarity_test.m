function Subject_level_similarity_test(Recon_data_dir,subject_id,Task,task_par)
Task='Motor';
fmri_type='rfMRI';
task_par='neut';
maindir ='E:\cyh_matlab\HCPdata\coherence_result\';
subdir  = dir([maindir,Task]);
Task_map=[];
% Rest_map=[];

f1=subject_id;

filename=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_LR/',upper(Task),'_LR_176frame_m40_b128_act_cc.mat'];
load(filename);
Task_LR=imag(act_cc);
clear act_cc;

filename=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_RL/',upper(Task),'_RL_176frame_m40_b128_act_cc.mat'];
load(filename);
Task_RL=imag(act_cc);
clear act_cc;

filename=[Recon_data_dir,'Rest1','/',f1,'/MNINonLinear/Results/rfMRI_REST1_LR/REST1_LR_1200frame_m40_b128_act_cc.mat'];
load(filename);
Rest_LR=imag(act_cc(6:6+size(Task_LR,1)*4,:));
clear act_cc;

fname_LR=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_LR/EVs/',task_par,'.txt'];
fname_RL=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_RL/EVs/',task_par,'.txt'];
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
k=1;null_num=1;
task_len=task_len(1);
time_space=[];null100_timespace=[];
while(1)
    % disp(null_num);
    ri=randi(size(Rest_LR,1));
    if ri+task_len>size(Rest_LR,1)
        continue;
    elseif intersect(time_space,[ri:ri+task_len-1])
        continue;
    else
        time_space=[time_space,[ri:ri+task_len-1]];
        k=k+1;
    end

    if k>4
        k=1;
        null100_timespace=[null100_timespace;time_space];
        time_space=[];
        null_num=null_num+1;
    end

    if null_num>500
        break;
    end
end

block1=Task_LR(Task_volume_LR(1,:),:);
block2=Task_LR(Task_volume_LR(2,:),:);
block3=Task_RL(Task_volume_RL(1,:),:);
block4=Task_RL(Task_volume_RL(2,:),:);
task_sim_vec=cat(3,block1,block2,block3,block4);

task_sim_vec=task_sim_vec-repmat(mean(task_sim_vec,1),task_len,1,1);
task_sim_vec=task_sim_vec./repmat(sqrt(sum(task_sim_vec.^2,1)),task_len,1,1);
task_std=std(task_sim_vec,0,3);
task_std_4=repmat(task_std,1,1,size(task_sim_vec,3));
task_sim_vec=task_sim_vec./task_std_4;
task_sim_vec=task_sim_vec-repmat(mean(task_sim_vec,1),task_len,1,1);
task_sim_vec=task_sim_vec./repmat(sqrt(sum(task_sim_vec.^2,1)),task_len,1,1);
task_mean=mean(task_sim_vec,3);
mean_dist=sqrt(sum(task_mean.^2,1));
task_mean_4=repmat(task_mean,1,1,size(task_sim_vec,3));
task_similarity=mean_dist./mean(sqrt(sum((task_sim_vec-task_mean_4).^2,1)),3);
task_sim_vec=cat(3,block1,block2,block3,block4);
p_n=sum(task_sim_vec,1);p_n=sum(p_n,3);
p_n(p_n>0)=1;
p_n(p_n<0)=-1;

rest_similarity_null500=[];
rest_similarity=[];
for i=1:500

    block1=Rest_LR(null100_timespace(i,1:task_len),:);
    block2=Rest_LR(null100_timespace(i,task_len+1:task_len*2),:);
    block3=Rest_LR(null100_timespace(i,task_len*2+1:task_len*3),:);
    block4=Rest_LR(null100_timespace(i,task_len*3+1:task_len*4),:);

    rest_sim_vec=cat(3,block1,block2,block3,block4);
    rest_sim_vec=rest_sim_vec-repmat(mean(rest_sim_vec,1),task_len,1,1);
    rest_sim_vec=rest_sim_vec./repmat(sqrt(sum(rest_sim_vec.^2,1)),task_len,1,1);
    rest_sim_vec=rest_sim_vec./task_std_4;
    rest_sim_vec=rest_sim_vec-repmat(mean(rest_sim_vec,1),task_len,1,1);
    rest_sim_vec=rest_sim_vec./repmat(sqrt(sum(rest_sim_vec.^2,1)),task_len,1,1);
    rest_mean=mean(rest_sim_vec,3);
    mean_dist=sqrt(sum(rest_mean.^2,1));
    rest_mean_4=repmat(rest_mean,1,1,size(rest_sim_vec,3));
    rest_similarity=mean_dist./mean(sqrt(sum((rest_sim_vec-rest_mean_4).^2,1)),3);
    rest_similarity_null500=[rest_similarity_null500;rest_similarity];
end
rest_similarity=mean(rest_similarity_null500,1);


ac_mask=[];
P_value=[];
 for i=1:length(re_mask)
     i
     null_data=rest_similarity_null500(:,re_mask(i));
     [f,xi]=ksdensity(null_data,'Function','cdf','NumPoints',1000);
     [~,index]=min(abs(f-0.95));
     P_pos=xi(index);
     [~,index]=min(abs(f-0.05));
     P_neg=xi(index);
     [~,index]=min(abs(task_similarity(1,re_mask(i))-xi));
     p=1-f(index);
     P_value=[P_value,p];
     if task_similarity(1,re_mask(i))>P_pos
         ac_mask=[ac_mask,re_mask(i)];
     end
 end
[h1, crit_p1, adj_ci_cvrg1, p_fdr]=fdr_bh(P_value,0.05,'pdep','yes');
task_similarity_pn=(task_similarity-rest_similarity).*p_n;
A_voi=task_similarity_pn;
N_mask=64984;
data_nii=ft_read_cifti('E:\cyh_matlab\Coherence\HCP_data\Motor\100206\tfMRI100206_MOTOR_LR_Atlas_MSMAll.dtseries.nii');
X_voi=single(data_nii.dtseries);
X_voi=X_voi';
X_voi=X_voi*0;
X_voi(1,re_mask(P_value<0.05))=task_similarity_pn(re_mask(P_value<0.05));
X_voi(2,re_mask(p_fdr<0.05))=task_similarity_pn(re_mask(p_fdr<0.05));
X_voi(3,re_mask)=P_value;
X_voi(4,1:N_mask)=task_similarity_pn;
data_nii.dtseries=double(X_voi');
new_name=['E:\cyh_matlab\nullmodel_task_similarity_dif_pn_no',num2str(m-2),'_withstd_withfdr_',task_par,'_mu30_b128_m40_MOTOR.dtseries.nii'];
ft_write_cifti(new_name,data_nii, 'parameter', 'dtseries'); 





