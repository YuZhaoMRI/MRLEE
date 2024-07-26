inputdir='E:/cyh_matlab/HCPdata/Dtseries_file/S1200_Retest/Retest/Motor/';
outputdir ='E:/cyh_matlab/HCPdata/volumeseries_file/S1200_Retest/Retest/Motor/';
surf2vol(inputdir,outputdir)
root = 'E:/cyh_matlab/HCPdata/volumeseries_file/S1200_Retest/Retest/Motor/';
list = dir(outputdir);
list = list(3:end);

for i = 2:41
    fprintf('%d\n',i);

    mkdir([outputdir,list(i).name,'/1st_leval']);

    tagetpath = fullfile(outputdir,list(i).name,'/1st_leval');
    fmri_motor_1 = fullfile(outputdir,list(i).name,'surf2vol_LR_Motor.nii');
    fmri_motor_2 = fullfile(outputdir,list(i).name,'surf2vol_RL_Motor.nii');
    f_fmri_total={fmri_motor_1,fmri_motor_2};

    matlabbatch = preproc(tagetpath,f_fmri_total);
    spm_jobman('run',matlabbatch)

end
%% 每个任务开始的时间点，可以参考spm_matlabbatch_langguage_1st_level.m 文件通过读取txt文件来获取起始的序列时间点

function matlabbatch = preproc(tagetpath,f_fmri_total)

    matlabbatch{1}.spm.stats.fmri_spec.dir = {tagetpath};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.72;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {f_fmri_total{1}};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'cue';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = [8.037
                                                                23.164
                                                                38.291
                                                                53.419
                                                                68.546
                                                                98.667
                                                                113.794
                                                                128.921
                                                                159.042
                                                                174.169];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'lf';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = [26.136
                                                                116.766];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'rf';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = [56.391
                                                                177.141];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'lh';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = [71.518
                                                                162.014];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).name = 'rh';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = [10.996
                                                                131.893];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).name = 't';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).onset = [41.263
                                                                101.639];
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {f_fmri_total{2}};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'cue';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = [8.05
                                                                23.177
                                                                53.311
                                                                68.425
                                                                83.552
                                                                113.673
                                                                128.801
                                                                143.928
                                                                159.055
                                                                174.182];
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'lf';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = [71.397
                                                                177.154];
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).name = 'rf';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = [26.149
                                                                146.9];
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).name = 'lh';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).onset = [11.009
                                                                116.645];
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).name = 'rh';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).onset = [86.525
                                                                162.027];
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).name = 't';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).onset = [56.27
                                                                131.773];
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).duration = 12;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).orth = 1;
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'GLM_lf';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 0.5 0 0 0 0 0 0.5 0 0 0 0];  %这里cue因为没有计算，所以设置未0，一开始也可以直接部要这部分的条件
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'GLM_rf';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0.5 0 0 0 0 0 0.5 0 0 0];  %这里cue因为没有计算，所以设置未0，一开始也可以直接部要这部分的条件
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'GLM_lh';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0.5 0 0 0 0 0 0.5 0 0];  %这里cue因为没有计算，所以设置未0，一开始也可以直接部要这部分的条件
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'GLM_rh';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 0.5 0 0 0 0 0 0.5 0];  %这里cue因为没有计算，所以设置未0，一开始也可以直接部要这部分的条件
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'GLM_t';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 0 0.5 0 0 0 0 0 0.5];  %这里cue因为没有计算，所以设置未0，一开始也可以直接部要这部分的条件
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{3}.spm.stats.con.delete = 0;
end