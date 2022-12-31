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
% *************************************************************************
%
% GET_LATS_MULTIPLE_METHODS Computes the local activation time of input egm
%
%   lats = GET_LATS_MULTIPLE_METHODS(egm, fs, mode)
%
%   Parameters:
%       egm (Double): Signal to be analyzed.
%       fs (Double): Sample frequency of egm
%       mode (Unsigned Integer): Number of mode.
%
%   Returns:
%       lats (Double): Array with local activation time of the signal.

function lats = get_lats_multiple_methods(egm, fs, mode)

    switch (mode)
        case 1 % Classic method maximum negative slope of uEGM
            [~,lats] = min(gradient(egm));
            lats = lats/fs;

        case 2 %Classic method for bEGM, maximum peak
            egm_x = egm(1:2:end,:);
            [~,lats] = max(egm_x,[],2);
            lats = lats/fs;

        case 3 % bEGM Center of Mass (BETA)

            warning("CoM mode is on BETA, use it under your responsability.")

            egm_x = egm(1:2:end,:);

            n_of_lats = size(egm_x,1);

            lats = zeros(1,n_of_lats);
            t = (0:size(egm_x(1,:),2)-1)/fs;

            for i = 1:n_of_lats

                [t_begin, t_end, ~, ~] = detect_b_egm_complex(egm_x(i,:), ...
                                                              fs,0.2,0.28);

                % Total area computation
                b_egm_rectified3 = abs(egm_x(i,t_begin:t_end));

                areaT = trapz(t(t_begin:t_end), b_egm_rectified3);
                area50 = cumtrapz(t(t_begin:t_end), b_egm_rectified3);
                center_of_mass = t_begin + find(area50 >= areaT*0.5, 1, ...
                                                'first');

                lats(i) = center_of_mass/fs;

            end

        otherwise
            error('Introduced mode is not recognized.')
    end

end