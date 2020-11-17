% Bayesian cases 4
% Based on Ma, Weiji, 2019 Bayesian decision models, a primer
% LBY 20200506

%% calculate posterior distribution

s = -10:0.1:10; % stimulus
sigma_s = 3.5; % sigma of stimulus
mu_s = 0;
a = 0.1;

sigma = 1; % sigma of likelihood

x = 5; % observation
prior = a*1/sqrt(2*pi*sigma_s^2)*exp(-(s-mu_s).^2/(2*sigma_s^2));
likelihood = 1/sqrt(2*pi*sigma^2)*exp(-(s-x).^2/(2*sigma^2));
% likelihood = likelihood/sum(likelihood); % normalization, thsi is not necessary to calculate posterior distribution

post = prior .* likelihood;
post = post/sum(post);% normalization, this is necessary!!!

%%%% plot figures
% figure(21);clc;
figure;
plot(s,prior,'r-','linewidth',3);hold on;
plot(s,likelihood,'b-','linewidth',3);hold on;
plot(s,post,'g-','linewidth',3);hold on;
% legend('prior','likelihood','posterior');
ylabel('Probability');xlabel('Stimulus');ylim([0 0.05]);
SetFigure(15);
%% aa
