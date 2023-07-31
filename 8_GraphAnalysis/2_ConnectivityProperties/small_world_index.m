%Daniele Poli 
%02/01/2016
%Small-World Index Function

%input
%MatrixTH = THRESHOLDED BINARY CONNECTIVITY MATRIX
%N = NUMBER OF RANDOM NETWORKS

%output
%SW = SMALL-WORLD INDEX
%CC = CLUSTER COEFF.
%PL = CHARACTERISTIC PATH LENGTH

function [SW,PL,CC,PL_RND,CC_RND] = small_world_index(MatrixTH,N)

Nodes = length(MatrixTH); %NUMBER OF ENVOLVED NODES
m = sum(sum(MatrixTH)); %NUMBER OF CONNECTIONS OF THE BINARY CONNECTIVITY MATRIX

%Distance Matrix
D=distance_bin(MatrixTH);

%network characteristic path length
[lambda] = charpath(D);
PL = lambda;
clear lambda;
clear D;

%Clustering coefficient of binary directed connection matrix
C = clustering_coef_bd(MatrixTH);
CC = mean(C(find(C > 0)));
clear C;

%network characteristic path length of N Random Network
for current_random = 1:N
    Net_RND = RandomAlgoErdos(Nodes,m);
    %Distance Matrix
    D=distance_bin(Net_RND);
    %network characteristic path length
    [lambda] = charpath(D);
    PL_RND_vector(1,current_random) = lambda;
    clear lambda;
    %Clustering coefficient of binary directed connection matrix
    C = clustering_coef_bd(Net_RND);
    CC_RND_vector(1,current_random) = mean(C(find(C > 0)));
    clear C;
    clear Net_RND;
end
PL_RND = mean(PL_RND_vector);
CC_RND = mean(CC_RND_vector);
%E=efficiency_bin(MatrixTH);

SW = (CC/CC_RND)/(PL/PL_RND);
%SWE = (CC/CC_RND)/((1./E)/PL_RND);

PL = PL/PL_RND;
CC = CC/CC_RND;

end