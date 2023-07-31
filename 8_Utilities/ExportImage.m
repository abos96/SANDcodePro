function ExportImage(fig, x_size, y_size, resolution, filename, fileformat)
% This function allows to save an image by setting:

% dimensions (x_size, y_size) expressed in centimeters;
% resolution (resolution) espressed in dot-per-inch (dpi)
% fileformat is relative to file format used to save the image. Examples
% are: '-dpng','-dtiff'. Note that jpeg does not allow setting resolaution.
% the variable fig indicates the handle of the figure (fig = gcf;);
% The script expand the axes of the plot in order to fill all the space of
% the figure.
% 
% The user has to indicate the filename of the image.
% 
%               Paolo Massobrio - last update 12th March 2013 
% 

% setting the size of the figure
set(fig,'Units','centimeters');
set(fig,'PaperPositionMode','auto');
set(fig, 'Position', [0 0 x_size y_size]);
% expand axes to fill figure 
style = hgexport('factorystyle');
style.Bounds = 'tight';
hgexport(fig,'-clipboard',style,'applystyle', true);
drawnow;
% saving and assign resolution
print(fig,filename,fileformat,['-r',num2str(resolution)],'-opengl'); %save file 
