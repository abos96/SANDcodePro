function [ReachabilityMatrix,DistanceMatrix] = ShortestPath(ConnMatrixTH)

% Returns a "ReachabilityMatrix" (Nodes x Nodes)which presents a 1 if from 
% the node "i" is possible to arrive to the node "j" and a "DistanceMatrix" 
% which present the number.

numLinks = length(find(ConnMatrixTH));

% Set zero on the diagonal
%ConnMatrixTH.*~(eye(size(ConnMatrixTH)) & ConnMatrixTH==1);
%[ConnMatrixTH_zeroOnDiagonal] = setZeroOnTheDiagonal(ConnMatrixTH);
ConnMatrixTH = ConnMatrixTH - diag(diag(ConnMatrixTH));
% If there is a connection value => set 1 (instead of the CC peak value)
ConnMatrixTH_binaryzeroOnDiagonal = double(ConnMatrixTH~=0);

clear ConnMatrixTH_zeroOnDiagonal 
clear ConnMatrixTH_zeroOnDiagonal_binary

[ReachabilityMatrix,DistanceMatrix] = breadthdist(ConnMatrixTH_binaryzeroOnDiagonal);

% eval(['ReachabilityMatrix',num2str(numLinks),' = ReachabilityMatrix;']); 
% eval(['save ReachabilityMatrix',num2str(numLinks),'  ReachabilityMatrix',num2str(numLinks),';']);
% eval(['DistanceMatrix',num2str(numLinks),' = DistanceMatrix;']); 
% eval(['save DistanceMatrix',num2str(numLinks),'  DistanceMatrix',num2str(numLinks),';']);
