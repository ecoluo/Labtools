function [intensity, Mask_3D] = MY_FDR_Correction(statistic_file,method,q)

VspmSv = spm_vol(statistic_file);
VspmData = spm_read_vols(VspmSv);

handles.left_brace   = strfind(VspmSv.descrip,'{');
handles.right_brace  = strfind(VspmSv.descrip,'}');
handles.left_square  = strfind(VspmSv.descrip,'[');
handles.right_square = strfind(VspmSv.descrip,']');
handles.underline    = strfind(VspmSv.descrip,'_');

global TF df
TF = char      (VspmSv.descrip(handles.left_brace+1 :handles.underline-1   ));
df = str2double(VspmSv.descrip(handles.left_square+1:handles.right_square-1));

switch upper(method)
    case 'FDR'
        for pos_neg_ind = 1:2
            positive = -pos_neg_ind*2+3;
            Ts = VspmData;
            Ts(Ts==0) = [];
            Ts(isnan(Ts)) = [];
            Ts = positive*Ts;
            Ts = sort(Ts(:),'descend');
            if TF == 'T'
                ps = t2p(Ts, df, TF);
                intensity(pos_neg_ind)  = spm_uc_FDR(q, [1 df],TF,1,ps,0)*positive;
%                 pvalue(pos_neg_ind) = t2p(intensity, df, handles.TF{1});
            end
            if TF == 'F'
                ps = t2p(Ts, [df(1), df(2)], TF);
                intensity(pos_neg_ind)  = spm_uc_FDR(q, [df(1), df(2)],TF,1,ps,0)*positive;
                % pvalue(pos_neg_ind) = t2p(intensity, [df(1), df(2)], TF);
            end
        end
    case 'FWE'
        for pos_neg_ind = 1:2
            positive = -pos_neg_ind*2+3;
            xSPM_ind = strfind(statistic_file(1:end-3),'\');
            try
                load([statistic_file(1:xSPM_ind(end)),'\SPM.mat']);
            catch
                error('Do find the corresponding SPM.mat')
            end
            S    = SPM.xVol.S;                  %-search Volume {voxels}
            R    = SPM.xVol.R;                  %-search Volume {resels}
            if TF == 'T'
                intensity(pos_neg_ind) = spm_uc(q,[1, df],TF,R,1,S)*positive;
                % pvalue(pos_neg_ind) = t2p(intensity, df, handles.TF{1});
            end
            if TF == 'F'
                intensity(pos_neg_ind) = spm_uc(q,[df(1), df{1}(2)],TF,R,1,S)*positive;
                % pvalue(pos_neg_ind) = t2p(intensity, [df(1), df(2)], TF);
            end
        end
    case 'NO'
        if TF == 'T'
            tvalue=tinv(1-q,df);
            intensity  = [tvalue,-tvalue];
        end
end
    Mask_3D = or(VspmData>intensity(1),VspmData<intensity(2));
end

function p = t2p(t, df, TF)
if ~iscell(t)
    if or( upper(TF)=='T' , upper(TF)=='S' )
        p = 1-spm_Tcdf(t,df);
    elseif upper(TF) == 'F'
        p = 1-spm_Fcdf(t,df);
    end
else
    for ii=1:length(t)
        p{ii} = t2p(t{ii},df{ii},TF{ii});
    end
end
end