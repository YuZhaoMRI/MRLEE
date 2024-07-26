function Group_level_average_ttest(Recon_data_dir,Task,task_par)
Task='Motor';
maindir ='E:\cyh_matlab\HCPdata\coherence_result\';
subdir  = dir([maindir,Task]);
Task_LR=[];Rest_LR=[];
Task_RL=[];Rest_RL=[];
for i=3:length( subdir )
    disp(Task);disp(i-2);
    f1=subdir( i ).name;
    
    filename=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_LR/',upper(Task),'_LR_176frame_m40_b128_act_cc.mat'];
    load(filename);
    Task_LR=cat(3,Task_LR,imag(act_cc));
    clear act_cc;

    filename=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_RL/',upper(Task),'_RL_176frame_m40_b128_act_cc.mat'];
    load(filename);
    Task_RL=cat(3,Task_RL,imag(act_cc));
    clear act_cc;

    filename=[Recon_data_dir,'Rest1','/',f1,'/MNINonLinear/Results/rfMRI_REST1_LR/REST1_LR_1200frame_m40_b128_act_cc.mat'];
    load(filename);
    Rest_LR=cat(3,Rest_LR,imag(act_cc(6:5+size(Task_LR,1),:)));
    clear act_cc;
    
    filename=[Recon_data_dir,'Rest1','/',f1,'/MNINonLinear/Results/rfMRI_REST1_RL/REST1_RL_1200frame_m40_b128_act_cc.mat'];
    load(filename);
    Rest_RL=cat(3,Rest_RL,imag(act_cc(6:5+size(Task_LR,1),:)));
    clear act_cc;
end
mask=sum(sum(Task_LR(:,:,1:5),3),1);
mask=double(mask~=0);
re_mask=find(mask~=0);
no_mask=find(mask==0);

maindir='E:\cyh_matlab\HCPdata\coherence_result\';
subdir=dir([maindir,Task]);
subdir=subdir(3:end);
Task='Emotion';
task_par='neut';
Task_map=[];
Rest_map=[];
for m=1:length( subdir )
    m
    f1=subdir( m ).name;
    fname_LR=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_LR/EVs/',task_par,'.txt'];
    fname_RL=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_RL/EVs/',task_par,'.txt'];
    data_LR=readmatrix(fname_LR);
    data_RL=readmatrix(fname_RL);
    
    task_dur_LR=round([data_LR(1:2,1),data_LR(1:2,1)+data_LR(1:2,2)]./0.72)+6;
    task_dur_RL=round([data_RL(1:2,1),data_RL(1:2,1)+data_RL(1:2,2)]./0.72)+6;
    task_dur_LR(task_dur_LR(:,2)>size(Task_LR,1),:)=[];
    task_dur_RL(task_dur_RL(:,2)>size(Task_RL,1),:)=[];
    task_dur_LR(task_dur_LR(:,1)<0)=[];
    task_dur_RL(task_dur_RL(:,1)<0)=[];
    
    Task_volume_LR=[];
    for i=1:size(task_dur_LR,1)
        Task_volume_LR=[Task_volume_LR,[task_dur_LR(i,1):task_dur_LR(i,2)]];
    end
    Task_volume_RL=[];
    for i=1:size(task_dur_RL,1)
        Task_volume_RL=[Task_volume_RL,[task_dur_RL(i,1):task_dur_RL(i,2)]];
    end
    
    sub_task_run_LR=Task_LR(:,:,m);
    sub_task_run_RL=Task_RL(:,:,m);
    sub_rest_run_LR=Rest_LR(:,:,m);
    sub_rest_run_RL=Rest_RL(:,:,m);

    k=1;null_num=1;
    task_len=18;
    time_space=[];null500_timespace_LR=[];

    while(1)
        disp(null_num);
        ri=randi(size(Task_LR,1));
        if ri+task_len-1>size(Task_LR,1)
            continue;
        elseif intersect(time_space,[ri:ri+task_len-1])
            continue;
        elseif length(intersect(Task_volume_LR(1:18),[ri:ri+task_len-1]))>(task_len/4)
            continue;
        elseif length(intersect(Task_volume_LR(19:36),[ri:ri+task_len-1]))>(task_len/4)
            continue;
        else
            time_space=[time_space,[ri:ri+task_len-1]];
            k=k+1;
        end

        if k>2
            k=1;
            null500_timespace_LR=[null500_timespace_LR;time_space];
            time_space=[];
            null_num=null_num+1;
        end

        if null_num>1
            break;
        end
    end
    k=1;null_num=1;
    time_space=[];null500_timespace_RL=[];
    while(1)
        disp(null_num);
        ri=randi(size(Task_RL,1));
        if ri+task_len-1>size(Task_RL,1)
            continue;
        elseif intersect(time_space,[ri:ri+task_len-1])
            continue;
        elseif length(intersect(Task_volume_RL(1:18),[ri:ri+task_len-1]))>(task_len/4)
            continue;
        elseif length(intersect(Task_volume_RL(19:36),[ri:ri+task_len-1]))>(task_len/4)
            continue;
        else
            time_space=[time_space,[ri:ri+task_len-1]];
            k=k+1;
        end

        if k>2
            k=1;
            null500_timespace_RL=[null500_timespace_RL;time_space];
            time_space=[];
            null_num=null_num+1;
        end

        if null_num>1
            break;
        end
    end

    sub_LR_Task=sub_task_run_LR(Task_volume_LR,:);
    sub_RL_Task=sub_task_run_RL(Task_volume_RL,:);
    sub_LR_Rest=sub_rest_run_LR(null500_timespace_LR,:);
    sub_RL_Rest=sub_rest_run_RL(null500_timespace_RL,:);
    ave_t_task=mean([sub_LR_Task;sub_RL_Task],1);
    ave_t_rest=mean([sub_LR_Rest;sub_RL_Rest],1);
    Task_map=[Task_map;ave_t_task];
    Rest_map=[Rest_map;ave_t_rest];

