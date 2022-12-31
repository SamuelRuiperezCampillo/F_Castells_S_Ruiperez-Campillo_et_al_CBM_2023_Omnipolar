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
% *****************************************************************************
%
% GENERATE_SYNTHETIC_PROPAGATION Computes the synthetic propagation of the
% specified unipole with the specified velocity, angle and distance for an
% equispaced multi-electrode catheter. Propagation starts from the upper
% left electrode to the rest.
%
%   [synthetic_propagation, reference_LATs] = ...
%                            GENERATE_SYNTHETIC_PROPAGATION(u_EGM, vc, ...
%                            angle, d, n_files, n_columns)
%
%   Parameters:
%       u_egm (Double): Vector containing the unipolar electrogram for 
%          generating the synthetic propagation.
%       vc (Double): Wavefront conduction velocity. Recommended to use the 
%          range[0.5 - 1 m/s].
%       propagation_angle (Double): Wavefront propagation angle in º.
%       fs (Double): Sample frequency of u_EGM
%       d (Double): Inter-electrode distance in m
%       n_rows (Unsigned Integer): Number of rows of the catheter
%       n_columns (Unsigned Integer): Number of columns of the catheter
%
%   Returns:
%       synthetic_propagation (Double): Array of n_rows and n_colums 
%          containing the result of the propagation.
%       reference_LATs (Double): Reference LATs for every clique.

