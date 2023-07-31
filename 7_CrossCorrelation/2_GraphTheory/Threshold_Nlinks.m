function S=Threshold_Nlinks(CC,Nlinks)
   link=zeros(100,1);
   threshold=linspace(0.01,0.4,100);
   for ii=1:100
         P=zeros(length(CC));
         N=zeros(length(CC));
         P(CC>0)=CC(CC>0);
         N(CC<0)=CC(CC<0);
         CC_Th = threshold_proportional_AB(P ,threshold(ii) )- threshold_proportional_AB(abs(N) ,threshold(ii));
        in=length(find(CC_Th<0));
        ecc=length(find(CC_Th>0));
        link(ii)=in+ecc;
   end
   
   final_threshold=threshold(find((min(abs(link-Nlinks))==abs(link-Nlinks))));
   S= threshold_proportional_AB(P ,final_threshold)- threshold_proportional_AB(abs(N) ,final_threshold); 
   
end