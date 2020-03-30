function [spec,t_center]=spec(sample, width, t_inc, show, form)
    t_vec=linspace(0,5,length(sample));
    t_center=[0:t_inc:5];
    spec=[];
    n=length(sample);
    ks=(1/5)*[-n/2:(n/2)-1]; %frequency domain
    for i=1:length(t_center)    
        g=exp(-width*(t_vec-t_center(i)).^2);   
        filt = g.*sample;
        filt_transform = fft(filt);
        filt_transform = fftshift(abs(filt_transform)); 
        spec=[spec;filt_transform]; 
    end
    %index resonable range of music frequencies
    spec=spec(:,[.5*length(ks):.7*length(ks)]);
    ks=ks(.5*length(ks):.7*length(ks));
    if show=='y'
        pcolor(t_center,ks,spec.'), 
        shading interp 
      %  set(gca,'Ylim',[0 3000],'Fontsize',[12]) 
        colormap(hot)    
    end
    if form == 'vec'
         spec=reshape(spec,size(spec,1)*size(spec,2),1);
     end
end