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
% Description: Function that computes omnipolar electrogram.
% *************************************************************************
%
% COMPUTE_ANGLE_MATRIX Computes the omnipolar electrogram rotating bipolar 
% electrogram by estimated rotation angle.
%
%   o_egm = COMPUTE_O_EGM(b_egm, angle, n_rows, n_columns)
%
%   Parameters:
%       b_egm: (Double): Bipolar electrogram.
%       n_rows (Unsigned Integer): Number of rows of the catheter.
%       n_columns (Unsigned Integer): Number of columns of the catheter.
%
%   Returns:
%       o_egm (Double): Omnipolar electrogram.

function o_egm = compute_o_egm(b_egm,angle,n_rows,n_columns)

    o_egm = zeros(2*(n_rows-1)*(n_columns-1),size(b_egm,2));

    for m = 1:(n_rows-1)*(n_columns-1)

        Q = rot2D(-angle(m));
        o_xy = Q*b_egm(2*m-1:2*m,:);

        o_egm(2*m-1,:) = o_xy(1,:);
        o_egm(2*m,:) = o_xy(2,:);

    end

end