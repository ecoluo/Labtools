function [ALFFBrain,FalffBrain] = MY_falff(AllVolume, Mask,TR)
%%%%%%%%%%%%%%%%%% fALFF %%%%%%%%%%%%%%%%

[nDim1, nDim2, nDim3, nDimTimePoints]=size(AllVolume);
MaskData=Mask;
% Convert into 2D
AllVolume=reshape(AllVolume,[],nDimTimePoints)';
MaskDataOneDim=reshape(MaskData,1,[]);
AllVolume=AllVolume(:,find(MaskDataOneDim));
ASamplePeriod=TR;      %%%可能会根据不同的扫描条件修改 ，此处为TR时间
sampleFreq 	 = 1/ASamplePeriod;
sampleLength = nDimTimePoints;
paddedLength =2^nextpow2(sampleLength);
LowCutoff=0.005;%%%%%%%%通常0.01
HighCutoff=0.1; %%%%%%%%通常0.08
if (LowCutoff >= sampleFreq/2) % All high included
    idx_LowCutoff = paddedLength/2 + 1;
else % high cut off, such as freq > 0.01 Hz
    idx_LowCutoff = ceil(LowCutoff * paddedLength * ASamplePeriod + 1);
    % Change from round to ceil: idx_LowCutoff = round(LowCutoff *paddedLength *ASamplePeriod + 1);
end
if (HighCutoff>=sampleFreq/2)||(HighCutoff==0) % All low pass
    idx_HighCutoff = paddedLength/2 + 1;
else % Low pass, such as freq < 0.08 Hz
    idx_HighCutoff = fix(HighCutoff *paddedLength *ASamplePeriod + 1);
    % Change from round to fix: idx_HighCutoff	=round(HighCutoff *paddedLength *ASamplePeriod + 1);
end
%AllVolume=detrend(AllVolume);
AllVolume = [AllVolume;zeros(paddedLength -sampleLength,size(AllVolume,2))]; %padded with zero
fprintf('\n\t Performing FFT ...');
AllVolume = 2*abs(fft(AllVolume))/sampleLength;

ALFF_2D = mean(AllVolume(idx_LowCutoff:idx_HighCutoff,:));
% Get the 3D brain back
ALFFBrain = zeros(size(MaskDataOneDim));
ALFFBrain(1,find(MaskDataOneDim)) = ALFF_2D;
ALFFBrain = reshape(ALFFBrain,nDim1, nDim2, nDim3);

fALFF_2D = sum(AllVolume(idx_LowCutoff:idx_HighCutoff,:)) ./ sum(AllVolume(2:(paddedLength/2 + 1),:));
fALFF_2D(~isfinite(fALFF_2D))=0;
fALFFBrain = zeros(size(MaskDataOneDim));
fALFFBrain(1,find(MaskDataOneDim)) = fALFF_2D;
FalffBrain = reshape(fALFFBrain,nDim1, nDim2, nDim3);
end

