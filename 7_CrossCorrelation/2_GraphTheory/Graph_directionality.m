
%INPUT DATA 
%partial_TCM_n_1:               binary connectivity matrix (60el x 60el) (TH: mean+std)
%color_funct_links:             color of the functional links  
%size_arrow:                    size of the arrows for directionality
%degree_nodes:                  connectivity degree (IN+OUT) of each node.
%common_nodes_PRE_commonPOST01: nodes maintaining links after HF stimulation (common nodes) 

%OUTPUT DATA
%conectivity graph; node's size quantifies the connectivity degree. 
%Nodes in red are nodes maintaining links after stimulation.

function Graph = Graph_directionality(TCM_bin, TCM,color_funct_links,size_link,size_arrow,degree_nodes)

color_folder = uigetdir (pwd, 'Select the ColorElectrode folder');
cd(color_folder);
d = dir;
load(d(3).name);

Cyan = find(ismember(color(:,:), [0 1 1],'rows'));
Gray = find(ismember(color(:,:), [0.8 0.8 0.8],'rows'));
Red = find(ismember(color(:,:), [1 0 0],'rows'));
Green = find(ismember(color(:,:), [0 1 0],'rows'));


Net = TCM_bin;
Con = TCM;
format compact
format long e


%building the coordinate matrix
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
for j = 1: length(x1x2)
    if val(j) > 0
        plot(x1x2(j,:)',y1y2(j,:)','Color',[1, 1-abs(val(j))/max(abs(val)), 0],'LineWidth',size_link);
    else
        plot(x1x2(j,:)',y1y2(j,:)','Color', [0,1-abs(val(j))/max(abs(val)), 1],'LineWidth',size_link);
    end
    hold on
end


for count = 1:120
    if sum(xy(count,3)== Gray)~=0
        plot(xy(count,1),xy(count,2),'o','MarkerEdgeColor','k','MarkerFaceColor',[0 ,0, 0],'MarkerSize',4);
    else
        plot( xy(count,1), xy(count,2),'o','MarkerEdgeColor','k','MarkerFaceColor',[0.85 0.85 0.85],'MarkerSize',4);
    end
end

for n_plot = 1:n_connections
    arrowh(x1x2(n_plot,:),y1y2(n_plot,:),color_funct_links,100,size_arrow);
    hold on
end    

clear count;
clear count02;
xlabel('Electrodes','FontSize',12,'FontName','arial');
ylabel('Electrodes','FontSize',12,'FontName','arial');
set(gcf, 'Color', [1 1 1]);
axis('equal');
axis off; 


colorbar('Position',[0.91,0.11,0.03,0.815],'TickLabels',[-1:0.2:1]);
colormap(jet(256));










