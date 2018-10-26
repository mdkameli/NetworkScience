close all
clear all
clc

% parameters
m = 3;
A = 3;
N = 1e2;

% starting point
Adj = sparse([m]); % Adjacency matrix
G = sparse(N,N);

m0 = m+1;
for i = 2 : m0+1
	G(i, i - 1) = 1;
end
G = G | G';
t = full(G);

ki = sum(G(1:N - 1,1:N-1));
	sumkj = sum(ki);
	pi = (3 + ki)/sumkj;
connect = zeros (1, N - 1);

while (sum(connect) < m)
	connect = (pi >= rand (1,N - 1));
end
ex = 0;
if (sum(connect) > m)
	perm = randperm (N - 1);
	c = connect(perm);
%     ee = [];
%     for i = 1:columns(c)
%         if (ee < m)
%             ee += c(i);
%         else
%             connect(perm(i)) = 0;
%         end
%     end
end 
    