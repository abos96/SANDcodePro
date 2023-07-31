function [Threshold_exc, Threshold_inh] = CST(S,CC,trials)
P=zeros(length(S));
N=zeros(length(S));
Th=linspace(0.05,0.5,trials);
C=zeros(trials);
P(S>0)=S(S>0);
N(S<0)=S(S<0);

for i=1:trials
    for j=1:trials
        
         Pth=threshold_proportional_AB(P,Th(i));
         Nth=threshold_proportional_AB(abs(N),Th(j));
         Pth(Pth~= 0)=1;
         Nth(Nth~= 0)=1;
         C(i,j) = transitivity_bu(Pth+Nth);
         
    end
end
c=abs(C-CC);
%c(c==0)=Inf;
X=c(:,:)==min(c(:));
[row,col,v] = find(X);
Threshold_exc=Th(row);
Threshold_inh=Th(col);

end