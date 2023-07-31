function Path = Findpath(D,steps)
Path=zeros(size(D));
for ii=1:120
    for jj=1:120
        if(D(ii,jj)>1)
                pp0 = find( D(ii,:) < steps & D(ii,:) > 0 );
                path=zeros(length(pp0),1);
                idx=0;
                for x=pp0
                    idx=idx+1;
                    steps_to_do = steps - D(ii,x);
                    if (steps_to_do == 1)
                        pp1 = find(D(:,x) == 1);
                        if find( pp1 == jj )

                            path(idx) = x;

                        end
                    end
                    
                    
                  Path(ii,path(path~=0))=Path(ii,path(path~=0))+1;
                  Path(jj,path(path~=0))=Path(jj,path(path~=0))+1;
                  Path(path(path~=0),ii)=Path(path(path~=0),ii)+1;
                  Path(path(path~=0),jj)=Path(path(path~=0),jj)+1;
                end
        end
    end
    
end

    
 
    
    