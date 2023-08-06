function selectedItems = selectItemsFromListbox(items)

    % Define the list of items for the listbox
    %items = {'Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'};

    % Create the listbox dialog
    [selectedIdx, ~] = listdlg('PromptString', 'Select items:', ...
                               'SelectionMode', 'multiple', ...
                               'ListString', items);

    % Check if the user clicked 'Cancel'
    if isempty(selectedIdx)
        disp('No items selected.');
        selectedItems = [];
    else
        % Get the selected items based on the selected indices
        selectedItems = items(selectedIdx);
        disp('Selected items:');
        disp(selectedItems);
    end

end