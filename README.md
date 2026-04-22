# droplet-detection-and-parameter-extraction
for thesis

clc
clear;close all 
factor=5.1372e-6;%照片上一个像素代表的实际距离 7.2X
% factor=5.1372e-6*7.2/5;%照片上一个像素代表的实际距离 4X
T=1/25000; %一个时间间隔
t=T;
Rho=746.52; %液滴的密度
sigma=0.0249; %液滴的表面张力系数
interval=4; %人为选定照片张数
gap=0;   %为读取中间图片的情况预备
cropHeight = 500;   %确定裁剪的高度
Highbegin = 2;
cropWidth = 512; 
Widthbegin = 1;
path='D:\rawam\research work\Experiment\Droplet\mine\dodecane (C12H26)\5 atm\15-01-26 -B (P-4)\PROCESS\bouncing\';   %要处理的文件地址
for k=2:1:2
radii_left_all=[];
radii_right_all=[];
centers_all=[];
% errorradius=[];
We_all=[];
B_all=[];
relative_velocity_all=[];
velocity_left=[];
velocity_right=[];
real_diameter_all=[];
dirname=['time' num2str(k)];
files = dir(fullfile(path,dirname,'\add1\','*.tif')); 
lengthFiles = length(files);
for i = 1:lengthFiles
    Img_before = imread(strcat(path,dirname,'\add1\',files(i+gap).name));
    Img = Img_before(Highbegin:cropHeight, Widthbegin:cropWidth);  %对图片进行裁剪
    Img1 = bwareaopen(Img,500,8);   %先消除液滴对焦产生的小白点
    Img2 = imcomplement(Img1);   %将图像进行色彩反转（黑白颠倒）
    Img3 = bwareaopen(Img2,1000,8); %消除其他区域的小白点
    figure(k),imshow(Img3);
    [B,L] = bwboundaries(Img3,'holes');   %寻找图片中的连通域个数
    if length(B)==1   %当液滴发生碰撞时就只有一个连通域
        break
    end
end
number(k,:)=i-1;
if number(k,:)>4
    interval=4;
else
    interval=number(k,:)-1;
end
for i=1:number(k)
    Img_origin_before_crop = imread(strcat(path,dirname,'\add1\',files(i+gap).name));   %使用新的图片
    Img_origin = Img_origin_before_crop(Highbegin:cropHeight, Widthbegin:cropWidth);  %对图片进行裁剪
    Img1_1 = bwareaopen(Img_origin,500,8);   %先消除液滴对焦产生的小白点
    Img2_1 = imcomplement(Img1_1);   %将图像进行色彩反转（黑白颠倒）
    Img3_1 = bwareaopen(Img2_1,800, 8); %消除其他区域的小白点
    Img4_1 = imcomplement(Img3_1);   %将图像再次进行色彩反转（黑白颠倒）
    [centers, radii,metric] = imfindcircles(Img4_1,[25 30],'ObjectPolarity','dark','Sensitivity',0.96); %查找液滴的质心与半径
    centers_ascend=sortrows(centers,1); %液滴质心坐标排序，按照x轴从小到大的顺序进行排序
    combination=[centers,radii]; %将液滴坐标和粒径信息结合
    radii_ascend=sortrows(combination,1); %液滴粒径信息排序，按照x轴从小到大的顺序
    radii_left_all(i)=radii_ascend(1,3); %左侧液滴粒径信息统计
    radii_right_all(i)=radii_ascend(2,3); %右侧液滴粒径信息统计
    if i==number(k)
    radii_left_average=mean(radii_left_all); %左侧液滴求平均
    radii_right_average=mean(radii_right_all); %右侧液滴求平均
    bigradius=max(radii_left_average,radii_right_average); %寻找左右两个液滴中较大的一个
    dradius=abs(radii_left_average-radii_right_average); %计算左右两个液滴的粒径差值
    errorradius(k)=dradius/bigradius; %计算相对差值
    end
    imge_diameter=sum(radii); %认为两侧液滴大小相同，因为已经通过select程序进行了筛选
    real_diameter=imge_diameter*factor; %实际的液滴大小
    set(gca,'YDir','reverse');        %将y轴方向设置为反向(从上到下递增)。
    viscircles(centers_ascend, radii,'EdgeColor','b');   %在坐标图上画出识别的圆
    centers_all{i}=centers_ascend;   %用于存储每一帧的液滴圆心信息
    real_diameter_all(i)=real_diameter;   %液滴实际尺寸
    plot(centers_ascend(1,1),centers_ascend(1,2),'*');   %用于画出液滴运行轨迹
    hold on
    plot(centers_ascend(2,1),centers_ascend(2,2),'*');
    axis equal;   %设置坐标轴的间距相等
end
for n=number(k)-1:-1:number(k)-interval
    left=centers_all{1,number(k)}(1,:)-centers_all{1,n}(1,:); %左侧液滴质心向量信息 求解是以最后一帧为基准
    right=centers_all{1,number(k)}(2,:)-centers_all{1,n}(2,:); %右侧液滴质心向量信息
    left_mold=norm(left); %左侧液滴运动的像素距离 左侧向量的模
    right_mold=norm(right); %右侧液滴运动的像素距离 右侧向量的模
    left_right=dot(left,right); %左右两个向量的点乘
    alpha=acos(left_right/(left_mold*right_mold)); %获得两个液滴运动轨迹的夹角
    velocity_left=factor*left_mold/((number(k)-n)*t); %左侧两个液滴的实际速度
    velocity_left_all(number(k)-n,:)=velocity_left;
    velocity_left_average=mean(velocity_left_all);
    velocity_right=factor*right_mold/((number(k)-n)*t); %右侧两个液滴的实际速度
    velocity_right_all(number(k)-n,:)=velocity_right;
    velocity_right_average=mean(velocity_right_all);
    relative_velocity=sqrt(velocity_left^2+velocity_right^2-2*velocity_left*velocity_right*cos(alpha)); %两个液滴的相对速度
    relative_velocity_all(number(k)-n,:)=relative_velocity;
    relative_velocity_average=mean(relative_velocity_all);
    We=Rho*sum(real_diameter_all)*relative_velocity^2/(sigma*length(real_diameter_all)); %液滴碰撞韦伯数的计算
    We_all(number(k)-n,:)=We;
    We_average=mean(We_all);%5个时间步长求平均
    % 下面求碰撞参数
    time1=centers_all{n}(1,:)-centers_all{n}(2,:); %1时刻左右两个液滴连心线的位置向量
    time1_distance=norm(time1); %1时刻左右两个液滴连心线的像素距离
    real_time1_distance=time1_distance*factor; %1时刻左右两个液滴连心线的实际距离
    time1_base=time1/time1_distance; %1时刻左右两个液滴连心线方向的基向量
    relative_position_base=(left-right)/norm(left-right); %相对速度的方向基向量    
    gamma=acos(dot(time1_base,relative_position_base)/(norm(relative_position_base)*norm(time1_base))); %相对速度方向与连心线方向之间的夹角
    B=(real_time1_distance*abs(sin(gamma)))/real_diameter; %液滴碰撞参数的计算
    B_all(number(k)-n,:)=B; %将碰撞参数写出
    B_average=mean(B_all);%5个时间步长求平均
    average_diameter=mean(real_diameter_all);
end
name_all{k}=dirname;
We_final(k,:)=We_average;
B_final(k,:)=B_average;
D_final(k,:)=average_diameter;
velocity_left_final(k,:)=velocity_left_average;
velocity_right_final(k,:)=velocity_right_average;
relative_velocity_final(k,:)=relative_velocity_average;
gamma_final(k,:)=gamma;
end
excelname='We-B-7-thesis';
% % 在xlswrite之前加入此段代码
% try
%     excelObj = actxGetRunningServer('Excel.Application');
%     excelObj.Quit();
%     delete(excelObj);
% catch
% end
% 
% % 系统级清理（Windows系统）
% system('taskkill /F /IM EXCEL.EXE');
xlswrite(strcat(path,excelname),name_all',1,'A2');
xlswrite(strcat(path,excelname),We_final,1,'B2');      
xlswrite(strcat(path,excelname),B_final,1,'C2'); 
xlswrite(strcat(path,excelname),D_final,1,'D2');
xlswrite(strcat(path,excelname),velocity_left_final,1,'E2');
xlswrite(strcat(path,excelname),velocity_right_final,1,'F2');
xlswrite(strcat(path,excelname),relative_velocity_final,1,'G2');
xlswrite(strcat(path,excelname),gamma_final,1,'H2');
xlswrite(strcat(path,excelname),errorradius',1,'I2'); 
% fclose(strcat(path,'We-B-2'));
