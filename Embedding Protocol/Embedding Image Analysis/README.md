Sequential Erosion Tissue Imaging (SETI) Microscope Project - Embedding Image Analysis

This folder contains the Image Analysis script for determining the embedding methodology for the SETI microscope.

Installation Requirements:
Windows 10 operating system
Version 2.1.0/1.53c of Fiji (https://imagej.net/Fiji.html#Downloads)
Version 1.0.0 of FLIMJ 
Version 1.10.0 of Anaconda Navigator (https://www.anaconda.com/products/individual)
Version 1.0.0 of PyImageJ 
Version 6.2.0 of Jupyter Notebook 
Version 1.30 of BeakerX 

Installation Process:
- Install FLIMJ Plugin for FIJI
--- Open the local install of FIJI 
--- Open the ImageJ Updater by selecting  “Help → Update...”
--- Open the Update Site List by selecting “Manage update sites” in the bottom left corner of the window
--- In the list of Update sites scroll down and check “FLIMJ” 
--- Close the “Manage update sites” window
--- Select “Apply Changes” in the “ImageJ Updater” Window
--- Restart FIJI
- Start Anaconda Navigator
- Install PyImageJ Environment 
--- Launch the command terminal from Anaconda Navigator
--- Type in Commands:
--- conda create -n pyimagej -c conda-forge pyimagej openjdk=8
--- conda activate pyimagej
- Switch to the PyImageJ Environment in Anaconda Navigator by selecting it from the dropdown menu next to “Applications on”
- Install BeakerX and PyWidgets
--- Launch the command terminal from Anaconda Navigator
--- Type in Commands:
--- conda install -c conda-forge ipywidgets beakerx
- On the Jupyter Notebooks Panel select install
- Once installed select launch


