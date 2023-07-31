
%INPUT DATA 
%partial_TCM_n_1:               binary connectivity matrix (60el x 60el) (TH: mean+std)
%color_funct_links:             color of the functional links  
%size_arrow:                    size of the arrows for directionality
%degree_nodes:                  connectivity degree (IN+OUT) of each node.
%common_nodes_PRE_commonPOST01: nodes maintaining links after HF stimulation (common nodes) 


function [Graph HPGABA CHANNELGABA CXGABA ...
            HPGLUT CHANNELGLUT CXGLUT ]= Graph_EXC_INH(TCM_bin, TCM,color_funct_links,size_link,size_arrow,degree_nodes,type_hub,color)


Cyan = find(ismember(color(:,:), [0 1 1],'rows'));
Gray = find(ismember(color(:,:), [0.8 0.8 0.8],'rows'));
Red = find(ismember(color(:,:), [1 0 0],'rows'));
Green = find(ismember(color(:,:), [0 1 0],'rows'));
Yellow = find(ismember(color(:,:), [1 1 0],'rows'));
Blue = find(ismember(color(:,:), [0 0 1],'rows'));
Violet = find(ismember(color(:,:), [1 0 1],'rows'));

HP1GABA = length(find(ismember(color((type_hub<0),:), [0 1 1],'rows')));
CHANNELGABA = length(find(ismember(color((type_hub<0),:), [0.8 0.8 0.8],'rows')))./length(Gray);
CXGABA = length(find(ismember(color((type_hub<0),:), [1 0 0],'rows')))./length(Red);
HP2GABA = length(find(ismember(color((type_hub<0),:), [0 1 0],'rows')));

HP1GLUT = length(find(ismember(color((type_hub>0),:), [0 1 1],'rows')));
CHANNELGLUT = length(find(ismember(color((type_hub>0),:), [0.8 0.8 0.8],'rows')))./length(Gray);
CXGLUT = length(find(ismember(color((type_hub>0),:), [1 0 0],'rows')))./length(Red);
HP2GLUT = length(find(ismember(color((type_hub>0),:), [0 1 0],'rows')));

HPGLUT=(HP1GLUT+HP2GLUT)./(length(Green)+length(Cyan));
HPGABA=(HP1GABA+HP2GABA)./(length(Green)+length(Cyan));


Net = TCM_bin;
Con = TCM;
format compact
format long e


%building the coordinate matrix
if length(Net) == 120
    
    l = sqrt(length(Net));
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

elseif length(Net)== 252
        l = sqrt(length(Net));
        l = ceil(l);
        col1 = ones(l,1);
        col2 = [1:2:l*2]';
        xy = [];
        for i = 1:2:l*2
            xy = [xy; col1*i,col2];
        end
        
        xy(1,:) = [];
        xy(l-1,:) = [];
        xy(((l*l)-17),:) = [];
        xy(end,:) = [];
        
        index2 = [14:-1:1, 30:-1:15 46:-1:31 62:-1:47 78:-1:63 94:-1:79 110:-1:95 126:-1:111 142:-1:127 158:-1:143 174:-1:159 190:-1:175 206:-1:191 222:-1:207 238:-1:223 252:-1:239]';
end


xy = [xy,index2];


 
%building graph (other choice: gplot function)
[cell1,cell2] = find(Net~=0);
n_connections = length(cell1);
x1x2 = zeros(n_connections,2);
y1y2 = zeros(n_connections,2);

for k = 1:n_connections
    val(k) = Con(cell1(k),cell2(k));
end


for count_conn = 1:n_connections
    r1 = find(xy(:,3)==cell1(count_conn));
    r2 = find(xy(:,3)==cell2(count_conn));
   x1x2(count_conn,1) = xy(r1,1);
   x1x2(count_conn,2) = xy(r2,1);
   y1y2(count_conn,1) = xy(r1,2);
   y1y2(count_conn,2) = xy(r2,2); 
end


Graph = figure();
%% Controlla il grafico con link colorati
%gplot(Net,xy,'.-'); 
% for j = 1: length(x1x2)
%     if sum(ismember(Red,xy(find(xy(:,1)==x1x2(j,1) & xy(:,2)==y1y2(j,1)),3)))==1
%         plot(x1x2(j,:)',y1y2(j,:)','Color',[1 0 0],'LineWidth',size_link);
%     elseif sum(ismember(Cyan,xy(find(xy(:,1)==x1x2(j,1) & xy(:,2)==y1y2(j,1)),3)))==1
%         plot(x1x2(j,:)',y1y2(j,:)','Color', [0 1 1],'LineWidth',size_link);
%     elseif sum(ismember(Green,xy(find(xy(:,1)==x1x2(j,1) & xy(:,2)==y1y2(j,1)),3)))==1
%         plot(x1x2(j,:)',y1y2(j,:)','Color', [0 1 0],'LineWidth',size_link);
%     elseif sum(ismember(Gray,xy(find(xy(:,1)==x1x2(j,1) & xy(:,2)==y1y2(j,1)),3)))==1
%         plot(x1x2(j,:)',y1y2(j,:)','Color', [0 0 0],'LineWidth',size_link);
%     elseif sum(ismember(Yellow,xy(find(xy(:,1)==x1x2(j,1) & xy(:,2)==y1y2(j,1)),3)))==1
%         plot(x1x2(j,:)',y1y2(j,:)','Color', [1 0 0],'LineWidth',size_link);
%     elseif sum(ismember(Violet,xy(find(xy(:,1)==x1x2(j,1) & xy(:,2)==y1y2(j,1)),3)))==1
%         plot(x1x2(j,:)',y1y2(j,:)','Color', [1 0 1],'LineWidth',size_link);
%     elseif sum(ismember(Blue,xy(find(xy(:,1)==x1x2(j,1) & xy(:,2)==y1y2(j,1)),3)))==1
%         plot(x1x2(j,:)',y1y2(j,:)','Color', [0 0 1],'LineWidth',size_link);
%     end
%     hold on
% end

