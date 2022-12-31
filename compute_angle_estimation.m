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
% Description: Function that estimates propagation angle of bipolar signal
% *************************************************************************
%
% COMPUTE_ANGLE_ESTIMATION Estimates propagation angle of bipolar 
%                          electrogram
%
%   angle_stimation = COMPUTE_ANGLE_ESTIMATION(b_egm, n_rows,n_columns)
%
%   Parameters:
%       b_egm (Double): Bipolar electrogram
%       n_rows (Unsigned Integer): Number of rows of the catheter
%       n_columns (Unsigned Integer): Number of columns of the catheter
%
%   Returns:
%       angle_stimation (Double): Array containing angle stimation of input 
%                                 signals

function angle_estimation = compute_angle_estimation(b_egm, n_rows, n_columns)

    angle_estimation = zeros(1,(n_rows-1)*(n_columns-1));

    for i = 1:2:2*(n_rows-1)*(n_columns-1)
        [TH,R] = cart2pol(b_egm(i,:),b_egm(i+1,:));
        [~,idx] = max(R);
        angle_estimation(ceil(i/2)) = TH(idx);
    end

    angle_estimation = rad2deg(angle_estimation);

end