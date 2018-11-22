% https://aminer.org/citation
fileID = fopen('citation-network2.txt','r');
% The citation data is extracted from DBLP, ACM, MAG (Microsoft 
% Academic Graph), and other sources. The first version contains 
% 629,814 papers and 632,752 citations. Each paper is associated 
% with abstract, authors, year, venue, and title.
% The data set can be used for clustering with network and side 
% information, studying influence in the citation network, 
% finding the most influential papers, topic modeling analysis, etc.

N = fscanf(fileID,'%f');
A = sparse(N,N);
while ~feof(fileID)
    line = fgets(fileID);
    if strcmp('#index',line(1:min(6,end)))
        i = str2num(line(7:end));
        disp(i)
    end
    if strcmp('#%',line(1:min(2,end)))
        j = str2num(line(3:end));
        A(j+1,i+1) = 1;
    end
%     keyboard
end
save('adjacency_matrix','A');

% remove nodes which are NOT connected
load('adjacency_matrix.mat')
N = size(A,1);
Au = ((A+A')>0);
pos = find(sum(Au)~=0);
A = A(pos,pos);
save('adjacency_matrix','A');

% find the largest connected component
load('adjacency_matrix.mat')
N = size(A,1);
Au = ((A+A')>0);

e1 = [1;zeros(N-1,1)];
exit = false;
while(~exit)
    e1_old = e1;
    e1 = 1*(Au*e1>0);
    exit = (sum(e1-e1_old)==0);
end
pos = find(e1);
A = A(pos,pos);
save('adjacency_matrix','A');
