function [MEA256] = MEA256_lookuptable()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

 clear all
    clc
    MEA256 = string(ones(252,2));
    letter = 'A':'R';
    letter(letter=='I' | letter == 'Q') = [];
    count = 1;
    for i = 1:length(letter)
        if letter(i) == 'A' | letter(i) == 'R'
            for k = 2:15
                if k <10
                    MEA256(count,1) = strcat(letter(i),'0',char(string(k)));
                else
                    MEA256(count,1) = strcat(letter(i),char(string(k)));
                end
                    MEA256(count,2)= count;
                    count = count+1;
            end
        else
            for k = 1:16
                 if k <10
                    MEA256(count,1) = strcat(letter(i),'0',char(string(k)));
                else
                    MEA256(count,1) = strcat(letter(i),char(string(k)));
                 end
                MEA256(count,2)= count;
                count = count+1;
            end
        end
    end
end

