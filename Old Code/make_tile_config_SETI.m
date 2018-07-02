clear all;
close all;

num_x = 4;
num_y = 4;

for i = 1:3
    if i == 1
        id = '_small';
        k = 1;
    elseif i == 2
        id = '_med';
        k = 2;
    else
        id = '';
        k = 5.44;
    end

    fname = sprintf('TileConfiguration%s.txt',id);
    fid = fopen(fname,'w+');

    nl = sprintf('\r\n');
    fprintf(fid,'# Define the number of dimensions we are working on\r\n');
    fprintf(fid,'dim = 3\r\n');
    fprintf(fid,'\r\n');

    fprintf(fid,'# Define the image coordinates\r\n');

    posx = 0.0;
    posy = 0.0;
    rotx = -1.5*k;
    roty = -3*k;
    shftx = -224*k;
    shfty = -168*k;
    posz = 0.0;

    for y = 1:num_y
        for x = 1:num_x

            fprintf(fid,'%d_%d%s.tif; ; (%0.2f, %0.2f, %0.2f)\r\n',y-1,x-1,id,posx,posy,posz);

            if x == 1
                fposx = posx;
                fposy = posy;
            end        
            posx = posx + shftx;
            posy = posy + roty;               

        end
        posx = fposx - rotx;
        posy = fposy + shfty;
    end

    fclose(fid);
end