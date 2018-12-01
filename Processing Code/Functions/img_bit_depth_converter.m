function [ save_img ] = img_bit_depth_converter( img, bit_depth )
%% Image Bit Depth Converter
%   By: Niklas Gahm
%   2018/11/30
%
%   This is a function which converts an input image from double to either
%   8, 16, 32, or 64 bit unsigned integer
% 
%   2018/11/30 - Started 
%   2018/11/30 - Finished



switch bit_depth
    case 8
        save_img = uint8(img);
    case 16
        save_img = uint16(img);
    case 32
        save_img = uint32(img);
    case 64
        save_img = uint64(img);
    otherwise
        
end
end

