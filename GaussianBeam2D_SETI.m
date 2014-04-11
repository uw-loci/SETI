
clear all;
%close all;
clc;

wL = 0.470; %wavelength in um
k = 2*pi/wL; %wavenumber
na = 0.2; %numerical aperture
bW = 0.6*wL/na; %beam waist in um
zr = pi*bW^2/wL;

%setup PSF space
srz = 1; %samples per micron
srr = 1; %sample per micron
ns = 256;
zs = ns/srz; %microns, zspace
rs = ns/srr; %microns, rspace
z = linspace(-zs, zs, ns);
r = linspace(-rs, rs, ns);
%srz = ns/zs; %sample rate
%srr = ns/rs; %sample rate
Z = linspace(-srz,srz,ns); %frequency linspace
R = linspace(-srr,srr,ns); %frequency linspace
[xg, zg] = meshgrid(r,z);
muT = 220*(1/10000); %1/microns
wz = bW*sqrt(1+(zg./zr).^2);

%normal psf
p = 1./((wz).^2).*exp(-(2.*xg.^2)./(wz.^2));

figure(1);
imagesc(r,z,p);
axis equal;
xlim([-rs rs]);
ylim([-zs zs]);
xlabel('microns');
ylabel('microns');
%colorbar;
colormap('Gray');
caxis([0 0.3]);
title('Widefield PSF');

P = fftshift(abs(fft2(p)));

figure(2);
imagesc(R,Z,P);
%colorbar;
colormap('Gray');
axis equal;
xlim([-srr srr]);
ylim([-srz srz]);
xlabel('1/micron');
ylabel('1/micron');
caxis([0 1.5]);
title('Widefield MTF');

%SETI psf
sp = 1./((wz).^2).*exp(-(2.*xg.^2)./(wz.^2));
fl = zg<=0;
fl2 = zg>-zs;

sp = sp.*fl.*fl2;

figure(3); %SETI PSF
imagesc(r,z,sp);
axis equal;
xlim([-rs rs]);
ylim([-zs zs]);
xlabel('microns');
ylabel('microns');
%colorbar;
colormap('Gray');
caxis([0 0.3]);
title('SETI PSF');

SP = fftshift(abs(fft2(sp)));

figure(4); %SETI MTF
imagesc(R,Z,SP);
colormap('Gray');
axis equal;
xlim([-srr srr]);
ylim([-srz srz]);
xlabel('1/micron');
ylabel('1/micron');
caxis([0 0.75]);
title('SETI MTF');
%colorbar;

%object
ozs = zs; %microns, object z space
ors = rs; %microns, object r space
onsz = srz*ozs; %object number of samples in z direction
onsr = srr*ors; %object number of samples in r direction
oz = linspace(-ozs,ozs,onsz);
or = linspace(-ors,ors,onsr);
rsph = rand(onsz,onsr);
beads = double(rsph>0.99) + 0.001*rand(onsz,onsr);

figure(5); %Object
kkern = [1 1 1 1; 1 1 1 1; 1 1 1 1; 1 1 1 1];
b2 = conv2(beads,kkern,'same'); %Filter so we can see every bead
imagesc(or,oz,b2);
colormap('Gray');
caxis([0 1]);
axis equal;
%colorbar;
xlim([-ors ors]);
ylim([-ozs ozs]);
xlabel('microns');
ylabel('microns');
title('Object');

%compute standard image
sti = conv2(beads,p,'same');
figure(6); %standard image
imagesc(or,oz,sti);
colormap('Gray');
axis equal;
colorbar;
%caxis([0 0.1]);
title('Widefield Image');

%compute SETI image
sei = conv2(beads,sp,'same');

%decimate to z-step size
% srzCut = 0.2; %microns per sample in z
% dr = srz/srzCut; %decimation rate in z-direction
% zd = round(1:dr:onsz);
% zdsp = linspace(-ozs, ozs, length(zd)); %for plotting
% sei = sei(zd,:); %decimate here
figure(7); %SETI image
imagesc(or,oz,sei);
colormap('Gray');
axis equal;
xlim([-ors ors]);
ylim([-ozs ozs]);
xlim([-30 30]);
ylim([-30 30]);
xlabel('microns');
ylabel('microns');
caxis([0 0.4]);
title('SETI Image');

%simple subtraction correction
sei2 = circshift(sei,-1);
fixsei = sei-sei2;
figure(8); %simple correction
imagesc(or,oz,fixsei);
colormap('Gray');
axis equal;
xlim([-30 30]);
ylim([-30 30]);
xlabel('microns');
ylabel('microns');
caxis([0 0.01]);
title('Simple Correction');
colorbar;

%blur then subtract
kern = ones(1,round(0.7*bW*srr));
%kern = exp(-((1:20)-10)./((10*bW*srr).^2));
sei3 = 1.2*(1/(sum(kern(:))))*conv2(sei2,kern,'same');
fixsei = sei-sei3;
figure(9); %simple correction
imagesc(or,oz,fixsei);
colormap('Gray');
axis equal;
xlim([-30 30]);
ylim([-30 30]);
xlabel('microns');
ylabel('microns');
caxis([0 0.01]);
title('Filtered Subtraction');
%colorbar;

%deconvolution correctoin
fixdec = fftshift(abs(ifft2(fft2(sp)./fft2(sei))));
figure(10);
imagesc(or,oz,fliplr(flipud(fixdec)));
colormap('Gray');
axis equal;
xlim([-ors ors]);
ylim([-ozs ozs]);
xlabel('microns');
ylabel('microns');
xlim([-30 30]);
ylim([-30 30]);
title('Deconvolution');
%caxis([.02 0.1]);
colorbar;