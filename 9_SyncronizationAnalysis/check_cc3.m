% check cc3


fs = 10000;
len = 1*fs;                %[s]
win = 10;                 %[ms]
bin = 1;                 %[ms]

window  = win*fs/1000;    % [number of samples]
binsize = bin*fs/1000;    % [number of samples]
 
st_a = zeros(len,1);
st_b = zeros(len,1);

% %  %st_a(4700)=1;
% for i=1:3
% st_a(5000+i)=1;
% st_b(5005+i)=1;
% 
% end
% a=load('ptrain_20200120_01_01_NBasal_0001_H08.mat');
% b=load('ptrain_20200120_01_01_NBasal_0001_F03.mat');
% st_a(5000)=1;
% st_b(5010)=1;

 st_a([5050 5070 5071 5072])=1;
 st_b([5050 5070 5071 5072])=1;

% a.peak_train(find(a.peak_train>0))=1;
% b.peak_train(find(b.peak_train>0))=1;
% Anorm=double(a.peak_train);
% Bnorm=double(b.peak_train);

[rnorm]= cc3 (st_a,st_b, window, binsize, fs, 1);
figure
plot(rnorm)
find(rnorm==max(rnorm))


