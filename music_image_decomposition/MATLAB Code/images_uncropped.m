%% Read in Cropped Images
clear all; close all; clc

%Load matrix (commented code below shows how the matrix was built
load('uncropped_matrix_all.mat');
m=243;
n=320;

% %matrix with all ppl 
% A_all_uncropped=[] %person(1-38) by imagenum(1-#of images in folder) by length image vector
% uncropped_all_files = dir('drive-download-20200227T205732Z-001/yalefaces_uncropped/yalefaces/subject*');
% for i=1:length(uncropped_all_files)
%     image = imread(strcat(uncropped_all_files(i).folder,'/',uncropped_all_files(i).name));
%     [m,n]=size(image);
%     image_vec=reshape(image,m*n,1);
%     A_all_uncropped(i,:)=image_vec;
% end
%save('uncropped_matrix_all.mat','A_all_uncropped');

%% SVD
A_k=A_all_uncropped'; %each column of this is an image of ther person from different perspective (lighting etc)
[U,S,V]=svd(A_k,0);

%% Plot Singular Values
%Plot singular values
figure(1)
subplot(2,1,1)
plot(diag(S),'*','Linewidth',2)
axis([0 60 0 150000])
xlabel("mode")
ylabel("value")
title('regular plot')
subplot(2,1,2)
loglog(diag(S),'*','Linewidth',2)
axis([0 60 0 1100000])
xlabel("mode")
ylabel("value")
title('loglog plot')

sgtitle('Singular Value Plots')

saveas(gcf,"/Users/rachelcarroll/Documents/AMATH/AMATH 582 - Computational Data Analysis/HW 4/uncropped_sigvals.jpg")


%% Plot Eigenfaces
face_counts = 4;
figure(2)
for i=1:face_counts
    subplot(1,face_counts,i)
    imshow(uint8(uvec_to_image(U(:,i),m,n)));
    title(['Eigenface ', num2str(i)])
end

saveas(gcf,"/Users/rachelcarroll/Documents/AMATH/AMATH 582 - Computational Data Analysis/HW 4/uncropped_efaces.jpg")

%% Plots Eigencoefficients
v_1=V(:,1);
v_2=V(:,2);
v_3=V(:,3);

figure(3)
subplot(3,1,1)
plot(v_1,'*')
axis([1 200 -.06 .06])
title("First Vector")
subplot(3,1,2)
plot(v_2,'*')
axis([1 200 -.06 .06])
title("Second Vector")
subplot(3,1,3)
plot(v_3,'*')
axis([1 200 -.06 .06])
title("Third Vector")

sgtitle("Uncropped Eigenface Coefficients")

saveas(gcf,"/Users/rachelcarroll/Documents/AMATH/AMATH 582 - Computational Data Analysis/HW 4/uncropped_eface_coeffs.jpg")


%% Low rank approximation (person 1)
image_1=uvec_to_image(A_k(:,1),m,n); %first image

[u_recon,s_recon,v_recon]=svd(image_1,0); %SVDing just first image and looking at only some modes

figure(4)
subplot(2,3,2)
imshow(uint8(image_1)); % show actual image
title("actual image")
lr_choice=[2,5,10];

for i=1:3
    modes=lr_choice(i);
    lr = u_recon(:,1:modes)* s_recon(1:modes,1:modes) * v_recon(:,1:modes)';    
    subplot(2,3,3+i)
    imshow(uint8(lr));
    title(sprintf('%d modes' ,modes))
end

sgtitle("Low Rank Approximation of Image 1")

saveas(gcf,"/Users/rachelcarroll/Documents/AMATH/AMATH 582 - Computational Data Analysis/HW 4/uncropped_lr_im1.jpg")


%% Low rank approximation (all people)
all_vec=sum(A_k')';
all_image=uvec_to_image(all_vec,m,n);

[u_recon,s_recon,v_recon]=svd(all_image,0); %SVDing 

figure(4)
subplot(2,3,2)
imshow(uint8(all_image)); % show actual image
title("all image")
lr_choice=[2,5,10];

for i=1:3
    modes=lr_choice(i);
    lr = u_recon(:,1:modes)* s_recon(1:modes,1:modes) * v_recon(:,1:modes)';    
    subplot(2,3,3+i)
    imshow(uint8(lr));
    title(sprintf('%d modes' ,modes))
end

sgtitle("Low Rank Approximation of All Images Combined")

saveas(gcf,"/Users/rachelcarroll/Documents/AMATH/AMATH 582 - Computational Data Analysis/HW 4/uncropped_lr_all.jpg")
