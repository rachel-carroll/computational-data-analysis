function imagevec=uvec_to_image(u_in_vec,m,n)    
    imagevec=u_in_vec-min(u_in_vec);
    imagevec=imagevec*(255/max(imagevec));
    imagevec=reshape(imagevec,m,n);
end