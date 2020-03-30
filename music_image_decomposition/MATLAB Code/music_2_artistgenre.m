%% Music Part 2: Artist Classification within the same Genre

clear all; close all; clc
%% Define Artist Song Files and Sample Locations
Snoop_files =["music_samples/07 Snoop D.O. Double G.m4a", "music_samples/18 Pass it Pass it.m4a"];
Snoop_sample_locs=[[35:5:90,110,115,135, 145, 150,120,125,130];
                  [40:5:99, 120:5:155]];
               
Dre_files =["music_samples/04 Still D.R.E..m4a","music_samples/07 Whats the Difference.m4a"];
Dre_sample_locs=[[20:5:55,80:5:115,150,160,170,175,180];
                 10:5:110];
            
Eminem_files =["music_samples/02 White America.mp3", "music_samples/13 Superman.m4a"];
Eminem_sample_locs=[40:6:155;
                    [50:6:103, 110   116   122, 135   141   147   153   159, 170, 175, 180]];

%% Song Sample Matrices

spec_width = 100;
time_inc = .1;

% Snoop matrix
A_Snoop=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:2 %loop through songs
    sample_locs=Snoop_sample_locs(x,:);
    song_file=Snoop_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_Snoop=[A_Snoop,spec_vec];
    end
end

% Dre matrix
A_Dre=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:2 %loop through songs
    sample_locs=Dre_sample_locs(x,:);
    song_file=Dre_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_Dre=[A_Dre,spec_vec];
    end
end

% Eminem matrix
A_Eminem=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:2 %loop through songs
    sample_locs=Eminem_sample_locs(x,:);
    song_file=Eminem_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_Eminem=[A_Eminem,spec_vec];
    end
end
%% Classify 
% Create Training and Test Data Set
A_train2=[A_Snoop(:,1:2:40),A_Dre(:,1:2:40),A_Eminem(:,1:2:40)];
A_test2=[A_Snoop(:,2:2:40),A_Dre(:,2:2:40),A_Eminem(:,2:2:40)];

% SVD 
[U_train2, S_train2, V_train2]=svd(A_train2,0);
[U_test2, S_test2, V_test2]=svd(A_test2,0);

% classify
label2=[repelem(1,20) ,repelem(2,20) ,repelem(3,20) ]'; % 1=Snoop 2=Dre 3=Eminem
class2=classify(V_test2(:,1:50),V_train2(:,1:50),label2);


%% Plot Results

figure(1)
y=reshape(class2,20,3);
C = categorical(y,[1 2 3],{'Snoop','Dre','Eminem'});
hist(C)
legend('true Snoop','true Dre','true Eminem')
xlabel('Assigned Category')
ylabel('Sample Count')
title("Whats the Difference Between Me and You")


%% Functions

function plot_ex_filt(sample, width, tc)
    t_vec=linspace(0,5,length(sample));
    g=exp(-width*(t_vec-tc).^2);   
  %  filt = g.*sample;
  %  filt_transform = fft(filt);
  %  filt_transform = fftshift(abs(filt_transform)); 
     plot(t_vec,sample)
     hold on
     plot(t_vec, g, 'Linewidth',2)
end

function play_sample_inc(filename,i)
    for k=1:length(i)
        m=i(k)
        [sample,Fs]=audioread(filename); %Load  song
        sample=sample(1+(Fs*m):(5*Fs)+(Fs*m))'; % grab mth 5 second interval
        p8 = audioplayer(sample, Fs);
        playblocking(p8);
    end
end




