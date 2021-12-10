%% BIOENG 1340 Final Project Part 1
% Team 4 - Pooja Chawla, Danielle Pitlor, Ruxuan (Rosy) Li
% Last edited: 11/8/21
% Note: make sure you have tumorloc.mat and nontumorloc.mat in the same
% folder for the code to run properly

clear; clc; close all;

%% 2D X-Ray Image Analysis
%% Loading in Data
folder = 'Dataset\';
data = dir([folder,'*.jpg']);
files = {data.name};

count = numel(files); 

%loading in locations for ROIs
load("tumorloc.mat");
load('nontumorloc.mat');

%% CNR and SNR analysis
for i = 1:count
    %crop tumor part
    croppedtum = imcrop(im2double(imread([folder,files{i}])),rect1(i,:));
    sizey = size(croppedtum);
    if sizey(end) == 3
        croppedtum = rgb2gray(croppedtum);
    end
    %crop non tumor part
    croppednotum = imcrop(im2double(imread([folder,files{i}])),rect2(i,:));
    sizey = size(croppednotum);
    if sizey(end) == 3
        croppednotum = rgb2gray(croppednotum);
    end
    
    %mean intensity of tumor and non tumor regions
    meantum(i) = mean(croppedtum(:));
    meannotum(i) = mean(croppednotum(:));
    
    %max intensity of tumor and non tumor regions
    maxtum(i) = max(croppedtum(:));
    maxnotum(i) = max(croppednotum(:));

    sdintensity = std([croppedtum(:);croppednotum(:)]);

    %CNR for image of tumor vs non tumor
    CNR(i) = abs(meantum(i)-meannotum(i))/sdintensity;
    
    %SNR for image
    SNRtum(i) = abs(meantum(i))/std(croppedtum(:)); %tumor portion
    SNRnotum(i) = abs(meannotum(i))/std(croppednotum(:)); %non tumor portion
    
    %radiomics
    %grey level non uniformity tumor
    [GLRM,SI] = grayrlmatrix(croppedtum);
    statstum{i} = grayrlprops(GLRM);
    GLNtum(i,:) = statstum{i}(:,3);
    
    %grey level non uniformity non tumor
    [GLRM2,SI2] = grayrlmatrix(croppednotum);
    statsnotum{i} = grayrlprops(GLRM2);
    GLNnotum(i,:) = statsnotum{i}(:,3);

end
close all;