    % adjM : matrix 
%    adjacency matrix 
% coords : matrix 
%    electrode/node coordinates (x and y, num nodes * 2)
% edge_thresh : float 
%    a value between 0 and 1 for the minimum correlation to plot
% z : str
%    the network metric used to determine the size of the plotted nodes
%     eg: node degree or node strength
%  zname : str
%     name of the z network metric
%   z2 : str
%     the network metric used to determine the colour of the plotted
%      nodes, eg: betweeness centrality or participation coefficient
%   z2name : str
%     name of the z2 network metric
%   plotType : str
%       'MEA' to plot nodes with their respective electrode
%       coordinates and 'circular' to plot nodes in a circle
% 
    [figureHandle, cb] = StandardisedNetworkPlotNodeColourMap(adjM, coords,...
        0.01, NS, 'Node Strength', NS, 'Node Strength', 'MEA', connFolder,0.01);