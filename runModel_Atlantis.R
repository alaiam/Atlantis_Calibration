

#' Sample runModel function for Atlantis. It writes the calibrated
#' param (\code{param} argument) into a CSV file that will
#' overwrite the atlantis forcing files.
#' @param Parameter array.
#' @param Parameter names
#' @return A list containing all the variables
#' used in the calibration
runModel  = function(param, names, ...) {

    # set parameter names
    names(param) = names
    write.table(param, file="calibration-parameters.csv", sep=",",
                col.names=FALSE, quote=FALSE)
    mum.factor = grep(x=names, pattern="mum")
    BHalpha.factor = grep(x=names, pattern="BHalpha")
    mq.factor = grep(x=names, pattern="mQ")
    bio.prm = "AMPSbioparam_mv1_2024_V4.prm"
    bio.lines = readLines(bio.prm)

    for (i in 1:length(mum.factor)){
      species <- names[mum.factor[i]]
      factor  <- param[mum.factor[i]]
      species <- sub("mum_", "", species)
      species <- sub("_factor", "", species)

      bio.lines = edit_param_mum_sp(bio.lines, factor, species)
    }
    for (i in 1:length(BHalpha.factor)){
      species <- names[BHalpha.factor[i]]
      factor  <- param[BHalpha.factor[i]]
      species <- sub("BHalpha_", "", species)
      species <- sub("_factor", "", species)
      
      bio.lines = edit_param_BHalpha_sp(bio.lines, factor, species)
    }
    
    for (i in 1:length(mq.factor)){
      species <- names[mq.factor[i]]
      factor  <- param[mq.factor[i]]
      species <- sub("_mQ_factor", "", species)
      bio.lines = atlantis2ls::edit_param_mq_sp(bio.lines, factor, species)
    }
    writeLines(bio.lines, "bio.prm")

    #TODO: Improve biomass function
    #TODO: replace for loop


path = getwd()

##########################################################################################
    # run Atlantis
    sh.file = "amps_cal.sh"
    run_atlantis(path = path, sh.file = sh.file)


##########################################################################################
    # read Atlantis outputs
    # path = "/home/atlantis/psatlantismodel/Atlantis_Calibration/RUN/i21"

    prefix = "outputFolder/AMPS"
    bio.prm = "AMPSbioparam_mv1_2024_V4.prm"
    fg.file <- paste0(path,"/PugetSoundAtlantisFunctionalGroups_2024.csv")
    
    log_file <- "parallel_log_read_atlantis.txt"

    
    # library(ncdf4)
    # nc <- ncdf4::nc_open(paste0(path, "/outputFolder/AMPS_OUT.nc"))
    # volumes <- ncdf4::ncvar_get(nc, "volume")
    # volumes_arr <- array(data = unlist(volumes),dim = dim(volumes)[c(1,2)]) # box/layer volumes
    # 
    outputs <- read_atlantis(path = path, prefix = prefix, fg.file = fg.file, 
                             txt.filename = "outputFolder/AMPS_OUTBiomIndx.txt")

    
    
    
    
    # extract the biomass, abundance, waa variables
    atlantis.biomass = outputs$biomass
    # atlantis.abundance = outputs$abundance
    # atlantis.meanSizeByAge = outputs$waa
      
##########################################################################################
    # Check if the configuration has run
    # Find a way to return 0 if does not work


##########################################################################################
# Process the outputs so that calibrar like them
    if(length(atlantis.biomass)==2){
      output = list(
      MA_biomass = rep(0,2), 
      SG_biomass = rep(0,2), 
      ZS_biomass = rep(0,2), 
      ZM_biomass = rep(0,2), 
      ZL_biomass = rep(0,2), 
      ZG_biomass = rep(0,2), 
      AUR_biomass = rep(0,2), 
      SQX_biomass = rep(0,2), 
      BMD_biomass = rep(0,2), 
      BD_biomass = rep(0,2), 
      BG_biomass = rep(0,2), 
      BMS_biomass = rep(0,2), 
      DUN_biomass = rep(0,2), 
      BML_biomass = rep(0,2), 
      PWN_biomass = rep(0,2), 
      BFF_biomass = rep(0,2), 
      BIV_biomass = rep(0,2), 
      GEC_biomass = rep(0,2), 
      BC_biomass = rep(0,2), 
      HEP_biomass = rep(0,2), 
      HEC_biomass = rep(0,2), 
      FPS_biomass = rep(0,2), 
      POP_biomass = rep(0,2), 
      CHY_biomass = rep(0,2), 
      CHS_biomass = rep(0,2), 
      CSY_biomass = rep(0,2), 
      CSS_biomass = rep(0,2), 
      CSN_biomass = rep(0,2), 
      CDS_biomass = rep(0,2), 
      CNY_biomass = rep(0,2), 
      CNS_biomass = rep(0,2), 
      CHC_biomass = rep(0,2), 
      CYE_biomass = rep(0,2), 
      CKS_biomass = rep(0,2), 
      CRH_biomass = rep(0,2), 
      CRW_biomass = rep(0,2), 
      CRC_biomass = rep(0,2), 
      COH_biomass = rep(0,2), 
      COS_biomass = rep(0,2), 
      COD_biomass = rep(0,2), 
      COY_biomass = rep(0,2), 
      COR_biomass = rep(0,2), 
      CDR_biomass = rep(0,2), 
      CMS_biomass = rep(0,2), 
      CMF_biomass = rep(0,2), 
      CMH_biomass = rep(0,2), 
      PIS_biomass = rep(0,2), 
      SAL_biomass = rep(0,2), 
      SAF_biomass = rep(0,2), 
      FMM_biomass = rep(0,2), 
      FVS_biomass = rep(0,2), 
      ROC_biomass = rep(0,2), 
      MRO_biomass = rep(0,2), 
      DVR_biomass = rep(0,2), 
      MVR_biomass = rep(0,2), 
      SMD_biomass = rep(0,2), 
      FDF_biomass = rep(0,2), 
      HAP_biomass = rep(0,2), 
      DOG_biomass = rep(0,2), 
      SBL_biomass = rep(0,2), 
      SSK_biomass = rep(0,2), 
      RAT_biomass = rep(0,2), 
      SB_biomass = rep(0,2), 
      SP_biomass = rep(0,2), 
      BE_biomass = rep(0,2), 
      HSL_biomass = rep(0,2), 
      CSL_biomass = rep(0,2), 
      PIN_biomass = rep(0,2), 
      PHR_biomass = rep(0,2), 
      ROR_biomass = rep(0,2), 
      TOR_biomass = rep(0,2), 
      HUW_biomass = rep(0,2))

    }else{
output = list(

      # Biomass
      MA_biomass = unname(unlist(atlantis.biomass["Macroalgae"])), 
      SG_biomass = unname(unlist(atlantis.biomass["Seagrass"])), 
      ZS_biomass = unname(unlist(atlantis.biomass["Micro_Zoo"])), 
      ZM_biomass = unname(unlist(atlantis.biomass["Meso_Zoo"])), 
      ZL_biomass = unname(unlist(atlantis.biomass["Lrg_Zoo"])), 
      ZG_biomass = unname(unlist(atlantis.biomass["Gel_Zoo"])), 
      AUR_biomass = unname(unlist(atlantis.biomass["Aurelia"])), 
      SQX_biomass = unname(unlist(atlantis.biomass["Squid"])), 
      BMD_biomass = unname(unlist(atlantis.biomass["Macrobenth_Deep"])), 
      BD_biomass = unname(unlist(atlantis.biomass["Deposit_Feeder"])), 
      BG_biomass = unname(unlist(atlantis.biomass["Benthic_grazer"])), 
      BMS_biomass = unname(unlist(atlantis.biomass["Octopi"])), 
      DUN_biomass = unname(unlist(atlantis.biomass["Dungeness"])), 
      BML_biomass = unname(unlist(atlantis.biomass["Crab"])), 
      PWN_biomass = unname(unlist(atlantis.biomass["Shrimp"])), 
      BFF_biomass = unname(unlist(atlantis.biomass["Filter_Other"])), 
      BIV_biomass = unname(unlist(atlantis.biomass["Bivalve"])), 
      GEC_biomass = unname(unlist(atlantis.biomass["Geoduck"])), 
      BC_biomass = unname(unlist(atlantis.biomass["Carn_Infauna"])), 
      HEP_biomass = unname(unlist(atlantis.biomass["Herring_PS"])), 
      HEC_biomass = unname(unlist(atlantis.biomass["Herring_Cherry"])), 
      FPS_biomass = unname(unlist(atlantis.biomass["Sm_Plank_Fish"])), 
      POP_biomass = unname(unlist(atlantis.biomass["Perch_Fish"])), 
      CHY_biomass = unname(unlist(atlantis.biomass["ChinookY_Fish"])), 
      CHS_biomass = unname(unlist(atlantis.biomass["ChinookSY_Fish"])), 
      CSY_biomass = unname(unlist(atlantis.biomass["ChinookSKY_Fish"])), 
      CSS_biomass = unname(unlist(atlantis.biomass["ChinookSKSY_Fish"])), 
      CSN_biomass = unname(unlist(atlantis.biomass["ChinookSSY_Fish"])), 
      CDS_biomass = unname(unlist(atlantis.biomass["ChinookDSY_Fish"])), 
      CNY_biomass = unname(unlist(atlantis.biomass["ChinookNY_Fish"])), 
      CNS_biomass = unname(unlist(atlantis.biomass["ChinookNSY_Fish"])), 
      CHC_biomass = unname(unlist(atlantis.biomass["ChinookHY_Fish"])), 
      CYE_biomass = unname(unlist(atlantis.biomass["ChinookOY_Fish"])), 
      CKS_biomass = unname(unlist(atlantis.biomass["ChinookOSY_Fish"])), 
      CRH_biomass = unname(unlist(atlantis.biomass["ChinookResH_Fish"])), 
      CRW_biomass = unname(unlist(atlantis.biomass["ChinookResN_Fish"])), 
      CRC_biomass = unname(unlist(atlantis.biomass["ChinookResW_Fish"])), 
      COH_biomass = unname(unlist(atlantis.biomass["CohoHY_Fish"])), 
      COS_biomass = unname(unlist(atlantis.biomass["CohoSY_Fish"])), 
      COD_biomass = unname(unlist(atlantis.biomass["CohoDSY_Fish"])), 
      COY_biomass = unname(unlist(atlantis.biomass["CohoOY_Fish"])), 
      COR_biomass = unname(unlist(atlantis.biomass["CohoRes_Fish"])), 
      CDR_biomass = unname(unlist(atlantis.biomass["CohoResD_Fish"])), 
      CMS_biomass = unname(unlist(atlantis.biomass["ChumHSY_Fish"])), 
      CMF_biomass = unname(unlist(atlantis.biomass["ChumFSY_Fish"])), 
      CMH_biomass = unname(unlist(atlantis.biomass["ChumHCSY_Fish"])), 
      PIS_biomass = unname(unlist(atlantis.biomass["PinkSY_Fish"])), 
      SAL_biomass = unname(unlist(atlantis.biomass["OtherSal_Fish"])), 
      SAF_biomass = unname(unlist(atlantis.biomass["SGeorgia_Fish"])), 
      FMM_biomass = unname(unlist(atlantis.biomass["Gadiods_Fish"])), 
      FVS_biomass = unname(unlist(atlantis.biomass["LgDem_Fish"])), 
      ROC_biomass = unname(unlist(atlantis.biomass["DemRock_Fish"])), 
      MRO_biomass = unname(unlist(atlantis.biomass["MidRock_Fish"])), 
      DVR_biomass = unname(unlist(atlantis.biomass["DemVRock_Fish"])), 
      MVR_biomass = unname(unlist(atlantis.biomass["MidVRock_Fish"])), 
      SMD_biomass = unname(unlist(atlantis.biomass["SmDem_Fish"])), 
      FDF_biomass = unname(unlist(atlantis.biomass["SmFlat_Fish"])), 
      HAP_biomass = unname(unlist(atlantis.biomass["PiscFlat_Fish"])), 
      DOG_biomass = unname(unlist(atlantis.biomass["Spinydog_Fish"])), 
      SBL_biomass = unname(unlist(atlantis.biomass["Sixgill_Shark"])), 
      SSK_biomass = unname(unlist(atlantis.biomass["SkateRay"])), 
      RAT_biomass = unname(unlist(atlantis.biomass["Ratfish"])), 
      SB_biomass = unname(unlist(atlantis.biomass["Pisc_Seabird"])), 
      SP_biomass = unname(unlist(atlantis.biomass["NonPisc_Seabird"])), 
      BE_biomass = unname(unlist(atlantis.biomass["Raptors"])), 
      HSL_biomass = unname(unlist(atlantis.biomass["Harbor_seal"])), 
      CSL_biomass = unname(unlist(atlantis.biomass["California_sea_lion"])), 
      PIN_biomass = unname(unlist(atlantis.biomass["Pinniped"])), 
      PHR_biomass = unname(unlist(atlantis.biomass["Porpoise"])), 
      ROR_biomass = unname(unlist(atlantis.biomass["Res_Orca"])), 
      TOR_biomass = unname(unlist(atlantis.biomass["Trans_Orca"])), 
      HUW_biomass = unname(unlist(atlantis.biomass["Hump_whale"])) 


      # Thr
      # Sm_Plank_Fish.Thr = atlantis.biomass["Sm_Plank_Fish"],
      # Gadiods_Fish.Thr = atlantis.biomass["Gadiods_Fish"],
      # Raptors.Thr = atlantis.biomass["Raptors"],
      # Trans_Orcas.Thr = atlantis.biomass["Trans_Orcas"],
      # Sm_Phyto.Thr = atlantis.biomass["Sm_Phyto"],
      # Lrg_Phyto.Thr = atlantis.biomass["Lrg_Phyto"],
      # Micro_Zoo.Thr = atlantis.biomass["Micro_Zoo"],
      # Meso_Zoo.Thr = atlantis.biomass["Meso_Zoo"],
      # Lrg_Zoo.Thr = atlantis.biomass["Lrg_Zoo"],
      # Gel_Zoo.Thr = atlantis.biomass["Gel_Zoo"],
      # Macroalgae.Thr = atlantis.biomass["Macroalgae"],
      # Seagrass.Thr = atlantis.biomass["Seagrass"],
      # Bivalve.Thr = atlantis.biomass["Bivalve"],
      # Sed_Bact.Thr = atlantis.biomass["Sed_Bact"],
      # Pelag_Bact.Thr = atlantis.biomass["Pelag_Bact"],


      # Landings
      # Sm_Plank_Fish.landings = atlantis.landings["Sm_Plank_Fish"],
      # Gadiods_Fish.landings = atlantis.landings["Gadiods_Fish"],
      # Meso_Zoo.landings = atlantis.landings["Meso_Zoo"],
      # Lrg_Zoo.landings = atlantis.landings["Lrg_Zoo"],
      # Macroalgae.landings = atlantis.landings["Macroalgae"],
      # Seagrass.landings = atlantis.landings["Seagrass"],
      # Bivalve.landings = atlantis.landings["Bivalve"],


      # #Abundance
      # Sm_Plank_Fish.abundance = atlantis.abundance["Sm_Plank_Fish"],
      # Gadiods_Fish.abundance  = atlantis.abundance["Gadiods_Fish"],
      # Raptors.abundance  = atlantis.abundance["Raptors"],
      # Trans_Orcas.abundance = atlantis.abundance["Trans_Orcas"],


      # Waa Sm_Plank_Fish
      # Sm_Plank_Fish.meanSizeByAge1 = atlantis.meanSizeByAge["Sm_Plank_Fish1_StructN"],
      # Sm_Plank_Fish.meanSizeByAge2 = atlantis.meanSizeByAge["Sm_Plank_Fish2_StructN"],
      # Sm_Plank_Fish.meanSizeByAge3 = atlantis.meanSizeByAge["Sm_Plank_Fish3_StructN"],
      # Sm_Plank_Fish.meanSizeByAge4 = atlantis.meanSizeByAge["Sm_Plank_Fish4_StructN"],
      # Sm_Plank_Fish.meanSizeByAge5 = atlantis.meanSizeByAge["Sm_Plank_Fish5_StructN"],
      # Sm_Plank_Fish.meanSizeByAge6 = atlantis.meanSizeByAge["Sm_Plank_Fish6_StructN"],
      # Sm_Plank_Fish.meanSizeByAge7 = atlantis.meanSizeByAge["Sm_Plank_Fish7_StructN"],
      # Sm_Plank_Fish.meanSizeByAge8 = atlantis.meanSizeByAge["Sm_Plank_Fish8_StructN"],
      # 
      # 
      # 
      # # Waa Gadiods_Fish
      # Gadiods_Fish.meanSizeByAge1 = atlantis.meanSizeByAge["Gadiods_Fish1_StructN"],
      # Gadiods_Fish.meanSizeByAge2 = atlantis.meanSizeByAge["Gadiods_Fish2_StructN"],
      # Gadiods_Fish.meanSizeByAge3 = atlantis.meanSizeByAge["Gadiods_Fish3_StructN"],
      # Gadiods_Fish.meanSizeByAge4 = atlantis.meanSizeByAge["Gadiods_Fish4_StructN"],
      # Gadiods_Fish.meanSizeByAge5 = atlantis.meanSizeByAge["Gadiods_Fish5_StructN"],
      # Gadiods_Fish.meanSizeByAge6 = atlantis.meanSizeByAge["Gadiods_Fish6_StructN"],
      # Gadiods_Fish.meanSizeByAge7 = atlantis.meanSizeByAge["Gadiods_Fish7_StructN"],
      # Gadiods_Fish.meanSizeByAge8 = atlantis.meanSizeByAge["Gadiods_Fish8_StructN"],
      # Gadiods_Fish.meanSizeByAge9 = atlantis.meanSizeByAge["Gadiods_Fish9_StructN"],
      # Gadiods_Fish.meanSizeByAge10 = atlantis.meanSizeByAge["Gadiods_Fish10_StructN"],
      # 
      # 
      # # Waa Raptors
      # Raptors.meanSizeByAge1 = atlantis.meanSizeByAge["Raptors1_StructN"],
      # Raptors.meanSizeByAge2 = atlantis.meanSizeByAge["Raptors2_StructN"],
      # Raptors.meanSizeByAge3 = atlantis.meanSizeByAge["Raptors3_StructN"],
      # Raptors.meanSizeByAge4 = atlantis.meanSizeByAge["Raptors4_StructN"],
      # Raptors.meanSizeByAge5 = atlantis.meanSizeByAge["Raptors5_StructN"],
      # Raptors.meanSizeByAge6 = atlantis.meanSizeByAge["Raptors6_StructN"],
      # Raptors.meanSizeByAge7 = atlantis.meanSizeByAge["Raptors7_StructN"],
      # Raptors.meanSizeByAge8 = atlantis.meanSizeByAge["Raptors8_StructN"],
      # Raptors.meanSizeByAge9 = atlantis.meanSizeByAge["Raptors9_StructN"],
      # Raptors.meanSizeByAge10 = atlantis.meanSizeByAge["Raptors10_StructN"],
      # 
      # # Waa Trans orcas
      # Trans_Orcas.meanSizeByAge1 = atlantis.meanSizeByAge["Trans_Orcas1_StructN"],
      # Trans_Orcas.meanSizeByAge2 = atlantis.meanSizeByAge["Trans_Orcas2_StructN"],
      # Trans_Orcas.meanSizeByAge3 = atlantis.meanSizeByAge["Trans_Orcas3_StructN"],
      # Trans_Orcas.meanSizeByAge4 = atlantis.meanSizeByAge["Trans_Orcas4_StructN"],
      # Trans_Orcas.meanSizeByAge5 = atlantis.meanSizeByAge["Trans_Orcas5_StructN"],
      # Trans_Orcas.meanSizeByAge6 = atlantis.meanSizeByAge["Trans_Orcas6_StructN"],
      # Trans_Orcas.meanSizeByAge7 = atlantis.meanSizeByAge["Trans_Orcas7_StructN"],
      # Trans_Orcas.meanSizeByAge8 = atlantis.meanSizeByAge["Trans_Orcas8_StructN"],
      # Trans_Orcas.meanSizeByAge9 = atlantis.meanSizeByAge["Trans_Orcas9_StructN"],
      # Trans_Orcas.meanSizeByAge10 = atlantis.meanSizeByAge["Trans_Orcas10_StructN"]
      )




    }
    return(output)

}
