load('adjacency_matrix.mat')

N = size(A,1);
Au = 1*((A+A')>0); % connected graph

% activate for smaller networks
e1 = zeros(N,1);
e1(11880) = 1;
for k = 1:17
    e1 = 1*((Au*e1+e1)>0);
    disp([N, sum(e1)])
end
pos = find(e1);
A = A(pos,pos);

save('adjacency_matrix2','A');