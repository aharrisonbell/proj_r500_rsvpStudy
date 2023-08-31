function [ROCarea,se,na,nb] = plx500_calcROC(A,B,style,label,adj)
% adapted from code courtesy of Brian Corneil
% Function spits out ROC area for distribution, stepping through 100 intermediate values between minimum and maximum
% values of A and B

if nargin==2,
    style='r-';
    label='';
    adj=0;
end
na = size(A,1);
nb = size(B,1);
ci = bootstrap_ci(A,B);
minint = floor(min(min(A),min(B))); maxint = ceil(max(max(A),max(B)));
stepsize = (maxint-minint)/250; % /1000
%data = [A,B];
ROCplot = [];
for t = minint:stepsize:maxint
    ROCplot = [ROCplot; sum(B>=t)/length(B) sum(A>=t)/length(A)];
end
A = unique(ROCplot,'rows');
ROCarea = 0;
for i = 2:size(A,1);
	deltax = A(i,1) - A(i-1,1);
	deltay = (A(i,2) - A(i-1,2))/2 + A(i-1,2);
	ROCarea  = ROCarea + (deltax * deltay);
end
%plot(ROCplot(:,1),ROCplot(:,2),char(style),'LineWidth',2);
%hold on
%plot(ROCplot(:,1),ROCplot(:,2),'k.','MarkerSize',14);
%text(0.2,adj,[char(label),'  ',num2str(ROCarea,'%1.2g'),' (',num2str(ci(end),'%1.2g'),')'])
%[h,p]=ttest2(data(:,1),data(:,2),0.05);
%text(.8,adj,['p=',num2str(p,'%1.1g')])
%%% new code added Dec18 to calculate standard error of curve
% formula based on Hanley and McNeil 1983
% se = sqrt((A(1-A)+(nA-1)(Q1-A2)+)nB-1)(Q2-A2))/nAnB)
q1 = ROCarea/(2-ROCarea);
q2 = (2*((ROCarea)^2))/(1+ROCarea);
se = sqrt(((ROCarea*(1-ROCarea)) + ((na-1)*(q1-ROCarea^2)) + ((nb-1)*(q2-ROCarea^2)))/(na*nb));
%text(.8,adj-0.05,['se=',num2str(se,'%1.1g')])
return

function ci = bootstrap_ci(data1,data2)
%% Bootstrapping Method of detecting confidence intervals and subsequent statistical significance
%% donated by Brian D. Corneil
iterations = 1000; % number of bootstrap attempts
data_ROC = zeros(1,iterations);
try 
    data_all = [data1;data2];
catch
    data_all = [data1,data2];
end    
for i = 1:iterations    % Now randomly assign values
    indices = randperm(length(data_all));    % Randomly reshuffles the indices
    data_shufA = data_all(indices(1:round(length(data_all)/2)));   % 
    data_shufB = data_all(indices(round(length(data_all)/2)+1:end));
    data_ROC(i) = calcROC(data_shufA',data_shufB',0);
end
ci(1) = mean(data_ROC) + std(data_ROC) * TINV(0.025,length(data_ROC)-1);   % Low 95% CI
ci(2) = mean(data_ROC) + std(data_ROC) * TINV(0.975,length(data_ROC)-1);   % High 95% CI
ci(3) = mean(data_ROC) + std(data_ROC) * TINV(0.005,length(data_ROC)-1);   % Low 99% CI
ci(4) = mean(data_ROC) + std(data_ROC) * TINV(0.995,length(data_ROC)-1);   % High 99% CI
return

function ROCarea = calcROC(A,B,halfpoints, plotflag)
% Function spits out ROC area for distribution, stepping through 1000 intermediate values between minimum and maximum
% values of A and B
minint = floor(min(min(A),min(B))); maxint = ceil(max(max(A),max(B)));
stepsize = (maxint-minint)/250; % /1000
if nargin <= 3; plotflag = 0; end
if halfpoints > 0; A = pointfilter(A',halfpoints); A = A'; B = pointfilter(B', halfpoints); B = B'; end
ROCplot = [];
for t = minint:stepsize:maxint
    ROCplot = [ROCplot; sum(B>=t)/length(B) sum(A>=t)/length(A)];
end
% New code to fix bug
A = unique(ROCplot,'rows');
ROCarea = 0;
for i = 2:size(A,1);
	deltax = A(i,1) - A(i-1,1);
	deltay = (A(i,2) - A(i-1,2))/2 + A(i-1,2);
	ROCarea  = ROCarea + (deltax * deltay);
end
%if plotflag == 1
%    plot(ROCplot(:,1),ROCplot(:,2));
%    text(0.6, 0.2,num2str(ROCarea))
%end
return