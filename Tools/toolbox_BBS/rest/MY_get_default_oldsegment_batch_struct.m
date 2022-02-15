function T2segment_mlb=MY_get_default_oldsegment_batch_struct(rawimage, TPMmodelpath) 
    T2segment_mlb{1}.spm.tools.oldseg.data = rawimage;
    T2segment_mlb{1}.spm.tools.oldseg.output.GM = [1 0 0];
    T2segment_mlb{1}.spm.tools.oldseg.output.WM = [1 0 0];
    T2segment_mlb{1}.spm.tools.oldseg.output.CSF = [0 0 0];
    T2segment_mlb{1}.spm.tools.oldseg.output.biascor = 1;
    T2segment_mlb{1}.spm.tools.oldseg.output.cleanup = 0;
    T2segment_mlb{1}.spm.tools.oldseg.opts.tpm = {
        [TPMmodelpath 'TMBTA_Grey.nii,1']
        [TPMmodelpath 'TMBTA_White.nii,1']
        [TPMmodelpath 'TMBTA_CSF.nii,1']
        };
    T2segment_mlb{1}.spm.tools.oldseg.opts.ngaus = [2;2;2;4];
        
    T2segment_mlb{1}.spm.tools.oldseg.opts.regtype = 'subj';
    T2segment_mlb{1}.spm.tools.oldseg.opts.warpreg = 1;
    T2segment_mlb{1}.spm.tools.oldseg.opts.warpco = 25;
    T2segment_mlb{1}.spm.tools.oldseg.opts.biasreg = 0.0001;
    T2segment_mlb{1}.spm.tools.oldseg.opts.biasfwhm = 60;
    T2segment_mlb{1}.spm.tools.oldseg.opts.samp = 3;
    T2segment_mlb{1}.spm.tools.oldseg.opts.msk = {''};
end