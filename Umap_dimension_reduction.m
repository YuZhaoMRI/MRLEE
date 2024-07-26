function Umap_dimension_reduction
data_nii=ft_read_cifti('F:\experiment_data\Similarity_test\Group\Emotion\Similarity_Groupttest_tmap_withmean_withmod_len30_t1_norand_fear_mu30_b128_m40_EMOTION.dtseries.dtseries.nii');
map_face=data_nii.dtseries(:,1)';
map_face=[find(map_face>0),find(map_face<0)];
data_nii=ft_read_cifti('F:\experiment_data\Similarity_test\Group\Emotion\Similarity_Groupttest_tmap_withmean_withmod_len30_t1_norand_neut_mu30_b128_m40_EMOTION.dtseries.dtseries.nii');
map_shape=data_nii.dtseries(:,1)';
map_shape=[find(map_shape>0),find(map_shape<0)];
map=unique([map_face,map_shape]);

N_mask=64984;
data_nii=ft_read_cifti('F:\experiment_data\Allframe_activationmap\coherence_ave80_LR_time176_mu30_b128_m40_EMOTION.dtseries.dtseries.nii');
X_voi_LR=data_nii.dtseries;
data_nii=ft_read_cifti('F:\experiment_data\Allframe_activationmap\coherence_ave80_RL_time176_mu30_b128_m40_EMOTION.dtseries.dtseries.nii');
X_voi_RL=data_nii.dtseries(:,1:176);
data_mapping=[X_voi_LR(map,:),X_voi_RL(map,:)];


[reduction, umap, clusterIdentifiers, extras]=run_umap(data_mapping,'n_neighbors',20,'spread',0.8,...
    'qf_dissimilarity','true','cluster_output','graphic','NSMethod','exhaustive','cluster_method_2D','dbm',...
    'cluster_detail'  ,'very high','metric','cosine','n_components',2,'contour_percent',0.0,'min_dist',0.1);

%%
X_voi=data_nii.dtseries;
X_voi=X_voi.*0;
for i=1:max(clusterIdentifiers)
    X_voi(map(find(clusterIdentifiers==i)),1)=i;
end
data_nii.dtseries=X_voi;
ft_write_cifti('G:\cyh_matlab\clusterIdentifiers_roi.dtseries.nii',data_nii,'parameter','dtseries');