% for n_plot = 1:n_connections
%     arrowh(x1x2(n_plot,:),y1y2(n_plot,:),color_funct_links,100,size_arrow);
%     hold on
% end    
for j = 1: length(x1x2)
    if val(j) > 0
        plot(x1x2(j,:)',y1y2(j,:)','Color',[1, 0, 0],'LineWidth',size_link); %1-abs(val(j))/max(abs(val))
    else
        plot(x1x2(j,:)',y1y2(j,:)','Color', [0,0, 1],'LineWidth',size_link);
    end
    hold on
end


tmp = degree_nodes;
tmp_type = type_hub;
for i = 1:length(index2)
     degree_nodes(i) = tmp(index2(i));
     type(i) = tmp_type(index2(i));
end

if length(Net)==120
    plus = 15;
elseif length(Net)==252
    plus = 2;
end


for count = 1:length(Net)
    if type(count) == 0
        plot( xy(count,1), xy(count,2),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 0 0],'MarkerSize',5);
    else
         plot( xy(count,1), xy(count,2),'o','MarkerEdgeColor','k','MarkerFaceColor',[0.9, 0.9, 0.9],'MarkerSize',degree_nodes(1,count)+plus);
    end
end

clear count;
clear count02;
xlabel('Electrodes','FontSize',12,'FontName','arial');
ylabel('Electrodes','FontSize',12,'FontName','arial');
set(gcf, 'Color', [1 1 1]);
axis('equal');
axis off; 

% Definisci matrix per i 120 con le lettere. Definisci matrix 256

% matrix = [             
%                              51, 55, 59, 63, 67, 71, ...
%                          47, 50, 54, 58, 64, 68, 72, 75, ...
%                      45, 46, 49, 53 , 57, 65, 69, 73, 76, 77, ...
%                  41, 42, 43, 44, 52, 56, 66, 70, 74, 79, 80, 81, ...
%                  37, 38, 39, 40, 48, 60, 62, 78, 82, 83, 84, 85, ...
%                  33, 34, 35, 36, 32, 31, 61, 90, 86, 87, 88, 89, ...
%                  29, 28, 27, 26, 30,  1, 91, 92, 96, 95, 94, 93, ...
%                  25, 24, 23, 22, 18,  2,120,108,100, 99, 98, 97, ...
%                  21, 20, 19, 14, 10,  6,116,112,104,103,102,101, ...
%                      17, 16, 13,  9,  5,117,113,109,106,105, ...
%                          15, 12,  8,  4,118,114,110,107, ...
%                              11,  7,  3,119,115,111 ];



if length(Net) == 252
    mcs = MEA256_lookuptable;
    MEA = string(ones(252,1));
    letter = 'A':'R';
    letter(letter=='I' | letter == 'Q') = [];
    count = 1;

    for i = 1:16
        for k = 1:length(letter)
            if letter(k) == 'A' | letter(k) == 'R'
                if i <10 & i~=1 
                    MEA(count) = strcat(letter(k),'0',char(string(i)));
                    count = count+1;
                elseif i >=10 & i~= 16
                    MEA(count) = strcat(letter(k),char(string(i)));
                    count = count+1;
                end
                
            else
                 if i <10 
                    MEA(count) = strcat(letter(k),'0',char(string(i)));
                    count = count+1;
                elseif i >=10 
                    MEA(count) = strcat(letter(k),char(string(i)));
                    count = count+1;
                end
            end
        end
    end
    
    
