function col_str = convertColor2 (color_vector, mcs)

if isvector(mcs)
    col_str(sum(color_vector == [1 0 0],2)==3,2) = strcat('0',string(mcs(sum(color_vector == [1 0 0],2)==3)));% Red
    col_str(sum(color_vector == [0 1 0],2)==3,2) = strcat('0',string(mcs(sum(color_vector == [0 1 0],2)==3)));% Green
    col_str(sum(color_vector == [0 1 1],2)==3,2) = strcat('0',string(mcs(sum(color_vector == [0 1 1],2)==3)));% Cyan
    col_str(sum(color_vector == [0.8 0.8 0.8],2)==3,2) = strcat('0',string(mcs(sum(color_vector == [0.8 0.8 0.8],2)==3)));% Gray
    col_str(sum(color_vector == [1 0 1],2)==3,2) = strcat('0',string(mcs(sum(color_vector == [1 0 1],2)==3)));% Violet
    col_str(sum(color_vector == [1 1 0],2)==3,2) = strcat('0',string(mcs(sum(color_vector == [1 1 0],2)==3)));% Yellow
    col_str(sum(color_vector == [0 0 1],2)==3,2) = strcat('0',string(mcs(sum(color_vector == [0 1 1],2)==3)));% Blue
    
    
    col_str(sum(color_vector == [0 0 1],2)==3,1) = string('Blue');
    col_str(sum(color_vector == [1 1 0],2)==3,1) = string('Yellow');
    col_str(sum(color_vector == [1 0 0],2)==3,1) = string('Red');
    col_str(sum(color_vector == [0 1 0],2)==3,1) = string('Green');
    col_str(sum(color_vector == [0 1 1],2)==3,1) = string('Cyan');
    col_str(sum(color_vector == [0.8 0.8 0.8],2)==3,1) = string('Gray');
    col_str(sum(color_vector == [1 0 1],2)==3,1) = string('Violet');
else
    el_cyan = string(find(sum(color_vector == [0 1 1],2)==3));
    el_red = string(find(sum(color_vector == [1 0 0],2)==3));
    el_green = string(find(sum(color_vector == [0 1 0],2)==3));
    el_gray = string(find(sum(color_vector == [0.8 0.8 0.8],2)==3));
    el_violet= string(find(sum(color_vector == [1 0 1],2)==3));
    el_yellow = string(find(sum(color_vector == [1 1 0],2)==3));
    el_blue = string(find(sum(color_vector == [0 0 1],2)==3));
   
    if ~isempty(el_cyan)% Cyan
       [C,ia,ib] = intersect(str2num(str2mat(mcs(:,2))), str2num(str2mat(el_cyan)), 'stable');
       col_str(ia,2) = mcs(ia,2);
       col_str(ia,1) = string('Cyan');
    end
    if ~isempty(el_red)% Red
       [C,ia,ib] = intersect(str2num(str2mat(mcs(:,2))), str2num(str2mat(el_red)), 'stable');
       col_str(ia,2) = mcs(ia,2);
       col_str(ia,1) = string('Red');
    end
    if ~isempty(el_green)% Green
       [C,ia,ib] = intersect(str2num(str2mat(mcs(:,2))), str2num(str2mat(el_green)), 'stable');
       col_str(ia,2) = mcs(ia,2);
       col_str(ia,1) = string('Green');
    end
    if ~isempty(el_gray)% Gray
       [C,ia,ib] = intersect(str2num(str2mat(mcs(:,2))), str2num(str2mat(el_gray)), 'stable');
       col_str(ia,2) = mcs(ia,2);
       col_str(ia,1) = string('Gray');
    end
    if ~isempty(el_violet)% Violet
       [C,ia,ib] = intersect(str2num(str2mat(mcs(:,2))), str2num(str2mat(el_violet)), 'stable');
       col_str(ia,2) = mcs(ia,2);
       col_str(ia,1) = string('Violet');
    end
    if ~isempty(el_yellow)% Yellow
       [C,ia,ib] = intersect(str2num(str2mat(mcs(:,2))), str2num(str2mat(el_yellow)), 'stable');
       col_str(ia,2) = mcs(ia,2);
       col_str(ia,1) = string('Yellow');
    end
    if ~isempty(el_blue)% Blue
       [C,ia,ib] = intersect(str2num(str2mat(mcs(:,2))), str2num(str2mat(el_blue)), 'stable');
       col_str(ia,2) = mcs(ia,2);
       col_str(ia,1) = string('Blue');
    end           
end


end
