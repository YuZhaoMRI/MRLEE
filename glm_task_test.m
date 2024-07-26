
inputdir='E:\cyh_matlab\HCPdata\volumeseries_file\S1200_Retest\S1200\Motor\';
outputdir='E:\cyh_matlab\HCPdata\volumeseries_file\S1200_Retest\S1200\Motor\';
task_par='rf';
vol2surf(inputdir,outputdir,task_par);

input_dir='E:\cyh_matlab\HCPdata\volumeseries_file\S1200_Retest\Retest\Emotion\';
sublist=dir(outputdir);
N_mask = 64984;
glm_task=[];
for i=3:length(sublist)
    i
    name_f=[outputdir,sublist(i).name,'\glm_',task_par,'_Motor.dtseries.dtseries.nii'];
    data_nii=ft_read_cifti(name_f);
    X_voi=data_nii.dtseries;
    X_voi1=X_voi(1:N_mask,1)';
    glm_task=[glm_task;X_voi1];
end
no_mask=isnan(glm_task(1,:));
re_mask=~isnan(glm_task(1,:));
[h,p,ci,stats]=ttest(glm_task(:,re_mask));
t=stats.tstat;
p1=p;
p2=p;
p1(t<0)=0.5;
p2(t>0)=0.5;
[h1, crit_p1, adj_ci_cvrg1, p_fdr1]=fdr_bh(p1,0.05,'pdep','yes');
[h2, crit_p2, adj_ci_cvrg2, p_fdr2]=fdr_bh(p2,0.05,'pdep','yes');

P_value1=zeros(1,size(glm_task,2));
P_value2=zeros(1,size(glm_task,2));
P_value1(re_mask)=p_fdr1;P_value1(no_mask)=1;
P_value2(re_mask)=p_fdr2;P_value2(no_mask)=1;

T_map=zeros(1,size(glm_task,2));
T_map(re_mask)=stats.tstat;
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
new_name=['E:\cyh_matlab\glm_ttest_face_1_bhfdr_p005_mu30_b128_m40_MOTOR.dtseries.nii'];
ft_write_cifti(new_name,data_nii, 'parameter', 'dtseries');
