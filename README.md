# Atlantis Calibration – General Overview

This repository provides scripts to calibrate the Atlantis ecosystem model using the **calibrar** R package.  
The example included here is applied to the **Puget Sound Atlantis configuration**.

# Folder structure

## R scripts

- `runModel_Atlantis.R`  
  Wrapper function used by **calibrar** to run the Atlantis model with a new set of parameters. This script launches the model simulation and extracts the model outputs required for the calibration process.

- `calibrate_MPI.R`  
  Main script used to run the calibration procedure using the **calibrar** package. It loads all the calibration settings, parameters to estimate, and launches the optimization routine.

## CSV files

- `calibration_settings.csv`  
  Configuration file defining targets location and setup. 

- `calibration-parameters-complete.csv`  
  Table listing the calibrated Atlantis parameters with their initial values and bounds.

## Folders

- `configuration`  
  Contains the Atlantis configuration.

- `data`  
  Calibration targets.

- `keep_track_calibration`  
  Stores the outputs of each automated calibration trial with **calibrar**. Scripts to explore the outputs of calibrar are available. 

- `create_Atlantis_calibrar_files`  
  Scripts used to generate the input files required by **calibrar**, including formatted parameter tables and calibration configuration files.
  We recommand to use them as example only if needed. These script are quite basic. 

# Recommendations for performing an Atlantis calibration with calibrar

To perform the Atlantis Calibration with calibrar, review our material in this order:

1. Read our preprint describing the calibration of Atlantis using **calibrar**:  
   https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5888414

2. Go through the slides presenting the article:  
   https://docs.google.com/presentation/d/1LF5dIWs0NObyVicStsMRFs5jmnmBjcYI/edit

3. Watch the recording of the workshop describing the files and scripts:  
   https://drive.google.com/file/d/1QSdkpcLq7TR39WiESiUJAEdU-YdxBp5o/view  

   A transcript of the workshop is also available:  
   https://docs.google.com/document/d/1vbCfxM_akezcLdmvxRtgcGKmWH44Ju6m/edit

4. Pull and explore the code for the packages linking **Atlantis** and **calibrar**:  
   - https://github.com/alaiam/Atlantis_Calibration  
   - https://github.com/alaiam/atlantis2ls

5. Explore the **calibrar** package and associated publication:  
   https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.14452
   
   