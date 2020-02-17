%% Load in Handel Music and Set up Time and Frequency Domains
clear all; close all; clc 

load handel
v = y'/2;
%Set up domains
L=length(v)/Fs; n=length(v);
t2=linspace(0,L,n+1); t=t2(1:n); %time domain
ks=(1/L)*[-(n-1)/2:(n-1)/2];   %freq domain

%% View at Gausian Filter Options
figure(1)
width = [.5, 2, 50]; %Gaussian width options
t_center=3;
for i=1:length(width) 
    g=exp(-width(i)*(t-t_center).^2); %Gausian filter centered at t=3
    v_filt = g.*v;
    v_filt_transform = fft(v_filt);
    vt_plot = fftshift(abs(v_filt_transform));
    
    subplot(length(width),3,3*i-2) %plot signal with Gaussian on top
    p1=plot(t,v); hold on 
    p2=plot(t,g,'Linewidth',[2]);
    legend([p2],sprintf('Width = %.1f', width(i)));
    axis([0 9 0 1.01]);
    xlabel('Time (sec)');
    ylabel('Amplitude');
    
    subplot(length(width),3,3*i-1); %plot filtered signal
    plot(t,v_filt);
    xlabel('Time (sec)');
    ylabel('Amplitude');
    axis([0 9 0 .5])
    
    subplot(length(width),3,3*i); %plot frequency content of filtered signal
    plot(ks,vt_plot);
    xlabel('Frequency (Hz)');
    ylabel('|fft(Amplitude)|');
    axis([0 4000 0 200]);
end

sgtitle('Gaussian Filters of Various Widths');

%% Spectrograms with Different Gaussian Filter Widths

figure(2)
width = [1,10,50];
for j=1:length(width)
    t_center=[1:.1:L];
    spec_gw=[];
    for i=1:length(t_center)
        g=exp(-width(j)*(t-t_center(i)).^2);
        v_filt = g.*v;
        v_filt_transform = fft(v_filt);
        vt_plot = fftshift(abs(v_filt_transform)); 
        spec_gw=[spec_gw;vt_plot];   
    end 
   
