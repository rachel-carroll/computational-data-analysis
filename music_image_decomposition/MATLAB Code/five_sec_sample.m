function [sample,Fs,t,ks] = five_sec_sample(filename, m)
    [sample,Fs]=audioread(filename); %Load  song
    sample=sample(1+(Fs*m):(5*Fs)+(Fs*m))'; % grab mth 5 second interval
    sample=sample(1:3:length(sample));%decrease sample size by 1/3
    sample=sample';
    Fs=Fs/3;
    n=length(sample);
    ks=(1/5)*[-n/2:(n/2)-1]; %frequency domain
    t=linspace(0,5,length(sample));
end