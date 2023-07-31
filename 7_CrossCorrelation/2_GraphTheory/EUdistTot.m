function [d_exc, d_inh, d_tot]=EUdistTot(CC,coord)
 [I,J]=find(CC>0);
 d_exc=sqrt(((coord(I,1)-coord(J,1)).^2)+((coord(I,2)-coord(J,2)).^2));
 
 [I,J]=find(CC<0);
 d_inh=sqrt(((coord(I,1)-coord(J,1)).^2)+((coord(I,2)-coord(J,2)).^2));
 
 [I,J]=find(CC~=0);
 d_tot=sqrt(((coord(I,1)-coord(J,1)).^2)+((coord(I,2)-coord(J,2)).^2));
end