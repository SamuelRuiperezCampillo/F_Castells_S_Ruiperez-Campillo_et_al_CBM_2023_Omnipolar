% *****************************************************************************
% QCEP ITACA UPV
% Omnipolar Analysis
% 
% Authors: Izan Segarra
% Date: 07/05/2022
%
% Description: This function computes the rotation matrix of given angle in º
% *****************************************************************************
%
% ROT2D Computes the rotation matrix of given angle in degrees.
%
%   Q = ROT2D(angle)
%
%   Parameters:
%   angle (Double): Rotation angle
%   
%   Returns:
%   Q (Double): 2x2 Rotation matrix

function Q = rot2D(angle)

Q = [cosd(angle) -sind(angle); sind(angle) cosd(angle)];

end