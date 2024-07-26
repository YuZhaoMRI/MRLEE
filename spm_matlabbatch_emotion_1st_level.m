clear,clc

root = 'E:/cyh_matlab/HCPdata/volumeseries_file/S1200_Retest/S1200/Emotion/';
list = dir(root);
list = list(3:end);

for i = 1:41
    fprintf('%d\n',i);

    mkdir([root,list(i).name,'/1st_leval']);

    tagetpath = fullfile(root,list(i).name,'/1st_leval');
    fmri_emotion_1 = fullfile(root,list(i).name,'surf2vol_LR_Emotion.nii');
    fmri_emotion_2 = fullfile(root,list(i).name,'surf2vol_RL_Emotion.nii');
    f_fmri_total={fmri_emotion_1,fmri_emotion_2};

    matlabbatch = preproc(tagetpath,f_fmri_total);
    spm_jobman('run',matlabbatch)

end


function matlabbatch = preproc(tagetpath,f_fmri_total)

    matlabbatch{1}.spm.stats.fmri_spec.dir = {tagetpath};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.72;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {f_fmri_total{1}};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'neut';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = [10.995
                                                                53.138];
%                                                                 95.281];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 18;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'fear';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = [32.067
                                                                74.21];
%                                                                 116.353];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 18;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {f_fmri_total{2}};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'neut';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = [10.996
                                                                53.219];
%                                                                 95.415];
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = 18;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'fear';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = [32.094
                                                                74.291];
%                                                                 116.487];
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = 18;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'glm_shape';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0.5 0 0.5 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'glm_face';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0.5 0 0.5];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{3}.spm.stats.con.delete = 0;
end