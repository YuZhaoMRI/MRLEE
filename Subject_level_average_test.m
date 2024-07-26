function Subject_level_average_test(Recon_data_dir,subject_id,Task,task_par)
Task='Motor';
task_par='neut';
Task_map=[];
Rest_map=[];
Rest_map_LR=[];Rest_map_RL=[];

f1=subject_id;

filename=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_LR/',upper(Task),'_LR_176frame_m40_b128_act_cc.mat'];
load(filename);
Task_LR=imag(act_cc);
clear act_cc;

filename=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_RL/',upper(Task),'_RL_176frame_m40_b128_act_cc.mat'];
load(filename);
Task_RL=imag(act_cc);
clear act_cc;

filename=[Recon_data_dir,'/','Rest1','/',f1,'/MNINonLinear/Results/rfMRI_REST1_LR/REST1_LR_1200frame_m40_b128_act_cc.mat'];
load(filename);
Rest_LR=imag(act_cc(6:5+size(Task_LR,1)*2,:));
clear act_cc;

fname_LR=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_LR/EVs/',task_par,'.txt'];
fname_RL=[Recon_data_dir,Task,'/',f1,'/MNINonLinear/Results/tfMRI_',upper(Task),'_RL/EVs/',task_par,'.txt'];
data_LR=readmatrix(fname_LR);
data_RL=readmatrix(fname_RL);

mask=sum(Task_LR,1);
mask=double(mask~=0);
re_mask=find(mask~=0);
no_mask=find(mask==0);

task_dur_LR=round([data_LR(1:2,1),data_LR(1:2,1)+data_LR(1:2,2)]./0.72)+6;
task_dur_RL=round([data_RL(1:2,1),data_RL(1:2,1)+data_RL(1:2,2)]./0.72)+6;
task_dur_LR(task_dur_LR(:,2)>size(Task_LR,1),:)=[];
task_dur_RL(task_dur_RL(:,2)>size(Task_RL,1),:)=[];


Task_volume_LR=[];
for i=1:size(task_dur_LR,1)
    Task_volume_LR=[Task_volume_LR,[task_dur_LR(i,1):task_dur_LR(i,2)]];
end
Task_volume_RL=[];
for i=1:size(task_dur_RL,1)
    Task_volume_RL=[Task_volume_RL,[task_dur_RL(i,1):task_dur_RL(i,2)]];
end

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

    if null_num>500
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

    if null_num>500
        break;
    end
end

sub_LR_Task=Task_LR(Task_volume_LR,:);
sub_RL_Task=Task_RL(Task_volume_RL,:);
ave_t_task=mean([sub_LR_Task;sub_RL_Task],1);
Task_map=ave_t_task;

for i=1:500
    Rest_map=cat(1,Rest_map,mean([Task_LR(null500_timespace_LR(i,:),:);Task_RL(null500_timespace_RL(i,:),:)],1));
end

ac_mask=[];
P_value=[];
 for i=1:length(re_mask)
     i
     null_data=sort(Rest_map(:,re_mask(i)));
     
     [f,xi]=ksdensity(null_data,'Function','cdf','NumPoints',1000);
     [~,index]=min(abs(f-0.975));
     P_pos=xi(index);
     [~,index]=min(abs(f-0.025));
     P_neg=xi(index);
     [~,index]=min(abs(Task_map(1,re_mask(i))-xi));
     if f(index)>0.5
         p=(1-f(index))*2;
     else
         p=f(index)*2;
     end
     P_value=[P_value,p];
     if Task_map(1,re_mask(i))>P_pos
         ac_mask=[ac_mask,re_mask(i)];
     elseif Task_map(1,re_mask(i))<P_neg
         ac_mask=[ac_mask,re_mask(i)];
     end
 end

dif_map=ave_t_task-mean(Rest_map,1);
A_voi=dif_map;
N_mask=64984;
data_nii=ft_read_cifti('E:\cyh_matlab\Coherence\HCP_data\Motor\100206\tfMRI100206_MOTOR_LR_Atlas_MSMAll.dtseries.nii');
X_voi=single(data_nii.dtseries);
X_voi=X_voi';
X_voi=X_voi*0;
X_voi(1,ac_mask)=A_voi(:,ac_mask);
X_voi(2,re_mask)=P_value;
X_voi(3,1:N_mask)=dif_map;
data_nii.dtseries=double(X_voi');
new_name=['E:\cyh_matlab\nullmodel_new_no1_d6frame_rand500_',task_par,'_mu30_b128_m40_EMOTION.dtseries.nii'];
ft_write_cifti(new_name,data_nii, 'parameter', 'dtseries'); 
