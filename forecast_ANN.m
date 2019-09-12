%% Clear the WorkSpace and CommandWindow
%% the ten-fold cross-validation was used to assess model prediction accuracy
%% OutputF6 is the optimal solution we need
% clear all
% close all
% clc

%% Load files and options

InpFile = '210419TA_Nesb10_NET20_12.mat';

load( InpFile, 'net'); % load the 'net' 


%% Load an independent data set TS or MapTS to make more tests or a forecast
%  read data
 prodata = xlsread('F:\AT and DIC\Code\MATLAB\original data.xlsx','used');
 
%  prodata = load('/home/xsli/changjiang_biology_ersem/monthly_data/data1999_2016.dat');% obtain .dat

% Remove NaNs present in inputs and targets 
% for n = size(prodata,2):-1:1;
%     fNaN = isnan ( prodata(:,n) ) == 1;
%     prodata(fNaN,:) = [];
% end;
% clear fNaN;

% Year = prodata(:,1); % year
% Botdep = prodata(:,2); % Botdep
% Siglay = prodata(:,3); % Sig
Lon = prodata(:,4); % Lon
Lat = prodata(:,5); % Lat
month = prodata(:,6); % month
% dep = prodata(:,7); % Depth
T = prodata(:,8); % T
T = T + 0.001;
S = prodata(:,9); % S
% S = S + 0.002;
DO = prodata(:,10); % DO
% DO = DO + 0.05;
% pH = data(:,10); % pH
% TA = data(:,11); % TA
% TC = data(:,12); % TC
% pCO2 = data(:,13); % pCO2
% Diat = prodata(:,14); % diatoms 
% Nano = prodata(:,15); % nanophytoplankton
% Pico = prodata(:,16); % picophytoplankton
% Micro = prodata(:,17); % microphytoplankton
% TChla  = prodata(:,18); % total cholorophyll

% normalization
% Doy = (prodata(:,2)*pi)/182.625; % Doy periodicity

Lon_n = (Lon*pi)/180; % Lon periodicity
Lat_n = Lat/90; % Lat 
month_n = (month*pi)/6; % month periodicity

prodata_N= [sin(Lon_n) cos(Lon_n) sin(month_n) cos(month_n) Lat_n T S DO];

av = load('mean_train.dat');
sd = load('std_train.dat');

%%standardization of all values
for i=5:8
    prodata_N(:,i) = (2/3)*((prodata_N(:,i)-av(i))/sd(i));
end
% save prodata_N.dat prodata_N -ascii

Nesb  =   10 ; % ensemble number ten model
% maeF  = cell(1,Nesb);
% rmseF = cell(1,Nesb); % initialize the total RMSE in a cell which will contain all indiv. RMSE structures
% r2F    = cell(1,Nesb); % initialize the total R2 in a cell which will contain all indiv. R2 structures
OutputsF = cell(1,Nesb); % initialize the total outputs in a cell which will contain all indiv. outputs structures
% TargetsF = cell(1,Nesb); % initialize the total targets in a cell which will contain all indiv. targets structures

for i = 1:Nesb % 
    
    assignin ( 'base',  strcat ( 'net', num2str (i) ) , net{1,i} ) ;

%% Prepare the inputs and targets in correct row-column configuration
inputsF = prodata_N(:,1:8)'; %% input
% targetsF = prodata_N(:,9)';%% output

%% Simulate
outputsF = sim (eval(strcat('net',num2str(i))), inputsF ); 
outputsF=1.5*outputsF*sd(9)+av(9); % 
% targetsF=1.5*targetsF*sd(9)+av(9); % 

% MAEF     = sum(abs(targetsF-outputsF))/size(outputsF,2);
% RMSEF    = sqrt( sum((targetsF-outputsF).^2)/size(outputsF,2) );
% R2F       = 1-sum((targetsF-outputsF).^2)/sum((targetsF-mean(targetsF)).^2);

%     assignin ( 'base',  strcat ( 'maeF', num2str (i) ) , MAEF ) ;
%     assignin ( 'base',  strcat ( 'rmseF', num2str (i) ) , RMSEF ) ;
%     assignin ( 'base',  strcat ( 'r2F', num2str (i) ) , R2F ) ;
    assignin ( 'base',  strcat ( 'OutputF', num2str (i) ) , outputsF ) ;
%     assignin ( 'base',  strcat ( 'TargetF', num2str (i) ) , targetsF ) ;
    
    clear outputsF ;
    
%     maeF{1,i} = eval ( strcat('maeF', num2str (i)) ) ;
%     rmseF{1,i} = eval ( strcat('rmseF', num2str (i)) ) ;
%     r2F{1,i} = eval ( strcat('r2F', num2str (i)) ) ;
    OutputF{1,i} = eval ( strcat('OutputF', num2str (i)) ) ;
%     TargetF{1,i} = eval ( strcat('TargetF', num2str (i)) ) ;

end        

   