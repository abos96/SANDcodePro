function [R]=risk(W)

R=zeros(length(W));
Pos=zeros(length(W));
Neg=zeros(length(W));
Pos(W>0)=W(W>0);
Neg(W<0)=W(W<0);
Pos = weight_conversion(Pos, 'normalize');
Neg = weight_conversion(abs(Neg), 'normalize');
W=Pos-Neg;        
for i=1:length(W)
    for j=1:length(W)
        weight=W(i,j);
        if weight~=0
            norm = sum(abs(W(i,:))) + sum(abs(W(:,j)));
            risk = sum(abs(W(:,i))) + sum(abs(W(j,:)));
            R(i,j)=weight./norm.*risk;  
        end
    end
end



        