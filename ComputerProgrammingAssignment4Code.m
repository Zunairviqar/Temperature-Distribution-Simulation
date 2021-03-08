% The Software models the temperature distribution in a thin metal plate with constant (isothermal) temperatures on each side, using a 2D grid (matrix).
validNandM = 50:1:200;
% Range for the valid values of N and M

N = input('Enter The Number Of Rows: '); 
% Prompts the user to input a value for N
while ~any(N==validNandM)
    N = input('Invalid! Enter Number Of Rows Again: ');
end
%loop to validate that the value input is within the range

M = input('Enter The Number of Columns: ');
while ~any(M==validNandM)
    M = input('Invalid! Enter Number Of Columns Again: ');
end

tempgrid = zeros(N,M);
% creates and initialises a NxM matrix called tempgrid with all zeros
 
for i = 1:4
    if i ==1
        temp(i) = input ('Enter the Temperature for Top of the Metal Plate: ');
        %Prompts the user to input a value
        while (temp(i)<0) || (temp(i)>255)
            temp(i) = input('Invalid! Enter the Temperature for Top of the Metal Plate Again: ');
        end
        %loop to validate that the value input is within the range
    elseif i ==2
        temp(i) = input ('Enter the Temperature for Bottom of the Metal Plate: ');
        while (temp(i)<0) || (temp(i)>255)
            temp(i) = input('Invalid! Enter the Temperature for Bottom of the Metal Plate Again : ');
        end
    elseif i ==3
        temp(i) = input ('Enter the Temperature for Left of the Metal Plate: ');
        while (temp(i)<0) || (temp(i)>255)
            temp(i) = input('Invalid! Enter the Temperature for Left of the Metal Plate Again: ');
        end
    else
        temp(i) = input ('Enter the Temperature for Right of the Metal Plate: ');
        while (temp(i)<0) || (temp(i)>255)
            temp(i) = input('Invalid! Enter the Temperature for Right of the Metal Plate Again: ');
        end
    end
end
% loop runs 4 times to prompt the user for input in each iteration

tv = input('Enter The Tolerance Value: ');
while (tv<0) || (tv>0.05)
    tv = input('Invalid! Enter The Tolerance Value Again: ');
end
 
tempgrid(:,1) = temp(3);
%Sets the entire first column of matrix tempgrid with temperature for left of the metal plate
tempgrid(:,M) = temp(4);
%Sets the entire last column of matrix tempgrid with temperature for right of the metal plate
tempgrid(1,:) = temp(1);
%Sets the entire first row of matrix tempgrid with temperature for top of the metal plate
tempgrid(N,:) = temp(2);
%Sets the entire last row of matrix tempgrid with temperature for bottom of the metal plate

x = zeros(N,M);
% creates and initialises a NxM matrix called x with all zeros
diff = ones(N,M);
% creates and initialises a NxM matrix called diff with all ones
time = 0;
% initialises time to 0

subplot(2,2,1)
% subplot(m,n,p) divides the current figure into an m-by-n grid and creates axes in the position specified by p
% this creates a 2x2 grid and positions the following image in the 1st position
image(tempgrid)
%prints an image of the matrix tempgrid
title(['Boundry Conditions at time = ',num2str(time)])
%creates a title for the image
colormap(jet), colorbar
%defines the colors for the image and shows the colorbar

subplot(2,2,2)
% positions the following contour graph on the 2nd position
contour(tempgrid)
% prints a contour plot for the matrix tempgrid
title(['Surface Contours at time = ',num2str(time)])

while 1
x(2:(N-1),2:(M-1)) = tempgrid(2:(N-1),2:(M-1));
%stores the previous values of the matrix tempgrid into the matrix x
tempgrid(2:(N-1),2:(M-1)) = (tempgrid(2:(N-1),1:(M-2)) + tempgrid(2:(N-1),3:M) + tempgrid(1:(N-2),2:(M-1)) + tempgrid(3:N,2:(M-1)))/4;
%Uses Matrix Algebra to add the adjacent values of each point altogether
diff(2:(N-1),2:(M-1)) =  tempgrid(2:(N-1),2:(M-1)) - x(2:(N-1),2:(M-1));
%calculates the difference between the previous and current values of the matrix tempgrid and stores into another matrix called diff
    diff(1,:) = 0;
    diff(N,:) = 0;
    diff(:,1) = 0;
    diff(:,M) = 0;
time = time + 1;
%increases the time with each iteration

subplot(2,2,3)
image(tempgrid)
title(['Heat Dissipation at time = ',num2str(time)])
colormap(jet), colorbar
drawnow limitrate;
% updates the figure as it is being processed and limits the number of updates to 20 frames per second

subplot(2,2,4)
contour(tempgrid)
contour(flipud(tempgrid))
title(['Surface Contours at time = ',num2str(time)])
drawnow limitrate;

if all(diff<tv)
    break;
end
%ends the interations when the difference for all the grid values is less than the tolerance value
end


