% *****************************************************************************
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
% Description: Function that computes peak to peak amplitude of input 
%              signal.
% *************************************************************************
%
% COMPUTE AMPLITUDE Computes the peak to peak amplitude of input oEGM
%
%   amplitude = COMPUTE_AMPLITUDE(o_egm, n_rows,n_columns)
%
%   Parameters:
%       o_egm (Double): Signal to be analyzed.
%       n_rows (Unsigned Integer): Number of rows of the catheter.
%       n_columns (Unsigned Integer): Number of columns of the catheter.
%
%   Returns:
%       amplitude (Double): Array with peak to peak amplitude.

function amplitude = compute_amplitude(o_egm, n_rows,n_columns)

    amplitude = zeros(1,(n_rows-1)*(n_columns-1));

    for i = 1:2:2*(n_rows-1)*(n_columns-1)
        amplitude(ceil(i/2)) = max(o_egm(i,:)) - min(o_egm(i,:));
    end

end