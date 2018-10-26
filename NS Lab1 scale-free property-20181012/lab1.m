
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

figure(1)
spy(A,'red',4)

% .. continue






