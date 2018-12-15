 %%%%%%%%%%%%I'd like to use three models to predict the combined responses
 %%%Model 1 : y = w_t*x_t +bias;
 %%%Model 2 : y = w_r*x_r +bias;
 %%%Model 3 : y = w_t*x_t +w_r*x_r +bias;
 %%%%%%% CZX 20150407

 A=[]; B=[]; Aeq=[]; Beq=[]; NONLCON=[];
OPTIONS = optimset('fmincon');
OPTIONS = optimset('LargeScale', 'off', 'LevenbergMarquardt', 'on',... 
'MaxIter', 5000, 'Display', 'off', 'Algorithm', 'active-set');
resp_evok = resp(:,:) - spon_resp;
resp_90_evok = resp_90(:) - spon_resp;
resp_270_evok = resp_270(:) - spon_resp;

x_trans = repmat(resp_evok,3,1);

x_rot_90_temp = repmat(resp_R_90 - spon_resp,length(resp_evok),1);
x_rot_270_temp = repmat(resp_R_270 - spon_resp,length(resp_evok),1);
x_rot = [x_rot_90_temp;zeros(length(resp_evok),1);x_rot_270_temp];

y_data = [resp_90_evok;resp_evok;resp_270_evok];
%% Model 1  y = w_t*x_t +bias;
yy1 = @(x)sum( (x(1)*x_trans  + x(2) - y_data).^2 );
es1 = [0.1 0];
% LB1 = [0 0 -0.5];
% UB1 = [1 1 0.5];
LB1 = [-3 -100];
UB1 = [3 100];
v = fmincon(yy1,es1,A,B,Aeq,Beq,LB1,UB1, NONLCON, OPTIONS);
y_pred = v(1)*x_trans + v(2);% + v(3);
[r_cof,p_cof]=corrcoef(y_pred',y_data');
YSSE1 = sum( (y_pred - y_data).^2 );
YSST1 = sum( (y_data - mean(y_data)).^2 );
VAF1 = 1 - YSSE1/YSST1;
%% Model 2 : y = w_r*x_r +bias;
A=[]; B=[]; Aeq=[]; Beq=[]; NONLCON=[];
OPTIONS = optimset('fmincon');
OPTIONS = optimset('LargeScale', 'off', 'LevenbergMarquardt', 'on',... 
'MaxIter', 5000, 'Display', 'off', 'Algorithm', 'active-set');
yy2 = @(x)sum( (x(1)*x_rot + x(2) - y_data).^2 );
es2 = [0.1 0];
LB2 = [-3 -100];
UB2 = [3 100];
v2 = fmincon(yy2,es2,A,B,Aeq,Beq,LB2,UB2, NONLCON, OPTIONS);
y_pred2 = v2(1)*x_rot + v2(2);% + v(3);
[r_cof2,p_cof2]=corrcoef(y_pred2',y_data');
YSSE2 = sum( (y_pred2 - y_data).^2 );
YSST2 = sum( (y_data - mean(y_data)).^2 );
VAF2 = 1 - YSSE2/YSST2;
%% Model 3 :  y = w_t*x_t +w_r*x_r +bias;
A=[]; B=[]; Aeq=[]; Beq=[]; NONLCON=[];
OPTIONS = optimset('fmincon');
OPTIONS = optimset('LargeScale', 'off', 'LevenbergMarquardt', 'on',... 
'MaxIter', 5000, 'Display', 'off', 'Algorithm', 'active-set');
yy3 = @(x)sum( ( x(1)*x_trans  + x(2)*x_rot + x(3) - y_data).^2 );
es3 = [0.1 0.1 0 ];
LB3 = [-3 -3 -100];
UB3 = [3 3 100];
v3 = fmincon(yy3,es3,A,B,Aeq,Beq,LB3,UB3, NONLCON, OPTIONS);
y_pred = v3(1)*x_trans + v3(2)*x_rot + v3(3);% + v(3);
[r_cof3,p_cof3]=corrcoef(y_pred',y_data');
YSSE3 = sum( (y_pred - y_data).^2 );
YSST3 = sum( (y_data - mean(y_data)).^2 );
VAF3 = 1 - YSSE3/YSST3;
y_pred_save = y_pred;
y_data_save = y_data;
%% Model 4 :  y = w_t*x_t +w_r*x_r + w_inter*x_t*x_r + bias;
A=[]; B=[]; Aeq=[]; Beq=[]; NONLCON=[];
OPTIONS = optimset('fmincon');
OPTIONS = optimset('LargeScale', 'off', 'LevenbergMarquardt', 'on',... 
'MaxIter', 5000, 'Display', 'off', 'Algorithm', 'active-set');
yy4 = @(x)sum( ( x(1)*x_trans  + x(2)*x_rot + x(3)*x_trans.*x_rot + x(4) - y_data).^2 );
es4 = [0.1 0.1 0 0 ];
LB4 = [-3 -3 -3 -100];
UB4 = [3 3 3 100];
v4 = fmincon(yy4,es4,A,B,Aeq,Beq,LB4,UB4, NONLCON, OPTIONS);
y_pred = v4(1)*x_trans + v4(2)*x_rot + v4(3)*x_trans.*x_rot + v4(4) ;% + v(3);
[r_cof4,p_cof4]=corrcoef(y_pred',y_data');
YSSE4 = sum( (y_pred - y_data).^2 );
YSST4 = sum( (y_data - mean(y_data)).^2 );
VAF4 = 1 - YSSE4/YSST4;
%%
%%%% A sequential F test
%%%%if you don'r understand this part
%%%Please refer to the webpage http://en.wikipedia.org/wiki/F-test
%%%CZX 20140824
nfree1 = length(LB1);nfree3 = length(LB3);
F_value = ((YSSE1 - YSSE3)/(nfree3 - nfree1))/(YSSE3/length(y_data)- nfree3);
p_sequential = 1 - fcdf(F_value,nfree3 - nfree1,length(y_data)- nfree3 );

