  function csv =csv(img1, img2)

 %Perceptual color weights (d in Eq. 4)Section 3.2, Figure 3
  D= [0 1 0.9497 0.76544 1 1 1 1 1 1 1;...
	  1 0 1 1 1 1 1 1 1 1 1;...
	  0.9497 1 0 0.93538 1 1 1 1 1 1 1;...
	  0.76544 1 0.93538 0 1 1 1 1 1 0.68809 1;...
	  1 1 1 1 0 1 1 1 1 1 1;...
	  1 1 1 1 1 0 1 1 0.92114 1 1;...
	  1 1 1 1 1 1 0 1 1 1 1;...
	  1 1 1 1 1 1 1 0 1 1 1;...
	  1 1 1 1 1 0.92114 1 1 0 1 1;...
	  1 1 1 0.68809 1 1 1 1 1 0 1;...
	  1 1 1 1 1 1 1 1 1 1 0];
  T=20;
  
% Section 6.3 - Parameters 
% blockSize is the W in the paper
blockSize=[20 20];
% weightCND is the A in the paper 
weightCND=0.9;
% P is the power of the mean value
P=4;
% stdVal is the \sigma
stdVal=50;
% K_L, K_C and K_H are 
K_L=1;
K_C=1;
K_H=1;
K=[K_L,K_C,K_H];
% n is not explicitly defined since 11 word dictionary is directly used in
% RGB_to_color_terms function.


  
  
%% Section 5. - Retinal Ganglion cell-based difference (RGCD)
%Define filter type as Laplacian of Gaussian (LoG) 
filterType='log';
%Initialize standard deviation (mentioned in Section 6.3.)

%Generate filter
h = fspecial(filterType, blockSize,stdVal);
%Filter the R channels of compared images 
imgInd=1;
img1LoG_R=imfilter(double(img1(:,:,imgInd)),h,'replicate');
img2LoG_R=imfilter(double(img2(:,:,imgInd)),h,'replicate');
%Filter the G channels of compared images 
imgInd=2;
img1LoG_G=imfilter(double(img1(:,:,imgInd)),h,'replicate');
img2LoG_G=imfilter(double(img2(:,:,imgInd)),h,'replicate');
%Filter the B channels of compared images 
imgInd=3;
img1LoG_B=imfilter(double(img1(:,:,imgInd)),h,'replicate');
img2LoG_B=imfilter(double(img2(:,:,imgInd)),h,'replicate');
% Calculate the difference between filter maps
imgLoG_R=abs(img1LoG_R-img2LoG_R);
imgLoG_G=abs(img1LoG_G-img2LoG_G);
imgLoG_B=abs(img1LoG_B-img2LoG_B);
% Pool the individual maps using geometric mean to obtain the RGCD map
csv_rgcd=nthroot(imgLoG_R.*imgLoG_G.*imgLoG_B,3);
%% Section 4 - Blockwise Structural Difference  (BSD)
%Define local normalization operator 
funNorm=@(block_struct) (block_struct.data-mean2(block_struct.data))/...
(std(reshape(block_struct.data,[numel(block_struct.data) 1]))+0.001);
%Calculate BSD in each color channel separately
imgBSD_R=abs(blockproc(double(img1(:,:,1)),blockSize,funNorm)-blockproc(double(img2(:,:,1)),blockSize,funNorm));
imgBSD_G=abs(blockproc(double(img1(:,:,2)),blockSize,funNorm)-blockproc(double(img2(:,:,2)),blockSize,funNorm));
imgBSD_B=abs(blockproc(double(img1(:,:,3)),blockSize,funNorm)-blockproc(double(img2(:,:,3)),blockSize,funNorm));
% Pool the individual maps using geometric mean to obtain the BSD map
csv_bsd=nthroot(imgBSD_R.*imgBSD_G.*imgBSD_B,3);
%% Section 3 Perceptual Color Difference
%Define mean pooling operation
colorConv=makecform('srgb2lab');




funMean=@(block_struct) (mean2(block_struct.data));




% Mean pool the color channels of compared images
for ii=1:3    
img1Mean(:,:,ii)=blockproc(double(img1(:,:,ii)),blockSize,funMean);
img2Mean(:,:,ii)=blockproc(double(img2(:,:,ii)),blockSize,funMean);
end

lab_1= applycform(double(squeeze(img1Mean))./255,colorConv );
lab_2= applycform(double(squeeze(img2Mean))./255,colorConv);


% Initilize CIEDE and CND maps
[s1,s2,~]=size(img1Mean);
ciedeMap=zeros(s1,s2);
cndMap=ciedeMap;
% Preprocess data to avoid out of range issues and calculate CIEDE and CND
% values for each pixel
for i=1:s1
    for j=1:s2          
        ciedeMap(i,j)= min([deltaE2000(squeeze(lab_1(i,j,:))',squeeze(lab_2(i,j,:))',K), T])/T;
        cn_1= RGB_to_color_terms(squeeze(img1Mean(i,j,:))');
        cn_2= RGB_to_color_terms(squeeze(img2Mean(i,j,:))');
        cndMap(i,j)= emd_hat_gd_metric_mex(cn_1',cn_2',D);   
    end    
end
% Interpolate CIEDE and CND maps to input image resolution
% Mean is subtracted from the resized maps since interpolation can lead to
% negative values.
ciedeMap=imresize(ciedeMap,size(imgBSD_R));
ciedeMap=ciedeMap-min(min(ciedeMap));
cndMap=imresize(cndMap,size(imgBSD_R));
cndMap=cndMap-min(min(cndMap));

% Section 6.1. -  PCD map is calculated by combining ciede and cnd maps
csv_pcd=weightCND*cndMap+(1-weightCND)*ciedeMap;

% PCD,RGCD and BSD maps are multiplicatively combined
csvMap=csv_bsd.*csv_rgcd.*csv_pcd;
% Section 6.1. - CSV is obtained from the pooled map as in Eq 14.
csv=(1-nthroot(mean2(csvMap),P));
  end