elseif length(Net)==120
    mcs = MEA120_lookuptable;
    MEA = string(ones(120,1));
    letter = 'A':'M';
    letter(letter=='I')=[];
    count = 1;
    
    for i = 1:12
        for k = 1: length(letter)
            if letter(k) == 'A' | letter(k) == 'M'
                if i>3 & i <10
                    MEA(count) = strcat(letter(k),'0',char(string(i)));
                    count = count+1;
                end
            elseif letter(k) == 'B' | letter(k) == 'L'
                if i>2 & i <11
                     if i == 10 
                        MEA(count) = strcat(letter(k),char(string(i)));
                     else
                        MEA(count) = strcat(letter(k),'0',char(string(i)));
                     end
                    count = count+1;
                end
            elseif letter(k) == 'C' | letter(k) == 'K'
                 if i>1 & i <12
                         if i > 9
                            MEA(count) = strcat(letter(k),char(string(i)));
                         else
                            MEA(count) = strcat(letter(k),'0',char(string(i)));
                         end
                         count = count+1;
                 end
            else 

                if i >9
                    MEA(count) = strcat(letter(k),char(string(i)));
                else
                    MEA(count) = strcat(letter(k),'0',char(string(i)));
                end
                count = count+1;
            end
            
        end
    end
    
end



for k = 1:length(mcs)
    check = strfind(mcs(:,1), MEA(k));
    check = find(~cellfun(@isempty,check));
    index = str2num(str2mat(mcs(check,2)));
    tmp(k) = type_hub(index);
end


%node counting 
if length(Net)==120
    count = 1;
    for neuron = 4:l-3
        if tmp(count)==1
            text(neuron,12, 'Exc','FontWeight','bold','HorizontalAlignment','center','Color','red')
        elseif tmp(count) == -1
            text(neuron,12, 'Inh','FontWeight','bold','HorizontalAlignment','center','Color','blue')
        elseif tmp(count)==2
            text(neuron,12, 'N.D','FontWeight','bold','HorizontalAlignment','center')
        end
        count = count+1;
    end

    for neuron = 3:l-2
          if tmp(count)==1
            text(neuron,11, 'Exc','FontWeight','bold','HorizontalAlignment','center','Color','red')
        elseif tmp(count) == -1
            text(neuron,11, 'Inh','FontWeight','bold','HorizontalAlignment','center','Color','blue')
        elseif tmp(count)==2
            text(neuron,11, 'N.D','FontWeight','bold','HorizontalAlignment','center')
        end
        count = count+1;
    end

    for neuron = 2:l-1
        if tmp(count)==1
            text(neuron,10, 'Exc','FontWeight','bold','HorizontalAlignment','center','Color','red')
        elseif tmp(count) == -1
            text(neuron,10, 'Inh','FontWeight','bold','HorizontalAlignment','center','Color','blue')
        elseif tmp(count)==2
            text(neuron,10, 'N.D','FontWeight','bold','HorizontalAlignment','center')
        end
        count = count+1;
    end

    for neuron2 = 9:-1:4
        for neuron = 1:l
            if tmp(count)==1
                text(neuron,neuron2, 'Exc','FontWeight','bold','HorizontalAlignment','center','Color','red')
            elseif tmp(count) == -1
                text(neuron,neuron2, 'Inh','FontWeight','bold','HorizontalAlignment','center','Color','blue')
            elseif tmp(count)==2
                text(neuron,neuron2, 'N.D','FontWeight','bold','HorizontalAlignment','center')
            end
            count = count +1;
        end
    end

    for neuron = 2:l-1
        if tmp(count)==1
            text(neuron,3, 'Exc','FontWeight','bold','HorizontalAlignment','center','Color','red')
        elseif tmp(count) == -1
            text(neuron,3, 'Inh','FontWeight','bold','HorizontalAlignment','center','Color','blue')
        elseif tmp(count)==2
            text(neuron,3, 'N.D','FontWeight','bold','HorizontalAlignment','center')
        end
        count = count+1;
    end

    for neuron = 3:l-2
      if tmp(count)==1
            text(neuron,2, 'Exc','FontWeight','bold','HorizontalAlignment','center','Color','red')
        elseif tmp(count) == -1
            text(neuron,2, 'Inh','FontWeight','bold','HorizontalAlignment','center','Color','blue')
        elseif tmp(count)==2
            text(neuron,2, 'N.D','FontWeight','bold','HorizontalAlignment','center')
        end
        count = count+1;
    end

    for neuron = 4:l-3
      if tmp(count)==1
            text(neuron,1, 'Exc','FontWeight','bold','HorizontalAlignment','center','Color','red')
        elseif tmp(count) == -1
            text(neuron,1, 'Inh','FontWeight','bold','HorizontalAlignment','center','Color','blue')
        elseif tmp(count)==2
            text(neuron,1, 'N.D','FontWeight','bold','HorizontalAlignment','center')
        end
        count = count+1;
    end
    
elseif length(Net)==252
    count = 1;
    for y = l*2-1:-2:1
        for x =1:2:l*2-1
            if (x==1 & y == 1) | (x == 1 & y == l*2-1) | (x == l*2-1 & y == 1) | (x == l*2-1 & y == l*2-1)
            else
                if tmp(count)==1
                    text(x,y, 'Exc','FontWeight','bold','HorizontalAlignment','center')
                elseif tmp(count) == -1
                    text(x,y, 'Inh','FontWeight','bold','HorizontalAlignment','center')
                elseif tmp(count)==2
                    text(x,y, 'N.D','FontWeight','bold','HorizontalAlignment','center')
                end
                count = count+1;
            end
        end
    end
end
  

end
