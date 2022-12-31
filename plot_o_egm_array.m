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
% Description: Plots recorded oEGM information.
% *************************************************************************
%
% PLOT_O_EGM_ARRAY Plots the oEGM information
%
%   PLOT_O_EGM_ARRAY(o_egm, n_rows, n_columns)
%
%   Parameters:
%       o_egm (Double): Omnipolar electrogram.
%       n_rows (Unsigned Integer): Number of rows of the catheter.
%       n_columns (Unsigned Integer): Number of columns of the catheter.
%
%   Returns:
%       No output parameters

function plot_o_egm_array(o_egm,n_rows,n_columns)

    figure

    for m = 1:(n_rows-1)*(n_columns-1)
        subplot(n_rows-1, n_columns-1, m)
        plot(o_egm(2*m-1, :))
        hold on
        plot(o_egm(2*m, :))
    end

end