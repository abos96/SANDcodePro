function [R]=cost(W,Filter)

R=zeros(length(W));
norm=ones(length(W));


%----------------------------------------------------------------
for i=1:length(W)
    for j=1:length(W)
        weight=W(i,j);
        if weight~=0
            
            norm(i,j) = sum(abs(W(i,:))) + sum(abs(W(:,j)))-2*weight;      % compute normalization term
%             idx_i=(W(i,:)>0);
%             idx_j=(W(:,j)>0);
%             tempWeightsPos=[abs(W(i,idx_i)) abs(W(idx_j,j))'];
%             Npos =sum(isoutlier(tempWeightsPos,'percentiles', [0 99]));
%             idx_i=(W(i,:)<0);
%             idx_j=(W(:,j)<0);
%             tempWeightsNeg=[abs(W(i,idx_i)) abs(W(idx_j,j))'];
%             Nneg =sum(isoutlier(tempWeightsNeg,'percentiles', [0 99]));
%             N(i,j)=Npos+Nneg*4;                                            % comput compensation term
           
        end
    end
    fprintf("i=%f \n",i);
end
if Filter
    minNorm =min(norm(norm~=1));
    maxNorm =max(norm(:));
    NormSF=tanh(rescale(norm,0,(maxNorm-minNorm)/minNorm));
    R=W./norm.*N;
else 
    R=W./norm;   
end




