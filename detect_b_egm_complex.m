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
% Description: Function that detects the activation window of bEGM complex
% *************************************************************************
%
% DETECT_B_EGM_COMPLEX Computes start and end of bipolar electrogram complex
%
%   [t_begin, t_end, b_egm_rectified2, b_egm_q] = ...
%                                    DETECT_B_EGM_COMPLEX(b_egm,fs,th1,th2)
%
%   Parameters:
%       b_egm (Double): Bipolar electrogram
%       fs (Double): Sample frequency of bEGM
%       th1 (Double): Threshold one.
%       th2 (Double): Threshold two.
%
%   Returns:
%       t_begin (Double): Start of bEGM complex and the rest.
%       t_end (Double): End of bEGM complex
%       b_egm_rectified2 (Double): Modulus of bEGM complex
%       b_egm_q: Signal quality (SNR in dB)

function [t_begin, t_end, b_egm_rectified2, b_egm_q] = ...
                                    detect_b_egm_complex(b_egm,fs,th1,th2)

    fn = fs/2; %Nyquist Freq
    [b,a] = butter(1,[2 15]/fn,"bandpass");
    b_egm_filtered = filtfilt(b,a,b_egm);
    %figure; plot(b_egm_filtered)

    b_egm_rectified = abs(b_egm_filtered);
    %figure; plot(b_egm_rectified)

    P5 = prctile(b_egm_rectified,5);
    P100 = prctile(b_egm_rectified,100);

    threshold = P5 + (P100 - P5)*th1;

    %Start and end of bEGM complex
    isolectric_w_begin = find(b_egm_rectified >= threshold, 1, 'first');
    isoelectric_w_end = find(b_egm_rectified >= threshold, 1, 'last');
    %xline(isolectric_w_begin)
    %xline(isolectric_w_end)

    b_egm_differentiated = gradient(b_egm);
    %figure; plot(b_egm_differentiated)

    [b,a] = butter(1,[5 300]/fn,"bandpass");
    b_egm_filtered2 = filtfilt(b,a,b_egm_differentiated);
    %figure; plot(b_egm_filtered2)

    b_egm_rectified2 = abs(b_egm_filtered2);
    %figure; plot(b_egm_rectified2)

    noise_level = max([b_egm_rectified2(1:isolectric_w_begin) ...
                       b_egm_rectified2(end:end-isoelectric_w_end)]);
    %detection_th = prctile([b_egm_rectified2(1:isolectric_w_begin) ...
    %                        b_egm_rectified2(end:end-isoelectric_w_end)],98);
    detection_th = noise_level*th2;

    t_begin = find(b_egm_rectified2 >= detection_th, 1, 'first');
    t_end = find(b_egm_rectified2 >= detection_th, 1, 'last');

    %bEGM quality. (HQ for SNR > 13 dB and LQ for SNR < 13 dB)
    Asn = rms(b_egm_rectified2(t_begin:t_end));
    An = rms([b_egm_rectified2(1:t_begin) b_egm_rectified2(end:end-t_end)]);

    b_egm_q = 20*log10((Asn-An)/An);

end