function [synthetic_propagation, reference_LATs] = ...
      generate_synthetic_propagation(u_egm, vc, propagation_angle, fs, ...
                                     d, n_rows, n_columns, ...
                                     compute_reference_LAT, ...
                                     coordinates, LAT_map)

    % Check input parameters
    if(vc <= 0)
        error(strcat('Error: Conduction Velocity Distance should be', ...
                     'greater than 0.'))
    elseif(d <= 0)
        error('Error: Distance should be greater than 0.')
    elseif(n_rows <= 0)
        error('Error: Number of rows should be an integer greater than 0')
    elseif(n_columns <= 0)
        error('Error: Number of columns should be an integer greater than 0')
    elseif(vc < 0.5 || vc > 1)
        warning(strcat('Counduction Velocity is out of recommended', ... 
                       'range [0.5 - 1 m/s].'))
    end

    % We ensure that we work with rows
    u_egm = u_egm(:);
    u_egm = u_egm.';

    % Round the number of rows and columns to the nearest integer
    n_rows = round(n_rows);
    n_columns = round(n_columns);

    % Calculation of the distance matrix from the upper left electrode to 
    % the other electrodes
    [distance, electrode_coord] = compute_distance_matrix(n_rows, n_columns);
    distance = distance*d;

    % Calculation of the angle between the upper left electrode and the 
    % other electrodes
    angle = compute_angle_matrix(n_rows, n_columns);
    angle = angle - deg2rad(propagation_angle);

    % Calculation of the delay of each of the signals as a function of 
    % distance, speed, angle and sampling frequency.
    propagation_delay = compute_propagation_delay(distance, vc, angle, fs);

    if (compute_reference_LAT)

        % Calculations to obtain the propagation delay at the centre of each
        % clique with respect to the upper left electrode.
        [central_distance, central_coord ]= ...
            compute_reference_distance_matrix(n_rows, n_columns, 0.5, 0.5);
        central_distance = central_distance*d;

        central_angle = compute_reference_angle_matrix(n_rows, n_columns, ...
                                                       0.5, 0.5);
        central_angle = central_angle - deg2rad(propagation_angle);

        central_propagation_delay = ...
                    compute_propagation_delay(central_distance, vc, ...
                                              central_angle, fs);

        % Calculations to obtain the propagation delay at the barycentre of
        % each triangular clique with respect to the upper left electrode.

        % T1
        [barycentre_distance_T1,barycentre_T1_coord] = ...
                    compute_reference_distance_matrix(n_rows, n_columns, ...
                                                      0.25, 0.75);
        barycentre_distance_T1 = barycentre_distance_T1*d;

        barycentre_angle_T1 = compute_reference_angle_matrix(n_rows, ...
                                                  n_columns, 0.25, 1-0.25);
        barycentre_angle_T1 = barycentre_angle_T1 - ...
                              deg2rad(propagation_angle);

        barycentre_propagation_delay_T1 = ...
                    compute_propagation_delay(barycentre_distance_T1, ...
                                              vc, barycentre_angle_T1, fs);

        % T2
        [barycentre_distance_T2, barycentre_T2_coord] = ...
                        compute_reference_distance_matrix(n_rows, ...
                                                          n_columns, ...
                                                          0.25, 0.25);
        barycentre_distance_T2 = barycentre_distance_T2*d;

        barycentre_angle_T2 = compute_reference_angle_matrix(n_rows, ...
                                                             n_columns, ...
                                                             0.25, 1-0.75);
        barycentre_angle_T2 = barycentre_angle_T2 - ...
                              deg2rad(propagation_angle);

        barycentre_propagation_delay_T2 = ...
                    compute_propagation_delay(barycentre_distance_T2, ...
                                              vc, barycentre_angle_T2, fs);

        % T3
        [barycentre_distance_T3, barycentre_T3_coord] = ...
                        compute_reference_distance_matrix(n_rows, ...
                                                          n_columns, ...
                                                          0.75, 0.25);
        barycentre_distance_T3 = barycentre_distance_T3*d;

        barycentre_angle_T3 = compute_reference_angle_matrix(n_rows, ...
                                                             n_columns, ...
                                                             0.75, 1-0.75);
        barycentre_angle_T3 = barycentre_angle_T3 - ...
                              deg2rad(propagation_angle);

        barycentre_propagation_delay_T3 = ...
                    compute_propagation_delay(barycentre_distance_T3, ...
                                              vc, barycentre_angle_T3, fs);

        % T4
        [barycentre_distance_T4, barycentre_T4_coord] = ...
                    compute_reference_distance_matrix(n_rows, n_columns, ...
                                                      0.75, 0.75);
        barycentre_distance_T4 = barycentre_distance_T4*d;

        barycentre_angle_T4 = ...
                        compute_reference_angle_matrix(n_rows, n_columns, ...
                                                       0.75, 1-0.25);
        barycentre_angle_T4 = barycentre_angle_T4 - ...
                              deg2rad(propagation_angle);

        barycentre_propagation_delay_T4 = ...
                    compute_propagation_delay(barycentre_distance_T4, ...
                                              vc, barycentre_angle_T4, fs);

        if(coordinates)

            figure
            plot(electrode_coord(1, :), electrode_coord(2, :), ...
                 'sk', MarkerFaceColor='black')
            hold on
            plot(central_coord(1, :), central_coord(2, :), ...
                 '.r', MarkerSize=15)
            plot(barycentre_T1_coord(1,:), barycentre_T1_coord(2, :), ...
                 'x', MarkerSize=10, Color='#77AC30')
            plot(barycentre_T2_coord(1,:), barycentre_T2_coord(2,:), ...
                'x', MarkerSize=10 ,Color='#EDB120')
            plot(barycentre_T3_coord(1,:), barycentre_T3_coord(2,:), ...
                 'x', MarkerSize=10, Color='#EB34A8')
            plot(barycentre_T4_coord(1,:), barycentre_T4_coord(2,:), ...
                 'x', MarkerSize=10, Color='#0398FC')

            for l = 1:n_columns
                line([l-1,l-1], [0,n_columns-1], 'Color', '#c7c5c5')
            end

            for l = 1:n_rows
                line([0,n_rows-1], [l-1,l-1], 'Color', '#c7c5c5')
            end

            xlim([-1 n_columns])
            ylim([-1 n_rows])

            plot(electrode_coord(1,:), electrode_coord(2,:), 'sk', ...
                 MarkerFaceColor='black')

            legend('Electrodo', 'Cross', 'T1', 'T2', 'T3', 'T4',fontsize=12)

            title(['Propagation Angle: ',num2str(propagation_angle)])

        end

    else

        % If the reference LATs are not calculated, a very large negative 
        % value is assigned in order to disregard the parameters when 
        % calculating the offset.
        central_propagation_delay = -1e10;
        barycentre_propagation_delay_T1 = -1e10;
        barycentre_propagation_delay_T2 = -1e10;
        barycentre_propagation_delay_T3 = -1e10;
        barycentre_propagation_delay_T4 = -1e10;

    end

    % uEGM expands to avoid interest signal cuts
    u_egm_expanded = [u_egm(1)*ones(1, round(fs)), u_egm, ...
                      u_egm(end)*ones(1,round(fs))];

    offset = max(abs([propagation_delay,central_propagation_delay, ...
        barycentre_propagation_delay_T1, ...
        barycentre_propagation_delay_T2, ...
        barycentre_propagation_delay_T3, ...
        barycentre_propagation_delay_T4]))/length(u_egm) + 0.1;

    % Electrode-to-electrode propagation
    for m = 1:n_rows*n_columns

        synthetic_propagation(m,:) = u_egm_expanded(round(size(u_egm, ...
                                                               2)*offset) ...
          -propagation_delay(m):end-round(size(u_egm,2)*offset) - ...
           propagation_delay(m));

    end

    if (compute_reference_LAT)

        % Propagation of the unipoles towards the centre of the clique and 
        % the barycentres of the 4 triangles.
        for m = 1:(n_rows-1)*(n_columns-1)

            central_synthetic_propagation(m,:) = ...
                u_egm_expanded(round(size(u_egm,2)*offset) ...
                -central_propagation_delay(m):end - ...
                round(size(u_egm,2)*offset) - central_propagation_delay(m));

            % T1
            barycentre_synthetic_propagation_T1(m,:) = ...
                u_egm_expanded(round(size(u_egm,2)*offset) ...
                -barycentre_propagation_delay_T1(m): ...
                end-round(size(u_egm,2)*offset) - ...
                barycentre_propagation_delay_T1(m));

            %T2
            barycentre_synthetic_propagation_T2(m,:) = ...
                u_egm_expanded(round(size(u_egm,2)*offset) ...
                -barycentre_propagation_delay_T2(m): ...
                end-round(size(u_egm,2)*offset) - ...
                barycentre_propagation_delay_T2(m));

            % T3
            barycentre_synthetic_propagation_T3(m,:) = ...
                u_egm_expanded(round(size(u_egm,2)*offset) ...
                -barycentre_propagation_delay_T3(m): ...
                end-round(size(u_egm,2)*offset) - ...
                barycentre_propagation_delay_T3(m));

            %T4
            barycentre_synthetic_propagation_T4(m,:) = ...
                u_egm_expanded(round(size(u_egm,2)*offset) ...
                -barycentre_propagation_delay_T4(m): ...
                end-round(size(u_egm,2)*offset) - ...
                barycentre_propagation_delay_T4(m));

            % Calculation of the uEGM LATs  (maximum negative slope) at the 
            % centre of the clique and at the barycentre of the 4 triangles.
            [~,refLAT] = min(gradient(central_synthetic_propagation(m,:)));
            central_u_egm_LAT(m) = refLAT/fs;

            % T1
            [~,refLAT] = ...
                min(gradient(barycentre_synthetic_propagation_T1(m,:)));
            barycentre_u_egm_LAT_T1(m) = refLAT/fs;

            % T2
            [~,refLAT] = ...
                min(gradient(barycentre_synthetic_propagation_T2(m,:)));
            barycentre_u_egm_LAT_T2(m) = refLAT/fs;

            % T3
            [~,refLAT] = ...
                min(gradient(barycentre_synthetic_propagation_T3(m,:)));
            barycentre_u_egm_LAT_T3(m) = refLAT/fs;

            % T4
            [~,refLAT] = ...
                min(gradient(barycentre_synthetic_propagation_T4(m,:)));
            barycentre_u_egm_LAT_T4(m) = refLAT/fs;

        end

        reference_LATs = [central_u_egm_LAT', barycentre_u_egm_LAT_T1', ...
            barycentre_u_egm_LAT_T2', barycentre_u_egm_LAT_T3', ...
            barycentre_u_egm_LAT_T4'];

        if(coordinates)

            text(central_coord(1, :)+0.05, n_rows-1-central_coord(2,:), ...
                cellstr(string(central_u_egm_LAT)))
            text(barycentre_T1_coord(1, :)+0.05, ...
                n_rows-1-barycentre_T1_coord(2, :), ...
                cellstr(string(barycentre_u_egm_LAT_T1)))
            text(barycentre_T2_coord(1, :)+0.05, ...
                n_rows-1-barycentre_T2_coord(2, :), ...
                cellstr(string(barycentre_u_egm_LAT_T2)))
            text(barycentre_T3_coord(1, :)+0.05, ...
                n_rows-1-barycentre_T3_coord(2, :), ...
                cellstr(string(barycentre_u_egm_LAT_T3)))
            text(barycentre_T4_coord(1, :)+0.05, ...
                n_rows-1-barycentre_T4_coord(2, :), ...
                cellstr(string(barycentre_u_egm_LAT_T4)))

        end

        if(LAT_map)
            LATs = reshape(reference_LATs(:, 1), [3 3])';
            figure
            imagesc(LATs)
            colormap autumn %winter
            colorbar

            axLAT = gca;

            set(axLAT, 'xaxisLocation', 'top', 'FontWeight', 'bold', ...
                'Layer', 'top', 'XTick', [0.5 1.5 2.5 3.5], ...
                'XTickLabel', {'A','B','C','D'}, 'YTick', ...
                [0.5 1.5 2.5 3.5], 'YTickLabel', {'1','2','3','4'});
            textStrings = num2str(LATs(:));
            textStrings = strtrim(cellstr(textStrings));
            [x, y] = meshgrid(1:3);
            hold(axLAT, 'on');
            hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the str
                'HorizontalAlignment', 'center', 'FontSize', 12, ...
                'FontWeight', 'bold', 'Parent', axLAT);
            midValue = mean(get(axLAT, 'CLim'));
            textColors = repmat(LATs(:) < midValue, 1, 3);
            set(hStrings, {'Color'}, num2cell(textColors, 2));
        end

    else

        reference_LATs = -1;

    end

end