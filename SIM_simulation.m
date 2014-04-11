%Simulate confocal effect created by aperture coding/structured
%illumination.
clear all;
%close all;
clc;

%Object (a bunch of delta functions)
xd = 64; yd = xd; zd = xd;
obj = round(0.50003*rand(xd,yd,zd));

%z project object
obj_z = max(obj,[],3);
obj_x = squeeze(max(obj,[],1));



%PSF
[xp, yp, zp, rp] = ndgrid(-20:2:20,-20:2:20,-60:2:60,0:0.1:1);
NA = 0.5;
bes = besselj(0,NA*sqrt((xp.^2 + yp.^2)).*rp);
temp = sum(bes.*exp(-0.5*i*NA^2*rp.*zp).*rp,4);
psf = abs(temp);
zproj = squeeze(max(psf,[],3));
xproj = squeeze(max(psf,[],1))';
figure(1); 
subplot(2,1,2); imagesc(zproj); title('zproj'); axis square;
subplot(2,1,1); imagesc(xproj); title('xproj'); axis square;
%%
%Create an image without SIM
imN = convn(obj,psf,'same');
imN_z = max(imN,[],3); %z projection
imN_z = imN(:,:,1);
imN_x = squeeze(max(imN,[],1));

figure(2); 
subplot(2,2,1); imagesc(obj_x'); axis square;
subplot(2,2,3); imagesc(obj_z); axis square;
subplot(2,2,2); imagesc(imN_x'); axis square;
subplot(2,2,4); imagesc(imN_z); axis square;

%%
%Create an image with SIM and compare
maskon = ones(8,8);
maskoff = zeros(8,8);
maskp = [maskon maskoff;maskoff maskon];
mask2D = repmat(maskp,4,4);
belowMask = zeros(xd,yd,zd-1);
mask3D = cat(3,mask2D,belowMask);
maskIm = convn(mask3D,psf,'same');
imM_z = max(maskIm,[],3);
imM_x = squeeze(maskIm(36,:,:)); %squeeze(max(maskIm,[],1));
figure(3);
subplot(2,1,1); imagesc(imM_x'); axis square; colorbar;
subplot(2,1,2); imagesc(imM_z); axis square; colorbar;



%First illuminate the sample