
//this is where the original images are stored
in_dir = "D:\\bredfeldt\\TissueMill\\20140418_Vezina_Adult_Perfused_Good\\";
in_dir_long = "D:\\\\bredfeldt\\\\TissueMill\\\\20140418_Vezina_Adult_Perfused_Good\\\\";

//this is where the images will be stored
out_dir = "D:\\bredfeldt\\TissueMill\\20140418_Vezina_Adult_Perfused_Good_Proc\\";

//x, y, z dimensions (# of images)
xdim = 7;
ydim = 6;
zdim = 569;

curZ = 1;

//loop through all open images in specific order
for (x=0; x<xdim; x++) {
	for (y=0; y<ydim; y++) {
		
	//open image
	//run("Bio-Formats Importer", "open=" + in_dir + "001_001_001.tif color_mode=Default group_files split_timepoints split_channels view=Hyperstack stack_order=XYCZT swap_dimensions axis_1_number_of_images=7 axis_1_axis_first_image=1 axis_1_axis_increment=1 axis_2_number_of_images=6 axis_2_axis_first_image=1 axis_2_axis_increment=1 axis_3_number_of_images=570 axis_3_axis_first_image=1 axis_3_axis_increment=1 file=[] pattern=" + in_dir_long + "00"+x+"_00"+y+"_<001-"+zdim+">.tif 1_planes=C "+zdim+"_planes=Z 1_planes=T");

	//run("Bio-Formats Importer", "open=D:\\bredfeldt\\TissueMill\\20140418_Vezina_Adult_Perfused_Good\\001_001_001.tif color_mode=Default group_files split_timepoints split_channels view=Hyperstack stack_order=XYCZT swap_dimensions axis_1_number_of_images=7 axis_1_axis_first_image=1 axis_1_axis_increment=1 axis_2_number_of_images=6 axis_2_axis_first_image=1 axis_2_axis_increment=1 axis_3_number_of_images=570 axis_3_axis_first_image=1 axis_3_axis_increment=1 file=[] pattern=D:\\\\bredfeldt\\\\TissueMill\\\\20140418_Vezina_Adult_Perfused_Good\\\\001_001_<001-569>.tif 3_planes=C 569_planes=Z 6_planes=T");
	//run("Bio-Formats Importer", "open=D:\\bredfeldt\\TissueMill\\20140418_Vezina_Adult_Perfused_Good\\001_001_001.tif color_mode=Default group_files split_timepoints split_channels view=Hyperstack stack_order=XYCZT swap_dimensions axis_1_number_of_images=7 axis_1_axis_first_image=1 axis_1_axis_increment=1 axis_2_number_of_images=6 axis_2_axis_first_image=1 axis_2_axis_increment=1 axis_3_number_of_images=570 axis_3_axis_first_image=1 axis_3_axis_increment=1 file=[] pattern=D:\\bredfeldt\\TissueMill\\20140418_Vezina_Adult_Perfused_Good\\001_001_<001-569>.tif 569_planes=Z 1_planes=C 1_planes=T");
	run("Image Sequence...", "open=" + in_dir + "001_001_001.tif number=" + zdim + " starting=" + curZ + " sort");
	curZ = curZ + zdim;

	new_name = "" + y + "_" + x;
	print(new_name);
	
	//save current image
	saveAs("Tiff", out_dir + new_name + ".tif");	
	
	//resize to 512
	run("Size...", "width=512 height=382 depth=569 constrain average interpolation=Bilinear");
	
	//save as med
	saveAs("Tiff", out_dir + new_name  + "_med.tif");
	
	//resize to 256
	run("Size...", "width=256 height=191 depth=569 constrain average interpolation=Bilinear");
	
	//save small
	saveAs("Tiff", out_dir + new_name  + "_small.tif");
	
	//close image
	close();
		
	}
}