nfree2 = length(LB2);nfree3 = length(LB3);
F_value = ((YSSE2 - YSSE3)/(nfree3 - nfree2))/(YSSE3/length(y_data)- nfree3);
p_sequential2 = 1 - fcdf(F_value,nfree3 - nfree2,length(y_data)- nfree3 );

nfree3 = length(LB3);nfree4 = length(LB4);
F_value = ((YSSE3 - YSSE4)/(nfree4 - nfree3))/(YSSE4/length(y_data)- nfree4);
p_sequential3 = 1 - fcdf(F_value,nfree4 - nfree3,length(y_data)- nfree4 );

%% Bayesian information criteria (BIC). 
%https://www.ncbi.nlm.nih.gov/pubmed/12684484
% Angelaki, D. E. and J. D. Dickman (2003). 
% CZX 20151115 
BIC_T_log10 = log10(YSSE1/length(y_data)) + length(LB1)/2*log10(length(y_data))/length(y_data);
BIC_R_log10 = log10(YSSE2/length(y_data)) + length(LB2)/2*log10(length(y_data))/length(y_data);
BIC_TR_log10 = log10(YSSE3/length(y_data)) + length(LB3)/2*log10(length(y_data))/length(y_data);
BIC_TRnon_log10 = log10(YSSE4/length(y_data)) + length(LB4)/2*log10(length(y_data))/length(y_data);
BIC_T = log(YSSE1/length(y_data)) + length(LB1)/2*log(length(y_data))/length(y_data);
BIC_R = log(YSSE2/length(y_data)) + length(LB2)/2*log(length(y_data))/length(y_data);
BIC_TR = log(YSSE3/length(y_data)) + length(LB3)/2*log(length(y_data))/length(y_data);
BIC_TRnon = log(YSSE4/length(y_data)) + length(LB4)/2*log(length(y_data))/length(y_data);
% if (BIC_T < 0) | (BIC_R < 0)| (BIC_TR < 0)| (BIC_TRnon < 0)
%     keyboard
% end





