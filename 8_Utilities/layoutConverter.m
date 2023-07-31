function [] = layoutConverter (phase)

    w = waitbar(1,'Converting format - Please wait...'); % waitbar

    for i = 3:length(phase)
        waitbar((i-2)/(length(phase)-2))
        cd(phase(i).name);

        d = dir;
        if length(d)-2 == 120
            m = MEA120_lookuptable;
        elseif length(d)-2 == 152
            m = MEA256_lookuptable;
        else
            m = MEA4Q_lookuptable;
        end

            for k = 3:length(d)
                load(d(k).name);
                name = split(d(k).name,'.');
                na1= split(name(1));
                na2= split(na1(1),'_');
                index = strcmp(string(str2num(str2mat(na2(end)))),(m(:,2)));

                if index == 0 % Control if the selected mat files are compatible with the convertion
                    errordlg('Selection failed - Not compatible format','Error');
                    return
                end

                el = m(index,1);
                save(strcat(char(na2(1)),'_',char(na2(2)),'_',char(na2(3)),'_',char(na2(4)),'_',char(na2(5)),'_',char(el)),'data');
                delete(fullfile(d(k).folder,d(k).name));
            end

            cd ..
    end
delete(w);
end


