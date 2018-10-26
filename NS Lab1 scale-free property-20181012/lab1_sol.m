
close all
clear all
clc

% https://snap.stanford.edu/data/wiki-Vote.html
G = importdata('wiki-Vote.txt', '\t', 4);
% The network contains all the Wikipedia voting data 
% from the inception of Wikipedia till January 2008. 
% Nodes in the network represent wikipedia users and 
% a directed edge from node i to node j represents that 
% user i voted on user j.

% adjacency matrix
N = max(max(G.data));
A = sparse(G.data(:,2),G.data(:,1),ones(size(G.data,1),1),N,N);
clear G;


%% %%%%%%%%%%%%%%%%% EXTRACT THE DISTRIBUTION %%%%%%%%%%%%%%%%%%%%%%%%%

% distribution
d = full(sum(A,2)); % in degree, for out degree 2->1
d = d(d>0); % avoid zero degrees
k = unique(d); % degree samples
pk = histc(d,k)'; % counts occurrences
pk = pk/sum(pk); % normalize to 1

% cumulative distribution
Pk = cumsum(pk,'reverse');

% log binning
klog = 10.^(0:0.1:ceil(log10(max(k))));
pklog = histc(d,klog)'; % counts occurrences
pklog = pklog/sum(pklog); % normalize to 1


%% %%%%%%%%%%%%%%%%% SHOW THE RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
subplot(2,2,1)
plot(k,pk,'.')
grid
xlabel('k')
ylabel('PDF')
title('linear PDF plot')
subplot(2,2,2)
loglog(k,pk,'.')
grid
xlabel('k')
ylabel('PDF')
title('logarithmic PDF plot')
subplot(2,2,3)
loglog(klog,pklog,'.')
grid
xlabel('k')
ylabel('PDF')
title('logarithmic PDF plot (log bins)')
subplot(2,2,4)
loglog(k,Pk,'.')
grid
xlabel('k')
ylabel('CCDF')
title('logarithmic CCDF plot')


%% %%%%%%%%%%%%%%%%% PURE ML FITTING %%%%%%%%%%%%%%%%%%%%%%%%%

kmin = 60;
d2 = d(d>=kmin); % restrict range
ga = 1+1/mean(log(d2/kmin)); % estimate the exponent
disp(['gamma ML = ' num2str(ga)])


%% %%%%%%%%%%%%%%%%% SHOW THE RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
subplot(2,2,2)
hold on
s1 = k.^(-ga); % build the PDF signal
loglog(k,s1/s1(103)*pk(103));
hold off
axis([xlim min(pk/2) 2*max(pk)])
subplot(2,2,3)
hold on
s1 = klog.^(-ga); % build the PDF signal
loglog(klog,s1/s1(21)*pklog(21));
hold off
axis([xlim min(pklog/2) 2*max(pklog)])
subplot(2,2,4)
hold on
s1 = k.^(1-ga); % build the CCDF signal
loglog(k,s1/s1(150)*Pk(150));
hold off
axis([xlim min(Pk/2) 2])


%% %%%%%%%%%%%%%%%%% ML FITTING WITH SATURATION %%%%%%%%%%%%%%%%%%

for ks = 1:max(k)
    kmin = min(d);
    tmp = mean(log((d+ks)/(kmin+ks)));
    ga2(ks) = 1+1/tmp;
    de(ks) = log(ga2(ks)-1)-log(kmin+ks)-ga2(ks)*tmp;
end
[~,ks] = max(de);
disp(['k_sat ML sat = ' num2str(ks)])
disp(['gamma ML sat = ' num2str(ga2(ks))])


%% %%%%%%%%%%%%%%%%% SHOW THE RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
semilogy(de)
grid
xlabel('k_{sat}')
ylabel('ML target function')
title('best k_{sat} value')

figure(3)
% data
loglog(k,Pk,'.')
hold on
% ML fitting (we make sure that the plot follows the data)
s1 = k.^(1-ga); % build the CCDF signal
loglog(k,s1/s1(150)*Pk(150));
% ML fitting with saturation
s1 = ((k+ks)/(kmin+ks)).^(1-ga2(ks));
loglog(k,s1)
hold off
axis([xlim min(Pk/2) 2])
grid
xlabel('k')
ylabel('CCDF')
title('ML fittings')
legend('data','ML','ML with sat.')




