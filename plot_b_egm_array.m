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
% Description: Plots recorded bEGM information.
% *************************************************************************
%
% PLOT_B_EGM_ARRAY Plots the bEGM information
%
%   PLOT_B_EGM_ARRAY(b_egm, n_rows, n_columns)
%
%   Parameters:
%       b_egm (Double): Bipolar electrogram
%       n_rows (Unsigned Integer): Number of rows of the catheter
%       n_columns (Unsigned Integer): Number of columns of the catheter
%
%   Returns:
%       No output parameters

function plot_b_egm_array(b_egm, n_rows, n_columns)

    figure

    x_min = 10e6;
    y_min = 10e6;
    x_max = -10e6;
    y_max = -10e6;

    for m = 1:(n_rows-1)*(n_columns-1)
        ax(m) = subplot(n_rows-1,n_columns-1,m);
        plot(b_egm(2*m-1,:),b_egm(2*m,:))
        hold on
        yline(0)
        xline(0)

        if (x_min > ax(m).XLim(1))
            x_min = ax(m).XLim(1);
        end

        if (y_min > ax(m).YLim(1))
            y_min = ax(m).YLim(1);
        end

        if (x_max < ax(m).XLim(2))
            x_max = ax(m).XLim(2);
        end

        if (y_max < ax(m).YLim(2))
            y_max = ax(m).YLim(2);
        end
    end

    axis_lim = max(abs([x_min y_min x_max y_max]));

    set(ax,'XLim',[-axis_lim axis_lim])
    set(ax,'YLim',[-axis_lim axis_lim])
    grid(ax,"on")

end