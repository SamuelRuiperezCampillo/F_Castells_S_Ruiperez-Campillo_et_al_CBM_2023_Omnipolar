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
% Description: Function to compute the delay between electrodes to generate
% synthetic propagation.
% *************************************************************************
%
% COMPUTE_PROPAGATION_DELAY Computes the delay between the first electrode 
% and the rest with the specified velocity, angle and distance for an
% equispaced multi-electrode catheter.
%
%   propagation_delay = COMPUTE_PROPAGATION_DELAY(distance, vc, angle, fs)
%
%   Parameters:
%       distance (Double): Vector containing the unitary distance between 
%          first electrode and the rest.
%       vc (Double): Wavefront conduction velocity. Recommended to use the 
%          range [0.5 - 1 m/s].
%       angle (Double): vector containing the angle between first electrode 
%          and the rest.
%       fs (Double): Sample frequency of the unipolar electrogram
%
%   Returns:
%       propagation_delay (Double): Vector containing the delay in samples 
%          between first electrode and the rest.

function propagation_delay = compute_propagation_delay(distance, vc, ...
                                                       angle, fs)

    propagation_delay = zeros(1,size(distance,2));

    for column = 1:size(distance,2)
        propagation_delay(column) = distance(column)*cos(angle(column))/vc;
    end

    propagation_delay = round(propagation_delay*fs);

end