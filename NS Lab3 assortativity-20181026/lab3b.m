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
Au = 1*(A+A'>0); % undirected network
clear G;

% remove nodes which are NOT connected
pos = find(sum(Au)~=0);
A = A(pos,pos);
Au = Au(pos,pos);% remove nodes which are not connected 
N = size(A,1);

% find the largest connected component
e1 = [1;zeros(N-1,1)];
exit = false;
while(~exit)
    e1_old = e1;
    e1 = 1*(Au*e1+e1>0);
    exit = (sum(e1-e1_old)==0);
end
pos = find(e1);
A = A(pos,pos);
N = size(A,1);

d = full(sum(A,2);
k = unique(d);
% ... continue

