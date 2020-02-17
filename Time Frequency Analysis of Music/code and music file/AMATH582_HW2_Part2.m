 %% Read in Music and Plot in Time and Freq Domains
 clear all; close all; clc
 
 % load piano music 
 tr_piano=16;  % record time in seconds
 p=audioread('music1.wav'); Fs_p=length(p)/tr_piano;
 p=p';
 L_p=length(p)/Fs_p; n_p=length(p);
 ks_p=(1/L_p)*[-n_p/2:(n_p/2)-1]; %frequency domain
 t_p=(1:length(p))/Fs_p; %time domain
 ftp=fft(p); % fourier transform of piano music 
 ftp=abs(fftshift(ftp));
 
%load recorder music
 tr_rec=14;  % record time in seconds
 r=audioread('music2.wav'); Fs_r=length(r)/tr_rec;
 r=r';
 L_r=length(r)/Fs_r; n_r=length(r);
 ks_r=(1/L_r)*[-n_r/2:(n_r/2)-1]; 
 t_r=(1:length(r))/Fs_r;
 ftr=fft(r); % fourier transform of recorder music (overall)
 ftr=abs(fftshift(ftr));
 
%plot overall frequencies and sound waves
 figure(1)
 
 subplot(2,2,1)
 plot(t_p,p);
 xlabel('Time (sec)'); ylabel('Amplitude');
 title('Piano Sound Waves');  
 axis([0,16,0,1])
 
 subplot(2,2,2)
 plot(ks_p,ftp);
 xlabel('Frequency (Hz)'); ylabel('|fft(p)|');
 title('Piano Frequencies');  
 axis([0,2000,0,6000])
 
 subplot(2,2,3) 
 plot(t_r,r,'Color','#E68A00');
 xlabel('Time (sec)'); ylabel('Amplitude');
 title('Recorder Sound Waves');
 axis([0,16,0,1])
 
 subplot(2,2,4)
 plot(ks_r,ftr,'Color','#E68A00');
 xlabel('Frequency (Hz)'); ylabel('|fft(r)|');
 title('Recorder Frequencies');  
 axis([0,2000,0,6000])
 
 sgtitle("'Mary had a little lamb' sound waves and frequencies on the piano and recorder")

 %% Identify the Three Primary Frequencies for Each Instrument

