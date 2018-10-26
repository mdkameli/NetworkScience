close all
clear all
clc

% parameters
m = 3;
A = 3;
N = 1e4;
fit = ones(1,N);  % no fitness
% fit = rand(1,N); % activate for uniform fitness
% fit = -log(rand(1,N)); % activate for exponential fitness

% starting point
Adj = sparse([m]); % Adjacency matrix


%% %%%%%%%%%%%%%%%%% BUILD THE NETWORK %%%%%%%%%%%%%%%%%%%%%%%%%

% loop
tic
for k = 1:N-1
    % preferential attachment 
    pa = [A + sum(Adj)]; % unscaled 
    pa = fit(1:length(pa)).*pa; % add fitness
    pa = pa/sum(pa); % normalize (turn into probability)
    
    % identify the new links by inverse CDF method
    x = rand(1,m);
    links = histc(x,cumsum([0, pa])); 
    
    % update the matrix
    a = sparse(links(1:end-1));
    b = sparse(links(end));
    Adj = [Adj, a'; a, b];
end
toc

% resulting adjacency matrix
% Adj = sparse(Adj>0); % activate to remove multi-edges
% figure(1)
% spy(Adj)


%% %%%%%%%%%%%%%%%%% EXTRACT THE DISTRIBUTIONS %%%%%%%%%%%%%%%%%%%%%%%%%

% distribution
d = full(sum(Adj,2)); % in degree
d = d(d>0); % avoid zero degrees
k = unique(d);
pk = histc(d,k)/length(d); % pdf

% cumulative distribution
Pk = cumsum(pk,'reverse');

% ML estimate
kmin = 10; 
d2 = d(d>=kmin);
ga = 1+1/mean(log(d2/kmin));
disp(['gamma ML = ' num2str(ga)])
ga2 = 3+A/m;
disp(['gamma expected = ' num2str(ga2)])


%% %%%%%%%%%%%%%%%%% SHOW THE RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%

% CDF plot 
figure(2)
loglog(k,Pk,'.')
hold on
s2 = exp(-(ga-1)*log(k));
loglog(k,s2/s2(end-4)*Pk(end-4));
hold off
axis([xlim min(Pk/2) 2])
grid
xlabel('k')
ylabel('CCDF')
title('Albert-Barabasi model')
legend('data','ML estimate')

% PDF plot
figure(3)
loglog(k,pk,'.')
hold on
s2 = exp(-(ga)*log(k));
loglog(k,s2/s2(40)*pk(40));
hold off
axis([xlim min(pk/2) 2])
grid
xlabel('k')
ylabel('PDF')
title('Albert-Barabasi model')
legend('data','ML estimate')