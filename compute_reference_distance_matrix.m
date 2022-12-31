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
% Description: Function that computes the unitary distance of the first 
% electrode (upper left corner) with respect to the rest of the electrodes.
% *************************************************************************
%
% COMPUTE_DISTANCE_MATRIX Computes the unitary distance of the first 
% electrode (upper left corner) with respect to the other electrodes to 
% obtain the distance matrix needed to generate the synthetic propagation.
%
%   [distance, coord] = COMPUTE_DISTANCE_MATRIX(n_rows, n_columns)
%
%   Parameters:
%       n_rows (Unsigned Integer): Number of rows of the catheter
%       n_columns (Unsigned Integer): Number of columns of the catheter
%
%   Returns:
%       distance_matrix (Double): Vector containing the unitary distance 
%          between first electrode and the rest.
%       coord (Unisgned Integer): Distance coordinates

function [distance, coord] = compute_reference_distance_matrix(n_rows, ...
                                                               n_columns, ...
                                                               x_offset, ...
                                                               y_offset)

    distance_matrix = zeros(n_rows-1, n_columns-1);
    x_coord = zeros(n_rows-1, n_columns-1);
    y_coord = zeros(n_rows-1, n_columns-1);

    for row = 1:n_rows-1
        for column = 1:n_columns-1
            distance_matrix(row,column) = pdist([0,0;column-1+x_offset, ...
                                                 row-1+y_offset], ...
                                                'euclidean');
            x_coord(row,column) = column-1+x_offset;
            y_coord(row,column) = row-1+y_offset;
        end
    end

    x_coord = reshape(x_coord.',1,[]);
    y_coord = reshape(y_coord.',1,[]);

    coord = [x_coord;y_coord];

    distance = reshape(distance_matrix.',1,[]);

end