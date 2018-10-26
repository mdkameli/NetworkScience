close all
clear all
clc

% http://networksciencebook.com/translations/en/resources/data.html
G = importdata('collaboration.edgelist.txt', '\t', 4);
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
Au = A(pos,pos);
Nu = size(Au,1);

% degree
d = full(sum(A,2)); % degree
k = unique(d); % degree samples
%Mdl = fitcknn(A,d');
%Idx = knnsearch(A,d');

Knn = (A*d)./d;               %it is sum of neighbouring degree

% for i = 1:max(k)
%     idx = find(k==i);
%     x = Knn(idx);
%     Knn_Ave(i) = mean(x);
% end
% Knn_Ave = Knn_Ave(Knn_Ave >0);

p = polyfit(log(Knn),log(d),1);

y = p(2)*log(k) + p(1);
loglog(d,Knn,'.',k,exp(y))
grid
xlabel('k')
ylabel('Knn')
title('Assortivity of the collaboration Network')


