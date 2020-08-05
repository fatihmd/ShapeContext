function [pol_hist]=shape_context(sampled,size,ind)

modified_sample = sampled;
%setting the given point as reference point to other point by making it
%origin and setting other coordinated according to new origin
for i = 1 : 1 : size
    modified_sample(i,:) = modified_sample(i,:) - sampled(ind,:);
end
x_coords = modified_sample(:,1);
y_coords = modified_sample(:,2);

%calculating r and theta values for given point as reference point relative
%to others
pol_hist = [sqrt(x_coords.^2 + y_coords.^2), ...
    atan2(y_coords,x_coords)];