end

[h,p,ci,stats]=ttest(Task_map(:,re_mask),Rest_map(:,re_mask));
t=stats.tstat;
p1=p;
p2=p;
p1(t<0)=0.5;
p2(t>0)=0.5;
[h1, crit_p1, adj_ci_cvrg1, p_fdr1]=fdr_bh(p1,0.05,'pdep','yes');
[h2, crit_p2, adj_ci_cvrg2, p_fdr2]=fdr_bh(p2,0.05,'pdep','yes');

P_value1=zeros(1,size(Task_map,2));
P_value2=zeros(1,size(Task_map,2));
P_value1(re_mask)=p_fdr1;P_value1(no_mask)=1;
P_value2(re_mask)=p_fdr2;P_value2(no_mask)=1;
T_map=zeros(1,size(Task_map,2));
T_map(re_mask)=t;
P_value=zeros(1,size(Task_map,2));
P_value(re_mask)=p;P_value(no_mask)=1;
T_map1=T_map.*double(P_value1<0.025);
T_map2=T_map.*double(P_value2<0.025);
T_map_new=T_map1+T_map2;

A_voi=T_map_new;
N_mask=64984;
data_nii=ft_read_cifti('E:\cyh_matlab\Coherence\HCP_data\Motor\100206\tfMRI100206_MOTOR_LR_Atlas_MSMAll.dtseries.nii');
X_voi=single(data_nii.dtseries);
X_voi=X_voi';
X_voi=X_voi*0;
X_voi(1,1:N_mask)=A_voi;
data_nii.dtseries=double(X_voi');
new_name=['E:\cyh_matlab\Groupttes_new_tmap_neut_bhfdr_p005_mu30_b128_m40_',upper(Task),'.dtseries.nii'];
ft_write_cifti(new_name,data_nii, 'parameter', 'dtseries');






