

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
    mq.factor = grep(x=names, pattern="mQ")
    bio.prm = "AMPSbioparam_mv1_2022.prm"
    bio.lines = readLines(bio.prm)

    edit_param_mq_sp = function(bio.lines, factor, species){

  bio.lines = bio.lines
  pattern = paste0(species,'_mQ')
  bio.lines.id = grep(pattern,bio.lines)
  bio.lines.vals1 = bio.lines[bio.lines.id]
  if (length(bio.lines.vals1)==0) stop("The species does not have a mQ parameter")

  value <- as.numeric(unlist(strsplit(bio.lines.vals1, "\t"))[2])
  if (is.na(value)) stop("The function is not ready yet to deal with mQ vector")
  value <- value*factor
  name <- unlist(strsplit(bio.lines.vals1, "\t"))[1]
  new.line <- paste0(name, "\t", value)
  bio.lines[bio.lines.id] <- new.line

  return(bio.lines)
}
    
    
    for (i in 1:length(mq.factor)){
      species <- names[mq.factor[i]]
      factor  <- param[mq.factor[i]]
      species <- sub("_mQ_factor", "", species)
      bio.lines = edit_param_mq_sp(bio.lines, factor, species)
    }

    writeLines(bio.lines, "bio.prm")

    #TODO: Improve biomass function
    #TODO: replace for loop



##########################################################################################
    # run Atlantis
    sh.file = "amps_cal.sh"
    run_atlantis(path = path, sh.file = sh.file)


##########################################################################################
    # read Atlantis outputs
    path = "outputFolder"
    prefix = "AMPS"
    bio.prm = "AMPSbioparam_mv1_2022.prm"
    fg.file <- "PugetSoundAtlantisFunctionalGroups_salmon_rectype4.csv"
    outputs <- read_atlantis(path = path, prefix = prefix, fg.file = fg.file)

    # extract the biomass, abundance, waa variables
    atlantis.biomass = outputs$biomass
    # atlantis.abundance = outputs$abundance
    # atlantis.meanSizeByAge = outputs$waa
      
##########################################################################################
    # Check if the configuration has run
    # Find a way to return 0 if does not work


##########################################################################################
# Process the outputs so that calibrar like them
    output = list(

      # Biomass
      ZS_biomass = unname(unlist(atlantis.biomass["Micro_Zoo"])), 
      ZM_biomass = unname(unlist(atlantis.biomass["Meso_Zoo"])), 
      ZL_biomass = unname(unlist(atlantis.biomass["Lrg_Zoo"])) 


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

    return(output)

}
