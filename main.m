clc; clear;
data = loadMNISTImages('train.idx3-ubyte');
%get images of same digits which are written in different styles
testim1 = data(:,14);%14-6
testim2 = data(:,19);%19-6
% 1-5 2-0 3-4 4-1 5-9 6-2 7-1 8-3 9-1 10-4
%show first image
Image1=(reshape(testim1, [28,28]));
figure;
imshow(Image1);
title('image 1');

%show second image
Image2=(reshape(testim2, [28,28]));
figure;
imshow(Image2);
title('image 2');

%extract first image's edge
edge1 = edge(Image1, 'Canny');
figure;
imshow(edge1);
title('edge for image 1');

%extract second image's edge
edge2 = edge(Image2, 'Canny');
figure;
imshow(edge2);
title('edge for image 2');

%convert image 1 in binary form to extract boundaries
bin_image1 = im2bw(Image1);
%bin_image1 = edge1;
ind1 = find(bin_image1,1);
size1 = size(bin_image1);
[row1,column1] = ind2sub(size1,ind1); %get the first non-zero point as an initial point for tracing boundaries
boundary1 = bwtraceboundary(bin_image1,[row1, column1],'NE',8,Inf,'clockwise');

sampled1 = [];
k = 1;
blim1  = 71;
inc1 = 1;
lim1 = blim1 / inc1;
for i = 1 : inc1 : blim1 %for i = 1 : 2 : 68
    sampled1(k,1) = boundary1(i,1);
    sampled1(k,2) = boundary1(i,2);
    k = k + 1;
end

figure;
imshow(Image1)
hold on;
%plot(boundary1(:,2),boundary1(:,1),'g','LineWidth',3);
plot(sampled1(:,2),sampled1(:,1),('g*'));
title('Sampled point for shape 1');


%convert image 2 in binary form to extract boundaries
bin_image2 = im2bw(Image2);
%bin_image2 = edge2;
ind2 = find(bin_image2,1);
size2 = size(bin_image2);
[row2,column2] = ind2sub(size2,ind2); %get the first non-zero point as an initial point for tracing boundaries
boundary2 = bwtraceboundary(bin_image2,[row2, column2],'NE',8,Inf,'clockwise');

sampled2 = [];
k = 1;
blim2  = 71;
inc2 = 1;
lim2 = blim2 / inc2;
for i = 1 : inc2 : blim2 %for i = 1 : 2 : 71
    sampled2(k,1) = boundary2(i,1);
    sampled2(k,2) = boundary2(i,2);
    k = k + 1;
end

figure;
imshow(Image2)
hold on;
%plot(boundary2(:,2),boundary2(:,1),'g','LineWidth',3);
plot(sampled2(:,2),sampled2(:,1),('g*'));
title('Sampled point for shape 2');


binr = 5;
bink= 12;
xcoord = sampled2(:,1);
ycoord = sampled2(:,2);
%calculating r and theta values for given point as reference point relative
%to others
X = [sqrt(xcoord.^2 + ycoord.^2), ...
    atan2(ycoord,xcoord)];


figure;
hist3(X,'Nbins',[binr bink]);
xlabel('r')
ylabel('theta')


Y1 = shape_context(sampled1,lim1,55); %34

figure;
hist3(Y1,'Nbins',[binr bink]);
xlabel('r')
ylabel('theta')


Y2 = shape_context(sampled2,lim2,40); %36 %35

figure;
hist3(Y2,'Nbins',[binr bink]);
xlabel('r')
ylabel('theta')


myArray1 = zeros(5,12,lim1);%34
for i = 1 : 1 : lim1 %34
    myArray1(:,:,i) = hist3(shape_context(sampled1,lim1,i),'Nbins',[binr bink]);
end                                                %34
myArray2 = zeros(5,12,lim2);%36
for i = 1 : 1 : lim2 %36
    myArray2(:,:,i) = hist3(shape_context(sampled2,lim2,i),'Nbins',[binr bink]);
end                                                %36
%subMatrix = myArray(:,:,3);  % Gets the third matrix
cost_mat = zeros(lim1,lim2);
for i = 1 : 1 : lim1 %34
    for k = 1 : 1 : lim2 %36
        cost_mat(i,k) = h_cost(myArray1(:,:,i),myArray2(:,:,k));
    end
end

[assignments, shapeCost] = munkres(cost_mat);
k = find(assignments);
sizek = size(assignments);
[rowk,columnk] = ind2sub(sizek,k);
figure;
hold on;
plot(sampled1(:,2),sampled1(:,1),('b*'));
plot(sampled2(:,2),sampled2(:,1),('g*'));
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

for i = 1 : 1 : lim1
    hold on;
    plot([sampled1(rowk(i),2) sampled2(columnk(i),2)],[sampled1(rowk(i),1) sampled2(columnk(i),1)]);
end

