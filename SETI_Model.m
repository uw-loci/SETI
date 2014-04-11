%SETI Model

% 1. Create an object
% 2. Create a PSF
% 3. Simulate SETI forward problem
% 4. Test reverse problem methods

% Jeremy Bredfeldt - Morgridge Institutes for Research/LOCI
% Sept 2013

clc;
clear all;
%close all;

ppm = 1.5; %pixels per micron
spc_size = 120; %microns, size of the space
nums = round(spc_size*ppm); %number of samples
nums2 = round(nums/2);

%% Create the object
% a = 10; %diameter in one dimension in microns
% b = 10; %diameter in the other dimension in microns

%create vectors for space
[xr, yr, zr] = meshgrid(-nums2:nums2);
xr = xr/ppm;
yr = yr/ppm;
zr = zr/ppm;

%create a cube object
x1 = -10; x2 = 10; %microns
y1 = -10; y2 = 10; %microns
z1 = zr(1); z2 = zr(1)+15; %microns

r = xr > x1 & xr < x2 & yr > y1 & yr < y2 & zr > z1 & zr < z2;
figure(1); clf;
axis square;
imagesc(squeeze(r(:,90,:))');

%return;
% %r is the object (cylinder) volume (3D matrix)
% %r is reflectivity of each voxel at a given wavelength
% r = (((xr)/a).^2 + ...
%     ((zr+5)/b).^2);
% rlim = r > 1;
% rlim2 = r > 0.1;
% % r = r+.1;
% % r = 1/r;
% %reflectivity of surrounding material is high
% %reflectivity of chromophore inside vessel is low
% %r(rlim) = .001; %outsize vessel (clear resin)
% r(rlim) = .9; %outsize vessel (opaque resin)
% r(~rlim) = .1; %inside vessel (tissue and chromophore)
% 
% %make an attenuation matrix, then factor attenuation into the final output image
% %attenuation of surrounding material is high
% %attenuation of chromophore is high, attenuation of the non-stained tissue may be low
% mua = r;
% %mua(rlim) = 0.001; %outside vessel (units = 1/pixels) (clear resin)
% mua(rlim) = 2; %outside vessel (units = 1/pixels) (opaque resin)
% mua(~rlim) = .1; %outer vessel (units = 1/pixels) (relatively clear tissue)
% mua(~rlim2) = 10; %inner vessel (Chromophore)


%% Create the PSF
psfspc = 20; %microns (space)
psfspc2 = round(psfspc/2);
psfspcz = 60; %microns
psfspcz2 = round(psfspcz/2);
%gw = 10; %Gaussian width
%gh = 15; %Gaussian height
[xp, yp, zp] = meshgrid(-psfspc2:psfspc2,-psfspc2:psfspc2,-psfspcz2:psfspcz2);
xp = xp/ppm;
yp = yp/ppm;
zp = zp/ppm;
% psf = exp(-( (((xp-psfw2).^2)/(2*gw^2)) + ...
%              (((yp-psfw2).^2)/(2*gw^2)) + ...
%              (((zp).^2)/(2*gh^2)) ) );

%2 parameter PSF model:
n0 = 1.5;
n1 = .02;
psf = exp( -((xp).^2 + (yp).^2) ./ ...
           (2*(n0 + n1*abs(zp+psfspcz2)).^2)) ...
           ./(2*pi*(n0 + n1*abs(zp+psfspcz2)).^2);
       
psf = psf/(max(max(max(psf))));
figure(2); clf;
imagesc(squeeze(psf(:,psfspc2,:))');
title('PSF');
colorbar;

return;
% figure(25);
% slice(xp,yp,zp,psf,[0],[],[0]);

%% Forward Image Problem         
%Now convolve the top of the object and the top half of the psf, repeat after removing a layer
%This tries to factor in attenuation, so it is not a pure convolution, but more of a convolution/superposition operation
cout = zeros(size(r,1),size(r,2),size(psf,3));
iout = zeros(size(r,1),size(r,2),(size(r,3)-size(psf,3)));
for i = 1:(size(r,3)-size(psf,3))
    sec = r(:,:,i:i+size(psf,3)-1); %current section and psf height number of sections below
    atten = mua(:,:,i:i+size(psf,3)-1);
    for j = 1:size(psf,3)
        %factor in attenuation
        if j > 1
            sec(:,:,j) = sec(:,:,j).*exp(-sum(atten(:,:,1:(j-1)),3));            
        end                
        %convolve each layer
        temp = conv2(sec(:,:,j),psf(:,:,j),'same');
        %figure(6); imagesc(temp); colorbar;
        cout(:,:,j) = temp;
    end
    %integrate along z-direction, to the depth of the psf
    temp = mean(cout,3);
    %figure(7); imagesc(temp); colorbar; title(sprintf('section %d',i));
    iout(:,:,i) = temp; %this is the image
end
figure(4);
subplot(1,2,1); imagesc(squeeze(iout(:,nums2,:))'); axis square; colorbar;
subplot(1,2,2); imagesc(squeeze(iout(nums2,:,:))'); axis square; colorbar;
title('Result of forward problem');

%% Simple Reconstruction
% dif = zeros(size(iout));
% for i = 1:size(iout,3)-1
%     dif(:,:,i) = iout(:,:,i) - iout(:,:,i+1);
% end

%create 3D deriv filter kernel
sobx = zeros(3,3,3);
soby = zeros(3,3,3);
sobz = zeros(3,3,3);

sobz(:,:,1) = [-1 -2 -1; 
              -2 -4 -2; 
              -1 -2 -1];         
sobz(:,:,3) = [1 2 1; 
              2 4 2; 
              1 2 1];          
sobx(:,1,:) = sobz(:,:,1);
sobx(:,3,:) = sobz(:,:,3);

soby(1,:,:) = sobz(:,:,1);
soby(3,:,:) = sobz(:,:,3);

%apply derivative filter
difx = convn(iout,sobx,'same');
dify = convn(iout,soby,'same');
difz = convn(iout,sobz,'same');
%compute gradient magnitude
dif = sqrt(difx.^2 + dify.^2 + difz.^2);

figure(6); clf;
imagesc(squeeze(dif(nums2,:,:))'); axis square; colorbar;
caxis([0 60]);
title('Result of the derivative filter');

%filter gradient magnitude with a symmetric gaussian
gw = 2;
[xg, yg, zg] = meshgrid(-5:5);
gf = exp(-( (((xg).^2)/(2*gw^2)) + ...
             (((yg).^2)/(2*gw^2)) + ...
             (((zg).^2)/(2*gw^2)) ) );
gf = gf/sum(sum(sum(gf)));         
fdif = convn(dif,gf,'same');

figure(7); clf;
imagesc(squeeze(fdif(nums2,:,:))'); axis square; colorbar;
title('Low Pass Filtered result');

%% Iterative Reconstruction
[d_c_im, dpsf] = deconvblind(iout,psf);
%[d_c_im] = deconvlucy(iout,psf);
%[d_c_im] = deconvwnr(iout,psf,5);
figure(9); clf;
imagesc(squeeze(d_c_im(nums2,:,:))'); axis square; colorbar;
title('Deconvolution Result');

%%


% figure(2);
% imagesc(squeeze(r(:,w2,:))');
% title('Refl');
% slice(xr,yr,zr,r,[h2],[],[h2]);
% xlim([0 spc_size]);
% ylim([0 spc_size]);
% zlim([0 spc_size]);


%Plot the original attenuation
figure(3);
subplot(1,2,1); imagesc(squeeze(mua(:,nums2,1:(nums-size(psf,3))))'); axis square; colorbar;
subplot(1,2,2); imagesc(squeeze(mua(nums2,:,1:(nums-size(psf,3))))'); axis square; colorbar;
title('Original object attenuation');
%title('Image');
% slice(xr,yr,zr,iout,[h2],[],[h2]);
% xlim([0 spc_size]);
% ylim([0 spc_size]);
% zlim([0 spc_size]);

figure(5);
plot(1:(nums-size(psf,3)+1),squeeze(iout(nums2,nums2,:)));
hold all;
plot(1:(nums-size(psf,3)),squeeze(mua(nums2,nums2,1:(nums-size(psf,3)))));
hold off;
legend('fwrd result','original atten');
title('Result of the forward problem (1D)');