subplot(1,length(width),j)    
pcolor(t_center,ks,spec_gw.'), 
shading interp 
set(gca,'Ylim',[0 2000],'Fontsize',[12]) 
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title(strcat("Width ",num2str(width(j))))
colormap(hot)    
end

sgtitle("Gaussian Filter Spectrogram of Various Widths")


%% Hold Gaussian Filter Width Constant to Evaluate Over/Under sampling effects

width = 20;

% Low sampling
t_center_1=[1:.5:L];
spec_g_us=[];
for i=1:length(t_center_1)
    g=.4*exp(-width*(t-t_center_1(i)).^2);
    v_filt = g.*v;
    v_filt_transform = fft(v_filt);
    vt_plot = fftshift(abs(v_filt_transform)); 
    spec_g_us=[spec_g_us;vt_plot];    
end

% High sampling
t_center=[1:.01:L];
spec_g_os=[];
for i=1:length(t_center)
    g=.4*exp(-width*(t-t_center(i)).^2);
    v_filt = g.*v;
    v_filt_transform = fft(v_filt);
    vt_plot = fftshift(abs(v_filt_transform)); 
    spec_g_os=[spec_g_os;vt_plot];       
end

%Display Spectrogram
figure(3)

subplot(1,2,1)
pcolor(t_center,ks,spec_g_os.'), 
shading interp 
set(gca,'Ylim',[0 2000],'Fontsize',[12]) 
colormap(hot)
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title("high rate (.01)")

subplot(1,2,2)
pcolor(t_center_1,ks,spec_g_us.'), 
shading interp 
set(gca,'Ylim',[0 2000],'Fontsize',[12]) 
colormap(hot)
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title("low rate (.5)")

sgtitle("High and Low Sampling Rates with Fixed Gaussian Filter Width")
%% Compare Different Filter Shapes with Similar Widths
g_width = 25;
mh_width = 55;
sf_width = 4013;
g_mh_t_center = 3;
g=exp(-g_width*(t-g_mh_t_center).^2); %Gausian filter centered at t=3
mh=(1-mh_width.*(t-g_mh_t_center).^2).*exp((-mh_width.*(t-g_mh_t_center).^2)./2); 
mask=ones(1,sf_width);
sf=zeros(1,n);
tstep=22371;
sf(1+tstep:sf_width+tstep)=mask; 


figure(4)
%Gaussian filter plots
subplot(3,2,1)
plot(t,v), hold on
plot(t,g,'Linewidth',[2])
axis([2,4,-.5,1])
xlabel('Time (sec)');
ylabel('Amplitude');

subplot(3,2,2)
plot(t,g.*v), hold on
axis([2,4,-.5,1])
xlabel('Time (sec)');
ylabel('Amplitude');

%Mexican Hat filter plots
subplot(3,2,3)
plot(t,v), hold on
plot(t,mh,'Linewidth',[2])
axis([2,4,-.5,1])
xlabel('Time (sec)');
ylabel('Amplitude');

subplot(3,2,4)
plot(t,mh.*v), hold on
axis([2,4,-.5,1])
xlabel('Time (sec)');
ylabel('Amplitude');

%Shannon filter plots
subplot(3,2,5)
plot(t,v), hold on
plot(t,sf,'Linewidth',[2])
axis([2,4,-.5,1])
xlabel('Time (sec)');
ylabel('Amplitude');

subplot(3,2,6)
plot(t,sf.*v), hold on
axis([2,4,-.5,1])
xlabel('Time (sec)');
ylabel('Amplitude');

sgtitle("Compare Gaussian, Mexian Hat, and Shannon Filters with Similar Widths")

%% Spectrograms of different filter shapes with same width and sampling rate
g_width = 25;
mh_width = 55;
sf_width = 4013;
t_center = linspace(0,L,80);
    
steps=length(t_center);
width_approx=sf_width;
tstep_mult=round((73113-width_approx)/steps);
calc_width=73113-(tstep_mult*steps);
sf=zeros(1,n); 
mask=ones(1,calc_width);

spec_sf=[];
spec_g=[];
spec_mh=[];    

for i=1:length(t_center)
    g=exp(-g_width*(t-t_center(i)).^2);
    v_filt_g = g.*v;
    v_filt_g_transform = fft(v_filt_g);
    vt_plot_g = fftshift(abs(v_filt_g_transform)); 
    spec_g=[spec_g;vt_plot_g]; 

    mh=(1-mh_width.*(t-t_center(i)).^2).*exp((-mh_width.*(t-t_center(i)).^2)./2); 
    v_filt_mh = mh.*v;
    v_filt_mh_transform = fft(v_filt_mh);
    vt_plot_mh = fftshift(abs(v_filt_mh_transform)); 
    spec_mh=[spec_mh;vt_plot];
    
    sf=zeros(1,n);
    tstep=(i-1)*tstep_mult;
    sf(1+tstep:calc_width+tstep)=0.41.*mask; 
    v_filt_sf = sf.*v;
    v_filt_sf_transform = fft(v_filt_sf);
    vt_plot = fftshift(abs(v_filt_sf_transform)); 
    spec_sf=[spec_sf;vt_plot]; 
end 

figure(5)

subplot(1,3,1)
pcolor(t_center,ks,spec_g.'), 
shading interp 
set(gca,'Ylim',[0 1500],'Fontsize',[12]) 
colormap(hot)
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title("Gaussian Filter")

subplot(1,3,2)
pcolor(t_center,ks,spec_mh.'), 
shading interp 
set(gca,'Ylim',[0 1500],'Fontsize',[12]) 
colormap(hot)
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title("Mexican Hat Filter")


subplot(1,3,3)
pcolor(t_center,ks,spec_sf.'), 
shading interp 
set(gca,'Ylim',[0 1500],'Fontsize',[12]) 
colormap(hot)
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title("Step Filter")


