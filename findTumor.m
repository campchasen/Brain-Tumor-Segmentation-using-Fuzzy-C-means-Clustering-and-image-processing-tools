function[numTumorPix] = findTumor(Img,Tumor)
%c is the number of clusters you want to create.
c = 6;
preArr3D = double(imread(Img));
size1 = size(preArr3D);% P(1) x Q(2) x 3(3) array
p = size1(1);
q = size1(2);
dim = size1(3);

reshapedImg = reshape(preArr3D, p*q, dim);

%-------------The following was an implementation of the elbow method to
%----------estimate the optimal number of clusters----------------------%

 %nClusters=8; % pick/set number of clusters your going to use
%totSum=zeros(nClusters);  % preallocate the result
%for i=1:nClusters
 % [~,~,sumd]=fcm(reshapedImg,i);
  %totSum(i)=sum(sumd);
%end
%plot(totSum)
%title('Plot of Within Cluster Sum of Squares vs Number of Clusters for Image2')
%xlabel('Number of Clusters') 
%ylabel('WSS') 
%------------------------------------------------------------------------%


%
options = [1.1 5000 .000001 false];

[centers, U] = fcm(reshapedImg, c, options);
%centers = c x dim matrix that contains the coordinates of each cluster
%coordinate. U = the partition matrix of each pixel. 


%A vector containing all of the maximum membership values of U
maxValvec = max(U);       
for i = 1:p*q
    for j = 1:c 
       if maxValvec(i) == U(j,i)
           idxVec(i) = j;%create an index values of numbers 1 to total number of clusters (6)
       end
    end
end



c1Mat1 = reshape(idxVec,[p,q]);% a matrix of numbers 1-6 where each pixel in the original image now has its cluster in the same positon

%the following nested for loops will create a logical multi dimensional
%array for each cluster. Then the logical array is compared to the original
%3D array and if there is a match to the cluster, then the cluster color
%value will replace the logical vlaue in c1. ( note that the logical value
%was actually changed to numerical for compariso, It is more
%straightforward to keep refereing to it as a logical matrix). This is
%repeated for every cluster and unfortunately results in a not ideal run
%time. 
logic1 = (c1Mat1 == 1);
c1 = double(logic1);
temp = c1;
c1(:,:,2) = temp;
c1(:,:,3) = temp;

for i = 1:p
    for j = 1:q
        for k = 1:3
            if c1(i,j,k) == 1
               c1(i,j,k) = preArr3D(i,j,k);
            end
        end
    end
end



c2Mat1 = reshape(idxVec,[p,q]);
logic2 = (c2Mat1 == 2);
c2 = double(logic2);
temp2 = c2;
c2(:,:,2) = temp2;
c2(:,:,3) = temp2;

for i = 1:p
    for j = 1:q
        for k = 1:3
            if c2(i,j,k) == 1
               c2(i,j,k) = preArr3D(i,j,k);
            end
        end
    end
end

c3Mat1 = reshape(idxVec,[p,q]);
logic3 = (c3Mat1 == 3);
c3 = double(logic3);
temp3 = c3;
c3(:,:,2) = temp3;
c3(:,:,3) = temp3;

for i = 1:p
    for j = 1:q
        for k = 1:3
            if c3(i,j,k) == 1
               c3(i,j,k) = preArr3D(i,j,k);
            end
        end
    end
end

c4Mat1 = reshape(idxVec,[p,q]);
logic4 = (c4Mat1 == 4);
c4 = double(logic4);
temp4 = c4;
c4(:,:,2) = temp4;
c4(:,:,3) = temp4;

for i = 1:p
    for j = 1:q
        for k = 1:3
            if c4(i,j,k) == 1
               c4(i,j,k) = preArr3D(i,j,k);
            end
        end
    end
end

c5Mat1 = reshape(idxVec,[p,q]);
logic5 = (c5Mat1 == 5);
c5 = double(logic5);
temp5 = c5;
c5(:,:,2) = temp5;
c5(:,:,3) = temp5;

for i = 1:p
    for j = 1:q
        for k = 1:3
            if c5(i,j,k) == 1
               c5(i,j,k) = preArr3D(i,j,k);
            end
        end
    end
end

c6Mat1 = reshape(idxVec,[p,q]);
logic6 = (c6Mat1 == 6);
c6 = double(logic6);
temp6 = c6;
c6(:,:,2) = temp6;
c6(:,:,3) = temp6;

for i = 1:p
    for j = 1:q
        for k = 1:3
            if c6(i,j,k) == 1
               c6(i,j,k) = preArr3D(i,j,k);
            end
        end
    end
end

%After the image has been segmented according to the assigned clusters,
%image processing tools are used to refine the segmentation process based
%off texture differences of the tumor and the remaining non cancerous tissue of the supplied Tumor image.
%Then, since the process involves converitng the image to uint8 grayscale,
%all of the pixels of the tumor are counted and returned as the output of
%the funciton.


RGB = imread(Tumor);
I = rgb2gray(RGB);

E = entropyfilt(I);%create texture filter based off measure of randomness of image
Eim = rescale(E);

BW1 = imbinarize(Eim, .8);%convert to binary image to create masks and segment textures

BWao = bwareaopen(BW1,2000);%extract texture

nhood = true(9);
closeBWao = imclose(BWao,nhood);%smooth edges in the mask

roughMask = imfill(closeBWao,'holes');%close the gaps in the remaining texture


%cover with mask and establish as new image
I2 = I;
I2(roughMask) = 0;


%repeat for new image to apply to
E2 = entropyfilt(I2);
E2im = rescale(E2);

BW2 = imbinarize(E2im);

mask2 = bwareaopen(BW2,1000);

texture1 = I;
texture1(~mask2) = 0;
texture2 = I;
texture2(mask2) = 0;
%texture2 is now a gray scale image of a more accurately segmented brain
%tumor

%count the pixels
notBlackPix = texture2 ~= 0;
numTumorPix = sum(notBlackPix(:));


%Display all results
%montage({texture2,uint8(preArr3D),uint8(c1),uint8(c2),uint8(c3),uint8(c4),uint8(c5),uint8(c6)})
imshow(texture2)
end
