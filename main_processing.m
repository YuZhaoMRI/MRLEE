
%% MRLEE fMRI resconstruction
MRLEE_recon(HCP_Rawdata_dir,Recon_data_dir);

%% Use average metric to perform subject level nullmodel test
Subject_level_average_test(Recon_data_dir,subject_id,Task,task_par);

%% Use average metric to perform group level T test
Group_level_average_ttest(Recon_data_dir,Task,task_par);

%% Use similarity metric to perform subject level nullmodel test
Subject_level_similarity_test(Recon_data_dir,subject_id,Task,task_par);

%% Use similarity metric to perform subject level T test
Group_level_similarity_ttest(Recon_data_dir,Task,task_par);

%% Use activation map of emotion to perform clustering via UMAP
Umap_dimension_reduction;
