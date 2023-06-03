clear
clc

%% 模拟断层数据 探测器位置
scan_mode = '1_parallel';
data_type = 'Section';
[image, geo, Points] = CreateData(scan_mode, data_type);
image = image(:, :, 1);
% Points = squeeze(Points(1:4, 2));

% % 绘制图像
% figure
% slice(image, [50], [], [100 30]);
% shading flat
% view(-20, 25)
% colormap jet
% caxis([0, 10])

% 绘制探测器位置
% p = zeros(geo.nx, geo.ny, geo.nz);
% for ii = 1:size(Points, 1)
%     for jj = 1:size(Points, 2)
%         for kk = 1:size(Points, 3)
%             p(Points(ii, jj, 1), Points(ii, jj, 2), Points(ii, jj, 3)) = 1;
%         end
%     end
% end
% as(p)

%% 仿真投影数据
disp 'Starting Data Simulation !'
t = tic;
data = Forward2D(Points, image, geo);
toc(t);
disp 'Projection Data Complete !'


% %% TFM 全聚焦重建

disp 'Starting Total Focusing Method (TFM) !'
t = tic;
recon = TFD2D(Points, data, geo);
toc(t);
imtool(recon, []);
disp 'Recon Complete !'
% 
% 
% %% SIRT 迭代重建
% IR_times = 10;
% result = zeros(size(repmat(img, [1, 1, 1, 1 + IR_times])));
% result(:, :, :, 1) = img;
% 
% Smooth_Kernel = fspecial("average", [5, 5]);
% 
% % figure
% mse = linspace(0, 0, IR_times);
% 
% for irt = 1:IR_times
%     disp(' ');
%     disp([num2str(irt), ' / ', num2str(IR_times)]);
%     disp("IR: Projection .");
%     d_proj = Project3D(source, reciver, img, geo);
%     
%     d_proj = proj - d_proj;
%     
%     disp("IR: BackProjection .");
%     d_img = BackProject3D(geo, d_proj, source, reciver);
%     
%     img = img + d_img * 0.5;
%     img = imfilter(img, Smooth_Kernel);
% %     a = uint8(img * 255 / (max(img(:)) - min(img(:))));
% %     imshow(a,'Colormap',jet(255));
%     result(:, :, :, irt + 1) = img;
%     mse(irt) = mean(d_proj, 'all');
% end
% plot(mse)
% save('2_par.mat', 'result', 'mse', 'data');
% 
% plot(abs(squeeze(data(1, 1, :))))
% hold on
% plot(abs(squeeze(data(1, 2, :))))
% plot(abs(squeeze(data(1, 3, :))))
% plot(abs(squeeze(data(1, 4, :))))y9tttttttttttt
% plot(abs(squeeze(data(2, 1, :))))
% plot(abs(squeeze(data(2, 2, :))))
% plot(abs(squeeze(data(2, 3, :))))
% plot(abs(squeeze(data(2, 4, :))))
% plot(abs(squeeze(data(3, 1, :))))
% plot(abs(squeeze(data(3, 2, :))))
% plot(abs(squeeze(data(3, 3, :))))
% plot(abs(squeeze(data(3, 4, :))))
% plot(abs(squeeze(data(4, 1, :))))
% plot(abs(squeeze(data(4, 2, :))))
% plot(abs(squeeze(data(4, 3, :))))
% plot(abs(squeeze(data(4, 4, :))))

