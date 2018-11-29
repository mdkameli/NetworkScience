close all
clear all
clc

% http://networksciencebook.com/translations/en/resources/data.html
G = importdata('collaboration.edgelist.txt', '\t', 1);
% Scientific collaboration network based on the arXiv preprint 
% archive's Condense Matter Physics category covering the period 
% from January 1993 to April 2003. Each node represents an author, 
% and two nodes are connected if they co-authored at least one 
% paper in the dataset. Ref: Leskovec, J., Kleinberg, J., & 
% Faloutsos, C. (2007). Graph evolution: Densification and shrinking 
% diameters. ACM Transactions on Knowledge Discovery from Data (TKDD), 
% 1(1), 2.

% adjacency matrix
G.data = G.data + 1;
N = max(max(G.data));
A = sparse(G.data(:,2),G.data(:,1),ones(size(G.data,1),1),N,N);
A = 1*(A+A'>0); % build undirected network
clear G;

% remove nodes which are NOT connected
pos = find(sum(A)~=0);
A = A(pos,pos);% remove nodes which are not connected 
N = size(A,1);

% find the largest connected component
e1 = [1;zeros(N-1,1)];
exit = false;
while(~exit)
    e1_old = e1;
    e1 = 1*(A*e1+e1>0);
    exit = (sum(e1-e1_old)==0);
end
pos = find(e1);
A = A(pos,pos);
N = size(A,1);


%% %%%%%%%%%%%%%%%%% EVALUATE ASSORTATIVITY %%%%%%%%%%%%%%%%%%%%%%%%%

% degrees
d = sum(A,2); % make it a column vector

% averages of neighbours
k_tmp = (A*d)./d;

% extract averages for each value of k
u = unique(d);
for k = 1:length(u)
    k_nn(k) = mean(k_tmp(d==u(k))); 
end

% do the linear fitting
p = polyfit(log(u'),log(k_nn),1);
disp(['Assortativity factor ' num2str(p(1))])


%% %%%%%%%%%%%%%%%%% SHOW RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
loglog(d,k_tmp,'g.');
hold on
loglog(u,exp(p(2)+log(u)*p(1)),'r-');
loglog(u,k_nn,'k.');
hold off
grid
xlabel('k')
ylabel('k_{nn}')
title('Assortativity of the Collaboration Network')


