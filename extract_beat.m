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
% Description: Function that extract a beat from unipolar electrogram
% *************************************************************************
%
% EXTRACT_BEAT Computes the start and end time of a beat on unipolar 
% electrogram and cuts the signal.
%
%   [egm_cutted, t_start, t_end] = EXTRACT_BEAT(egm, duration, fs)
%
%   Parameters:
%   egm (Unsigned Integer): Unipolar electrogram
%   duration (Double): Time window
%   fs (Double): Sample frecuency of signal
%
%   Returns:
%   egm_cutted (Double): Cutted electrogram
%   t_start (Double): Init of beat window
%   t_end (Double): End of beat window

function [egm_cutted, t_start, t_end] = extract_beat(egm,duration,fs)

    num_of_signals = size(egm,1);
    lats = zeros(1,num_of_signals);

    for m = 1:num_of_signals
        lats(m) = get_lats_multiple_methods(egm(m,:), fs, 1);
    end

    lats = lats*fs;

    t_start = min(lats - round(fs*(duration/2)*1e-3));
    t_end = max(lats + round(fs*(duration/2)*1e-3));

    dbstop if warning
    egm_cutted = egm(:,round(t_start):round(t_end));

end