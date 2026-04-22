clc;
clear;close all
name=["bouncing","coalescence","reflecting","stretching"];
name_str=char(name);
path='D:\rawam\research work\Experiment\Droplet\mine\tetradecane\5 atm\15-01-26 (P-30A)\';
for i=1:1:4
D = dir(strcat(path,'\PROCESS\',name_str(1,:,i)));
for k=1:length(D)-2
% for k=1:1:1
dirname=['time' num2str(k)];%新的文件夹名
OutputDir = strcat(path,'\PROCESS\',name_str(1,:,i),'\',dirname,'\add1\');  %要保存处理后的图像的文件路径
files = dir(fullfile(path,'\original\',name_str(1,:,i),'\',dirname,'\*.tif')); %要处理的图像路径
lengthFiles = length(files)              %要处理图像的数量
for n=1:lengthFiles
Img = imread(strcat(path,'\original\',name_str(1,:,i),'\',dirname,'\',files(n).name));
% thresh=graythresh(Img); %按照图像寻找阈值
% Img=rgb2gray(Img1)
thresh=0.0625*0.3; %人为控制阈值
Img1=im2double(Img);
Img2=im2bw(Img1,thresh);
imwrite(Img2,[OutputDir,files(n).name]);
end
end
end