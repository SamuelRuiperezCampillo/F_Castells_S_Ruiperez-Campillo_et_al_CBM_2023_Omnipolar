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
% Description: Function that computes the difference between two unipolar 
%              EGMs to obtain the bipolar EGM.
% *************************************************************************
%
% COMPUTE_B_EGM Computes the bipolar EGM on the x and y axes for each of 
% the cliques using the  using the specified method (Triangles, Mean Square 
% or Cross).
%
%   b_egm = COMPUTE_B_EGM(u_egm, n_rows, n_columns, mode)
%
%   Parameters:
%       u_egm (Double): Unipolar electrogram
%       n_rows (Unsigned Integer):  Number of rows of the catheter
%       n_columns (Unsigned Integer): 1-4: Traingular, 5:Square , 6:Cross
%       mode (Unsigned Integer): Number of columns of the catheter
%
%   Returns:
%       b_egm (Double): Array containing bipolar electrograms

function b_egm = compute_b_egm(u_egm,n_rows,n_columns,mode)

    b_egm = zeros(2*(n_rows-1)*(n_columns-1),size(u_egm,2));

    for row = 1:(n_rows-1)
        for column = 1:(n_columns-1)

            clique_number = (row-1) * (n_columns-1) + column;
            electrode_number = ((row-1) * n_columns) + column;

            switch (mode)
                case 1
                    bx = u_egm(electrode_number+n_columns+1,:) - ...
                         u_egm(electrode_number+n_columns,:);
                    by = u_egm(electrode_number,:) - ...
                         u_egm(electrode_number+n_columns,:);

                case 2
                    bx = u_egm(electrode_number+1,:) - ...
                         u_egm(electrode_number,:);
                    by = u_egm(electrode_number,:) - ...
                         u_egm(electrode_number+n_columns,:);

                case 3
                    bx = u_egm(electrode_number+1,:) - ...
                         u_egm(electrode_number,:);
                    by = u_egm(electrode_number+1,:) - ...
                         u_egm(electrode_number+n_columns+1,:);

                case 4
                    bx = u_egm(electrode_number+n_columns+1,:) - ...
                         u_egm(electrode_number+n_columns,:);
                    by = u_egm(electrode_number+1,:) - ...
                         u_egm(electrode_number+n_columns+1,:);

                case 5 
                    bx = mean([u_egm(electrode_number+1,:) - ...
                         u_egm(electrode_number,:); ...
                         u_egm(electrode_number+n_columns+1,:) - ...
                         u_egm(electrode_number+n_columns,:)],1);
                    by = mean([u_egm(electrode_number,:) - ...
                         u_egm(electrode_number+n_columns,:); ...
                         u_egm(electrode_number+1,:) - ...
                         u_egm(electrode_number+n_columns+1,:)],1);

                case 6
                    bx = u_egm(electrode_number+1,:) - ...
                         u_egm(electrode_number+n_columns,:);
                    by = u_egm(electrode_number,:) - ...
                         u_egm(electrode_number+n_columns+1,:);
                    Q45 = rot2D(45);
                    bxy = Q45*[bx;by];
                    bx = bxy(1,:);
                    by = bxy(2,:);

                otherwise
                    error('Introduced mode is not recognized.')
            end

            b_egm(2*clique_number-1,:) = bx;
            b_egm(2*clique_number,:) = by;
        end

    end

end

