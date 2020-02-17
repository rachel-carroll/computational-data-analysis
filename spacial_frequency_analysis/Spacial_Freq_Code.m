
%% Load Data and Set Up Domains 
clear all; close all; clc;
load Testdata
L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k); % frequency components of FFT
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

%% Average Data to Reduce Noise
%Averages 
Utave=zeros(n,n,n); 
for j=1:20 %loop through the 20 measurments
    Un(:,:,:)=reshape(Undata(j,:),n,n,n); %put into 64x64x64 format
    Utn = fftn(Un,[n,n,n]);%apply fourier transform to bring to frequency domain
    Utave=Utave+Utn; %add each measurment
end
Utave=fftshift(Utave)/20; %shift transformed data and take average

%Plot Average Transform
close all
figure(1)
isosurface(Kx,Ky,Kz,abs(Utave)/max(abs(Utave(:))),.7)
axis([-4 4 -4 4 -4 4]), grid on, drawnow

%% Filter the Data
% From the plot the max frequency should be around (2,-1.0)

%find loacation of max freq
[max_freq,arg_freq]=max(abs(Utave(:)));
[i1,i2,i3]=ind2sub(size(Utave),arg_freq);
x_filt=Kx(i1,i2,i3);
y_filt=Ky(i1,i2,i3);
z_filt=Kz(i1,i2,i3);

filt = exp(-3*((Kx-x_filt).^2+(Ky-y_filt).^2+(Kz-z_filt).^2));

%%Add Filter to Plot
isosurface(Kx,Ky,Kz,filt,.7)
alpha(.3)

%% Find Location of Marble
% Sanity check to make sure there is a clear location of the marble at each
% measurment. Just using first measurment (j=1)

j=1;
Un(:,:,:)=reshape(Undata(j,:),n,n,n);
Utn = fftn(Un,[n,n,n]);
Utn_shift = fftshift(Utn);  
 
unft=filt.*Utn_shift; 
unf=ifftn(unft);

figure(2)
%close all
isosurface(X,Y,Z,abs(unf)/max(abs(unf(:))),.4)
axis([-20 20 -20 20 -20 20])
grid on, drawnow

%% Plot Marble Trajectory

x=[]; y=[]; z=[];
for j=1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Utn = fftn(Un,[n,n,n]);
    Utn_shift = fftshift(Utn);   
    unft=filt.*Utn_shift; 
    unf=ifftn(unft);
    [val,location]=max(abs(unf(:)));
    [x_1,y_1,z_1]=ind2sub(size(unf),location);
    x=[x,X(x_1,y_1,z_1)];
    y=[y,Y(x_1,y_1,z_1)];
    z=[z,Z(x_1,y_1,z_1)];
end


plot3(x,y,z,'-o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
grid on
axis([-11 11 -6 6 -10 15])
title("Trajectory of the Marble")
