%% Part 1 Identifying Artists of Different Genres
% This part will classify samples from Adele, Charlie Parker,and DMX

clear all; close all; clc

%%Sample songs and locations
Adele_files =["music_samples/Adele-One And Only.wav", "music_samples/06 Adele - He Wont Go.mp3", "music_samples/07 Adele - Take It All.mp3"];
Adele_sample_locs=[7, 25, 40, 50, 63, 69, 80, 90, 95, 100, 110, 120,130, 135;
                   35,40, 45, 50, 63, 79, 85, 90, 100, 120, 130, 135, 140, 155;
                   9, 25, 35, 45, 50, 63, 69, 80, 90, 100, 110, 120, 130, 140];
               
CP_files =["music_samples/Confirmation4.wav", "music_samples/Charlie_Parker_Confirmation.wav","music_samples/3-67 Confirmation 3.m4a"];
CP_sample_locs=[0,5,10,15,20,25,30,35,40,45,50,55,60,65;
                0,5,10,15,20,25,30,35,40,45,50,55,60,65;
                0,5,10,15,20,25,30,35,40,45,50,55,60,65];
            
DMX_files =["music_samples/Ruff Ryders Anthem.mp3", "music_samples/08 make me lose my mind.mp3"];
DMX_sample_locs=[25, 30,40, 50, 63, 69, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 120, 125;
                 25, 30,40, 50, 63, 69, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 120, 125];


%% Song Sample Matrices

spec_width = 50;
time_inc = .1;

% Adele matrix
A_Adele=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:3 %loop through songs
    sample_locs=Adele_sample_locs(x,:);
    song_file=Adele_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_Adele=[A_Adele,spec_vec];
    end
end

% Charlie Parker matrix
A_CP=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:3 %loop through songs
    sample_locs=CP_sample_locs(x,:);
    song_file=CP_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_CP=[A_CP,spec_vec];
    end
end

% DMX matrix
A_DMX=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:2 %loop through songs
    sample_locs=DMX_sample_locs(x,:);
    song_file=DMX_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_DMX=[A_DMX,spec_vec];
    end
end
%% Classify
% Create Training and Test Data Set
A_train=[A_Adele(:,1:2:40),A_CP(:,1:2:40),A_DMX(:,1:2:40)];
A_test=[A_Adele(:,2:2:40),A_CP(:,2:2:40),A_DMX(:,2:2:40)];

% SVD that shit
[U_train, S_train, V_train]=svd(A_train,0);
[U_test, S_test, V_test]=svd(A_test,0);

% classify
label=[repelem(1,20) ,repelem(2,20) ,repelem(3,20) ]'; % 1=Adele 2=CP 3=DMX
class=classify(V_test(:,1:12),V_train(:,1:12),label);

%% plot results
y=reshape(class,20,3);
C = categorical(y,[1 2 3],{'Adele','CP','DMX'});
hist(C)
legend("true Adele","true Charlie Parker","true DMX")
xlabel('Assigned Artist')
ylabel('Sample Count')
title("Artist Classification")


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
