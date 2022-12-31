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
% Description: Function that computes the angle between the first electrode 
% (upper left corner) and the rest of the electrodes.
% *************************************************************************
%
% COMPUTE_ANGLE_MATRIX Computes the angle between the first electrode 
% (upper left corner) with respect to the other electrodes to obtain the 
% angle matrix needed to generate the synthetic propagation.
%
%   distance_matrix = COMPUTE_DISTANCE_MATRIX(n_rows, n_columns)
%
%   Parameters:
%       n_rows (Unsigned Integer): Number of rows of the catheter
%       n_columns (Unsigned Integer): Number of columns of the catheter
%
%   Returns:
%       angle_matrix (Double): Vector containing the angle between first 
%                              electrode and the rest.

function angle = compute_angle_matrix(n_rows, n_columns)

    angle_matrix = zeros(n_rows, n_columns);

    for row = 1:n_rows
        for column = 1:n_columns
            if (row == 1 && column ==1)
                continue;
            else
                angle_matrix(row,column) = atan2(-row+1,column-1);
            end
        end
    end

    angle = reshape(angle_matrix.',1,[]);

end