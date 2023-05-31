clear
close all
clc

%% Import data

A = importdata('metrics.csv');
A = A.data;

B = importdata('behaviour.csv');
B = B.data;

dyad = A(:,1);

F0_mean_sync = A(:,8);
F0_mean_conv = A(:,9);
F0_mean_prox = A(:,10);

ENG_mean_sync = A(:,26);
ENG_mean_conv = A(:,27); 
ENG_mean_prox = A(:,28);

SEC_sync = A(:,35);
SEC_conv = A(:,36);
SEC_prox = A(:,37);

%% Examine correlation between different metrics

% X = [F0_mean_sync,F0_mean_conv,F0_mean_prox,...
% ENG_mean_sync,ENG_mean_conv,ENG_mean_prox,...
% SEC_sync,SEC_conv,SEC_prox];

% corrplot(X)

%% Obtain mean behavioral data for each dyad

% Re-code missing data as NaN values
B(B<-900)=NaN;
% Reverse coding items in both scales
B(:,11+4)=8-B(:,11+4);
B(:,2+2)=8-B(:,2+2);
B(:,2+3)=8-B(:,2+3);
B(:,2+5)=8-B(:,2+5);
B(:,2+8)=8-B(:,2+8);


bdyad = B(:,1); % dyad id 
bme = nanmean(B(:,3:11),2); % mean value of the conversation assesment subscale
bot = nanmean(B(:,12:19),2); % mean value of the partner assesment scale
cons = B(:,2); % dummy indicating whether the participant was in a dyad reached consensus or not

% predefine mean variables for each dyad
bme2=nan(size(dyad));
bot2=nan(size(dyad));
con2=nan(size(dyad));

for d=1:length(dyad)
    this_dyad = dyad(d);
    bme2(d)=mean(bme(bdyad==this_dyad));
    bot2(d)=mean(bot(bdyad==this_dyad));
    con2(d)=mean(cons(bdyad==this_dyad));
end

% the only significant correlation between variables is between
% convergence score of mean pitch vs. partner assesment subscale

[r,p]=nancorr(F0_mean_conv,bot2);
mdl = fitlm(nanzscore(F0_mean_conv),bot2);

%% Figure displaying correlation between these variables

figure('color','w','paperunits','centimeters','paperposition',[1 1 6 5]);
plot(F0_mean_conv,bot2,'ko','markerfacecolor','k','markersize',5);hold on;
xi = [-1:.1:1];
[yi,yci]=predict(mdl,xi');
plot(xi,yi,'r-','linewidth',2);
plot(xi,yci(:,1),'r-');
plot(xi,yci(:,2),'r-');
xlim([-1 1])
ylim([3.7 7.3])
xlabel 'Pitch Convergence Score'
ylabel 'Partner Assesment Subscale'
set(gca,'xtick',[-.8:.4:.8],'ytick',[4:7])
box off

print -dpdf prosody.pdf









