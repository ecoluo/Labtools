function colorbar = MY_get_FDR_for_spmT(spmT_file,FDR_pvalue)
head = spm_vol(spmT_file);
df_str = head.descrip(8:10);
df = str2double(df_str(isstrprop(df_str,'digit')));
% postive
map = spm_read_vols(head);
map(map==0) = [];
map(isnan(map)) = [];
map = 1*map;
map = sort(map(:),'descend');
ps = 1-spm_Tcdf(map,df);
thrmin_positive  = spm_uc_FDR(FDR_pvalue, [1 df],'T',1,ps,0);
map = spm_read_vols(head);
thrmax_positive = max(abs(map(:)));
% negative
map = spm_read_vols(head);
map(map==0) = [];
map(isnan(map)) = [];
map = -1*map;
map = sort(map(:),'descend');
ps = 1-spm_Tcdf(map,df);
thrmin_negative  = spm_uc_FDR(FDR_pvalue, [1 df],'T',1,ps,0);
map = spm_read_vols(head);
thrmax_negative = max(abs(map(:)));

colorbar = [-thrmax_negative,-thrmin_negative,thrmin_positive,thrmax_positive];
end