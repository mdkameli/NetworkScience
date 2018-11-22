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
% A = A'; % activate if looking for hubs instead !!!!!!!!!
Au = 1*(A+A'>0); % undirected network
clear G;

% remove nodes which are NOT connected
pos = find(sum(Au)~=0);
A = A(pos,pos);
Au = Au(pos,pos);
% remove dead ends (until none avalable)
exit = false;
while (~exit)
    pos = find(sum(A)~=0);
    A = A(pos,pos);
    Au = Au(pos,pos);
    N = size(A,1);
    exit = isempty(find(sum(A)==0, 1));
end

% find the largest connected component
e1 = [1;zeros(N-1,1)];
exit = false;
while(~exit)
    e1_old = e1;
    e1 = 1*(Au*e1>0);
    exit = (sum(e1-e1_old)==0);
end
pos = find(e1);
A = A(pos,pos);

%% PAGERANK
%spy(A)

% Linear System Solution for PageRank
tic;
d = A'*ones(N,1);
M = A*sparse(diag(1./d));
c = 0.85;
q = ones(N,1)*(1/N);
p = (sparse(eye(N)) - c*M)\((1-c)*(q));
toc;

% Power Iteration Solution for PageRank
tic;
pt = q;
rp = [];
for i = 1:40;
    pt = c*M*pt + (1-c)*q;
    rp = [rp norm(pt - p)];
    i = i+1;
end
toc;
Dl = eigs(M,2);
rl = [];
for i = 1:40
    rl = [rl (c*Dl(2,1))^i];
end 

x = [1:40];
semilogy(x,rp,'r',x,rl,'b')
grid
xlabel('k Iteration')
ylabel('||pt - p||')
title('Page Rank Convergence')
legend('Power Iteration','Linear')
% Linear Solution for HITS Authorities
tic;
MH = A*A';
[pH,D] = eigs(MH,2);
toc;

% Power Iteration for HITS Authorities
tic;
ptH = q;
for i = 1:40;
    ptH = c*MH*ptH;
    ptH = pt./norm(ptH);
    i = i+1;
end
toc;
         


