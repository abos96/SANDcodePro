function [Mean Std Median StdError] = compMSMS(parameter)

     
       Mean=mean(parameter);
       Std=std(parameter);
       Median=median(parameter);
       StdError=std(parameter)/sqrt(length(parameter));

end  
       