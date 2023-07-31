%% Spatial filter to detect the fisiological connections
function FilteredConnectivityMatrix = SpatialFilter (nEl, ConnectivityMatrix, Delaymatrix_ms,type)
% I consider the mean leterature velocity of propagation 0.03-0.3 mm/ms 
    nelect = nEl;
    if nelect == 120
        l = sqrt(nelect);
        l = ceil(l)+1;
        col1 = ones(l,1);
        col2 = [1:l]';
        xy = [];
        for i = 1:l
            xy = [xy;col1*i,col2];
        end

        %layout multichannel
        xy(142:144,:) = [];
        xy(131:135,:) = [];
        xy(120:122,:) = [];
        xy(109,:) = [];
        xy(36,:) = [];
        xy(25,:) = [];
        xy(23:24,:) = [];
        xy(13:14,:) = [];
        xy(10:12,:) = [];
        xy(1:3,:) = [];

        index2 = [21;25;29;33;37;41;17;20;24;28;34;38;42;45;15;16;19;23;27;35;39;43;46;47;11;...
                12;13;14;22;26;36;40;44;49;50;51;7;8;9;10;18;30;32;48;52;53;54;55;3;4;5;6;2;1;31;...
                60;56;57;58;59;119;118;117;116;120;91;61;62;66;65;64;63;115;114;113;112;108;92;90;...
                78;70;69;68;67;111;110;109;104;100;96;86;82;74;73;72;71;107;106;103;99;95;87;83;79; ...
                76;75;105;102;98;94;88;84;80;77;101;97;93;89;85;81];
    elseif nelect == 60 & type==1
        l = sqrt(nelect);
        l = ceil(l);
        col1 = ones(l,1);
        col2 = [1:l]';
        xy = [];
        for i = 1:l
            xy = [xy;col1*i,col2];
        end


        %layout multichannel
        xy(1,:) = [];
        xy(l-1,:) = [];
        xy(((l*l)-9),:) = [];
        xy(((l*l)-3),:) = [];

        index2 = [[17:-1:12]';[28:-1:21]';[38:-1:31]';[48:-1:41]';[58:-1:51]';[68:-1:61]';[78:-1:71]';[87:-1:82]'];
    
    elseif nelect == 256
        l = sqrt(nelect);
        l = ceil(l);
        col1 = ones(l,1);
        col2 = [1:l]';
        xy = [];
        for i = 1:l
            xy = [xy; col1*i,col2];
        end
        
        xy(1,:) = [];
        xy(l-1,:) = [];
        xy(((l*l)-17),:) = [];
        xy(end,:) = [];
        
        index2 = [1:252]';
    else
        c = [1 3 5 10 15 17 19];
        r = [1:2:9 12:2:16 19:2:27];
        xy = [];
        for i = 1:length(c)
            for k = 1:length(r)
                xy = [xy; c(i) r(k)];
            end
        end

        count = 1;
        tmp = [];
        for i = 1:length(xy)
            if xy(i,1)~=10 & (xy(i,2)== 12 | xy(i,2)== 14 | xy(i,2)== 16) 
            elseif (xy(i,1)== 1  | xy(i,1) == c(end)) & (xy(i,2)==1 | xy(i,2)== r(end))
                elseif (xy(i,1)== 5  | xy(i,1) == 15) & (xy(i,2)==9 | xy(i,2)== 19)
            elseif xy(i,1)== 10  & (xy(i,2) == 1 | (xy(i,2)==3 | xy(i,2)== 9 | xy(i,2)== 19 | xy(i,2)== 25 | xy(i,2)== 27))
            else
                tmp(count,:) = xy(i,:);
                count = count+1;
            end
        end
        xy = tmp;
        index2 = [36 17 16 25 24 13 12 33 37 28 27 26 35 34 23 22 21 32 38 ...
            45 46 48 41 43 44 31 47 57 85 14 84 42 52 68 55 56 58 51 53 54 ...
            61 67 78 77 76 65 64 73 72 71 62 66 87 86 75 74 83 82 63]';
    end 



    xy = [xy,index2];

    % Definita la posizione degli elettrodi calcolo la matrice delle distanze
    for k = 1:length(xy)
        if type == 0
            for j = 1:length(xy)
                dist(xy(k,3),xy(j,3))= sqrt((100*xy(k,1)/1000-100*xy(j,1)/1000)^2+(100*xy(k,2)/1000-100*xy(j,2)/1000)^2);
            end
        else
            for j = 1:length(xy)
                dist(xy(k,3),xy(j,3))= sqrt((200*xy(k,1)/1000-200*xy(j,1)/1000)^2+(200*xy(k,2)/1000-200*xy(j,2)/1000)^2);
            end
        end
    end


    FilteredConnectivityMatrix = ConnectivityMatrix;

    vel_min = 0.03;
    vel_max = 0.3;
    
    delay_max = dist./vel_min;
    delay_min = dist./vel_max;
    
    
    
    %% Controlla 
    if nelect == 60
        index = [1:11,18:20,29:30,39:40,49:50,59:60,69:70,79:81]';
        delay_max(index,:) = [];
        delay_max (:,index')=[];
        delay_min(index,:) = [];
        delay_min(:,index') = [];
    end
    control_1 = logical(Delaymatrix_ms>= delay_min); 
    control_2 = logical(Delaymatrix_ms<= delay_max);
    index = control_1 & control_2;
    FilteredConnectivityMatrix(not(index)) = 0;

end

        
