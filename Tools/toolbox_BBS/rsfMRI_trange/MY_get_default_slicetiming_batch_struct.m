function SliceTiming_mlb = MY_get_default_slicetiming_batch_struct(all_func,Nslice,TR,reference_number)
    SliceTiming_mlb{1}.spm.temporal.st.scans = all_func;
    SliceTiming_mlb{1}.spm.temporal.st.nslices = Nslice;
    SliceTiming_mlb{1}.spm.temporal.st.tr = TR;
    SliceTiming_mlb{1}.spm.temporal.st.ta = TR-TR/Nslice;
    SliceTiming_mlb{1}.spm.temporal.st.so = [1:2:Nslice 2:2:Nslice];
    SliceTiming_mlb{1}.spm.temporal.st.refslice = reference_number;
    SliceTiming_mlb{1}.spm.temporal.st.prefix = 's';
end