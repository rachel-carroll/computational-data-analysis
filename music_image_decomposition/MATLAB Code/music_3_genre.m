%% Music Part 3: Genre Classification

clear all; close all; clc

%% Genre Songs and Sample Locations
Rap_files =["music_samples/07 Snoop D.O. Double G.m4a", "music_samples/18 Pass it Pass it.m4a","music_samples/04 Still D.R.E..m4a","music_samples/07 Whats the Difference.m4a","music_samples/02 White America.mp3", "music_samples/13 Superman.m4a","music_samples/06 It was all a dream.mp3", "music_samples/N.O.T.O.R.I.O.U.S..mp3"];
Rap_sample_locs=[45:5:90;
                   45:5:90;
                  [20:5:55,80,90];
                   30:5:75;
                   45:5:90;
                   50:5:95;
                   45:5:90;
                   45:5:90];

Opera_files =["music_samples/3-11 Excerpts From Otello 1.m4a", "music_samples/3-14 Excerpts From Otello 4.m4a","music_samples/3-21 Madama Butterfly _Un Bel Di_ 1.m4a","music_samples/3-22 Madama Butterfly _Un Bel Di_ 2.m4a","music_samples/3-23 Madama Butterfly _Un Bel Di_ 3.m4a"];
Opera_sample_locs=[5:5:80;
                   5:5:80;
                   5:5:80;
                   5:5:80;
                   5:5:80];
               
Blues_files =[ "music_samples/3-56 Florida-Bound Blues 3.m4a"...
    "music_samples/14 Got My Mojo Working 1&2.m4a","music_samples/1-06 Hoochie Coochie Man.m4a"...
    "music_samples/03 Stagolee.m4a","music_samples/02 Coffee Blues.m4a","music_samples/01 Candy Man.m4a"...
    "music_samples/05 Hobo Blues.m4a","music_samples/10 Sally Mae.m4a"];
Blues_sample_locs=[5:5:50;
                   45:10:140;
                   45:10:140;
                   45:10:140;
                   45:10:140;
                   45:10:140;
                   45:10:140;
                   45:10:140];

%% Song Sample Matrices

spec_width = 100;
time_inc = .1;

% Rap matrix
A_Rap=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:8 %loop through songs
    sample_locs=Rap_sample_locs(x,:);
    song_file=Rap_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_Rap=[A_Rap,spec_vec];
    end
end

% Opera matrix
A_Opera=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:5 %loop through songs
    sample_locs=Opera_sample_locs(x,:);
    song_file=Opera_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_Opera=[A_Opera,spec_vec];
    end
end

% Blues matrix
A_Blues=[]; % this matrix will hold all spectrogram data of the aded samples
for x=1:8 %loop through songs
    sample_locs=Blues_sample_locs(x,:);
    song_file=Blues_files(x);
    for i=sample_locs %loop through sample locations for given song
        [sample,Fs,t,ks]=five_sec_sample(song_file,i);%get ith 5 sec sample
        spec_vec=spec(sample,spec_width,time_inc,'n','vec');%vectorized spectrogram
        A_Blues=[A_Blues,spec_vec];
    end
end
%%
% Create Training and Test Data Set
 
A_train2=[A_Blues(:,1:2:80), A_Rap(:,1:2:80), A_Opera(:,1:2:80)];
A_test2=[A_Blues(:,2:2:80), A_Rap(:,2:2:80), A_Opera(:,2:2:80)];

% SVD that shit
[U_train2, S_train2, V_train2]=svd(A_train2,0);
[U_test2, S_test2, V_test2]=svd(A_test2,0);

% classify
label2=[repelem(1,40) ,repelem(2,40) ,repelem(3,40) ]'; % 1=Blues 2=Opera 3=Rap
class2=classify(V_test2(:,1:50),V_train2(:,1:50),label2);


%% Plot Results

figure(1)
y=reshape(class2,40,3);
C = categorical(y,[1 2 3],{'Blues','Opera','Rap'});
hist(C)
legend('true Blues','true Opera','true Rap')
xlabel('Assigned Category')
ylabel('Sample Count')
title("Music Genre Classification Results")

%% Functions

function plot_ex_filt(sample, width, tc)
    t_vec=linspace(0,5,length(sample));
    g=exp(-width*(t_vec-tc).^2);   
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


