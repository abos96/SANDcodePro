% Example data (replace this with your actual data)
traces = randn(100, 50); % 5 traces of length 10

% Maximum number of clusters to try
maxK = 10;

% Initialize BIC and AIC vectors
bic_values = zeros(1, maxK);
aic_values = zeros(1, maxK);

% Compute BIC and AIC for different numbers of clusters (1 to maxK)
for k = 1:maxK
    gmm = fitgmdist(traces', k);
    bic_values(k) = gmm.BIC;
    aic_values(k) = gmm.AIC;
end

% Plot BIC and AIC values
figure;
plot(1:maxK, bic_values, 'o-', 'LineWidth', 2);
hold on;
plot(1:maxK, aic_values, 'x-', 'LineWidth', 2);
xlabel('Number of Clusters (k)');
ylabel('BIC / AIC Value');
title('BIC and AIC for Different Number of Clusters');
legend('BIC', 'AIC');
grid on;
hold off;