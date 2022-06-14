Sequential Erosion Tissue Imaging (SETI) Microscope Project - Embedding Image Analysis

This folder contains the Image Analysis script for determining the embedding methodology for the SETI microscope.


Installation Requirements:
Windows 10 operating system
Version 2.20.0 of Anaconda Navigator (https://www.anaconda.com/products/individual)
Version 1.2.7 of image_quality

Installation Process:
- Install Anaconda Navigator
- Start Anaconda Navigator
--- If update is available, update now.
- Install Image Quality Package
--- Launch the command terminal (cmd.exe prompt) from Anaconda Navigator
--- Type in Commands:
--- pip install image-quality
- Comment Out 1 line in brisque.py
--- Navigate to your Anaconda install (Generally under C://Users/User/anaconda3)
--- Within the Anaconda install folder navigate to ~\anaconda3\Lib\site-packages\imquality
--- Open brisque.py with an editor 
--- Comment out (#) line 45      self.image = skimage.color.rgb2gray(self.image)
--- Save the file
----- This enables BRISQUE to run on gray scale images. Uncomment for RGB images.
- Launch Jupyter Notebooks Panel from Anaconda Navigator
- Open Embedding_Image_Quality.ipynb in Jupyter Notebook


Raw Data Folder Structure:
- Main Data Folder
--- Embedding Method
----- Sample
------- Image Sequence Acquisition
i.e.
- data_t
--- LR White
----- 2022-01-14 LR White Chicken
------- Structure 1

