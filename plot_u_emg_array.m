% *************************************************************************
% QCEP ITACA UPV
% Omnipolar Analysis
% 
% Authors: Izan Segarra, Samuel Ruipérez-Campillo, Francisco Castells.
% Date: 07/05/2022
% 
% Any individual benefiting from any of this code must cite the work as: 
% F. Castells, S. Ruiperez-Campillo, I. Segarra, R. Cervig ́on, 
% R. Casado-Arroyo, J. Merino, J. Millet, Performance assessment 
% of electrode configurations for the estimation of omnipolar electrograms 
% from high density arrays, Computers in Biology and Medicine (2023).
%
% Description: Plots recorded uEGM information.
% *************************************************************************
%
% PLOT_U_EGM_ARRAY Plots the uEGM information
%
%   PLOT_U_EGM_ARRAY(u_egm, fs, n_rows, n_columns)
%
%   Parameters:
%       u_egm (Double): Unipolar electrogram
%       fs (Double): Sample frequency
%       n_rows (Unsigned Integer): Number of rows of the catheter
%       n_columns (Unsigned Integer): Number of columns of the catheter
%
%   Returns:
%       No output parameters

function plot_u_emg_array(u_egm, fs, n_rows, n_columns)

    hold('off')

    plotOffset = zeros(1,n_rows*n_columns);

    [~,col] = size(u_egm);
    time = (1:col)/fs;

    maxValue = max(u_egm');
    minValue = min(u_egm');
    plotOffset(2:n_rows*n_columns) =  minValue(1:end-1) - maxValue(2:end) ...
               - max(max(maxValue,abs(minValue)));
    plotOffset = cumsum(plotOffset);

    for i=1:n_rows*n_columns

        plot(time, u_egm(i, :)+plotOffset(i), 'linewidth', 2);

    hold('on')
    grid('on')
    end

    % xlabel('Time (s)')
    % yticks(plotOffset(end:-1:1));
    % labels = {'D4','D3','D2','D1','C4','C3','C2','C1','B4','B3','B2', ...
    %           'B1','A4','A3','A2','A1'};
    % yticklabels(labels)
    % ylabel('Electrodes')
    % ylim('padded')

end