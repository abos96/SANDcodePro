function plotSignalWithDots(signal, timePoints)
    % Plot the signal
    figure;
    plot(signal, 'b.-', 'LineWidth', 1.5);  % Blue line with dots
    hold on;

    % Mark the specific time points with red dots
    for i = 1:length(timePoints)
        specificIndex = timePoints(i);
        if specificIndex >= 1 && specificIndex <= length(signal)
            plot(specificIndex, signal(specificIndex), 'ro', 'MarkerSize', 10, 'LineWidth', 1);
        else
            disp(['Warning: Time point ', num2str(specificIndex), ' is out of range.']);
        end
    end
    hold off;

    % Set axis labels and title
    xlabel('Index');
    ylabel('Signal Value');
    title('Signal Plot with Dots at Specific Time Points');
    grid on;
end