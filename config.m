close all
clear all
clc
% Bandwidth Macro [Hz]
BMacro = 5e6;
% Bandwidth Drone [Hz]
BDrone = 5e6;
% Macro-BS number fixed do not change
NMeNB = 4;
% Macro radius in [meters]
RMacro =  1350;
% Height of UEs above ground
uheight = 1.5;
% Number of average users per hotspot
M = 10;
% Total number of UEs
T = 400;
% Hotspot radius in [m]
RHotSpot = 100;
% Total number of clusters
clusters = ceil(T / M);
% Transmit power drone
PtdBmDrone = 23;
% Transmit power macro
PtMacrodBm = 43;
% Macro height in [m]
mheight = 15;
% Drone height in [m]
drone_height = 350;
% Noise spectral density [dBm/Hz]
N0dBm = -174;
% Noise spectral density [Watt/Hz]
N0 = 10^((N0dBm - 30) / 10);
% Noise power [Watt]
N = N0 * BMacro;
% sinr threshold
threshold = -90;
% drone init heigth
drone_heigth = 100;