%piano 
p_note1_max=max(ftp(find(ks_p>240 & ks_p<270)));
p_note2_max=max(ftp(find(ks_p>280 & ks_p<300)));
p_note3_max=max(ftp(find(ks_p>300 & ks_p<350)));
p_note1_freq=ks_p(find(ftp == p_note1_max ,1,'last'));
p_note2_freq=ks_p(find(ftp == p_note2_max ,1,'last'));
p_note3_freq=ks_p(find(ftp == p_note3_max ,1,'last'));
%recorder
r_note1_max = max(ftr(find(ks_r>800 & ks_r<850)));
r_note2_max = max(ftr(find(ks_r>890 & ks_r<950)));
r_note3_max = max(ftr(find(ks_r>1000 & ks_r<1100)));
r_note1_freq=ks_r(find(ftr == r_note1_max,1,'last'));
r_note2_freq=ks_r(find(ftr == r_note2_max,1,'last'));
r_note3_freq=ks_r(find(ftr == r_note3_max,1,'last'));
%vector of relevant frequencies for plot annotations
note_freq =[p_note1_freq p_note2_freq p_note3_freq r_note1_freq r_note2_freq r_note3_freq];
note_max = [p_note1_max p_note2_max p_note3_max r_note1_max r_note2_max r_note3_max];
note_txt=strcat(" ",string(round(note_freq))',repmat(' Hz',6,1));

figure(2)
plot(ks_p,ftp,'Linewidth',[2],'Color','#019AFF'); hold on 
plot(ks_r,ftr,'Linewidth',[2], 'Color','#E68A00' ); hold on
axis([150,1150,0,6000]) ;
text(note_freq,note_max,note_txt,'Color','k','FontSize',12);
legend('Piano','Recorder');
xlabel('Frequency (Hz)');
ylabel('|fft|');
title("Primary Frequencies of the Piano and Recorder");
 %% Spectrogram Data of Piano and Recorder
  
%Samples song at every .1 unit of time 
width=20;
t_center_p=[0:.1:L_p];
t_center_r=[0:.1:L_r];
spec_p=[];
spec_r=[];

%piano spectrogram data
for i=1:length(t_center_p)    
    g=exp(-width*(t_p-t_center_p(i)).^2);   
    p_filt = g.*p;
    p_filt_transform = fft(p_filt);
    pt_plot = fftshift(abs(p_filt_transform)); 
    spec_p=[spec_p;pt_plot]; 
end
%recorder spectrogram data
for i=1:length(t_center_r)    
    g=exp(-width*(t_r-t_center_r(i)).^2);   
    r_filt = g.*r;
    r_filt_transform = fft(r_filt);
    rt_plot = fftshift(abs(r_filt_transform)); 
    spec_r=[spec_r;rt_plot]; 
end

%remove negative frequencies
spec_p(:,1:n_p/2-1)=[];
ks_p(1:n_p/2-1)=[];

spec_r(:,1:n_r/2-1)=[];
ks_r(1:n_r/2-1)=[];

%% Display Spectrograms

figure(3)
subplot(1,2,1)
pcolor(t_center_p,ks_p,spec_p.'), 
shading interp ;
set(gca,'Ylim',[200 550],'Fontsize',[12]) ;
colormap(hot);
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
title("Piano Spectrogram");

subplot(1,2,2)
pcolor(t_center_r,ks_r,spec_r.'), 
shading interp ;
set(gca,'Ylim',[200 1200],'Fontsize',[12]) ;
colormap(hot);
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
title("Recorder Spectrogram");

%% Display Spectrograms Zoomed in with Notes
px_e = [.7 2.7 3.2 3.8 6.3 6.9 7.4 8.2 10.1 10.5 11 11.4 12.9];
px_d = [1.2 2.3 4.5 5.1 5.7 8.6 9.6 11.9 12.4 13.3];
px_c = [1.8 9.1 13.8];

py_e = repelem(330,length(px_e));
py_d= repelem(297,length(px_d));
py_c= repelem(266,length(px_c));

figure(4)
subplot(2,1,1)
pcolor(t_center_p,ks_p,spec_p.'), 
shading interp 
set(gca,'Ylim',[200 350],'Fontsize',[12]) 
colormap(hot)
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
title("Piano Spectrogram with Notes")
text(px_e,py_e,"E",'Color','g','FontSize',13)
text(px_d,py_d,"D",'Color','g','FontSize',13)
text(px_c,py_c,"C",'Color','g','FontSize',13)

% recorder
rx_e = [0 1.8 2.3 2.9 5.4 6 6.4 7.2 9 9.5 10 10.5 11.9];
rx_d = [.4 1.4 3.6 4.1 4.7 7.7 8.6 10.8 11.4 12.3];
rx_c = [.9 8.2 13];

ry_e = repelem(1057,length(rx_e));
ry_d= repelem(939,length(rx_d));
ry_c= repelem(839,length(rx_c));

subplot(2,1,2)
pcolor(t_center_r,ks_r,spec_r.'), 
shading interp 
set(gca,'Ylim',[750 1100],'Fontsize',[12]) 
colormap(hot)
xlabel('Time (sec)'); ylabel('Frequency (Hz)');
title("Recorder Spectrogram with Notes")
text(rx_e,ry_e,"B",'Color','g','FontSize',13)
text(rx_d,ry_d,"A",'Color','g','FontSize',13)
text(rx_c,ry_c,"G",'Color','g','FontSize',13)
 
