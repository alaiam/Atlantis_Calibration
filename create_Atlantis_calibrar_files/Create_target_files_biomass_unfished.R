# Script to use the initial condition and transform it into a target for calibrar #

# Package and function#

library(ncdf4)
meanNA <- function(x){return(mean(x, na.rm = T))}


# Open initial condition #
input_path  = "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/"
output_path = "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/data_unfished/"
initial.condi <- nc_open(paste0(input_path, "/AMPS.nc"))
config <- read.csv(paste0(input_path, "/PugetSoundAtlantisFunctionalGroups_2024.csv"))
initial.condi <- read.table(paste0(input_path, "/AMPS_OUTBiomIndx.txt"))
repro.option <- read.csv(paste0(input_path, "/reproduction-option.csv"))

dt.timeseries = 2
factor.unfished = 1.3


# Define who is calibrated
config$IsCalibrated <- rep(1, length(config$Code))
not.calibrated = c("PS", "PL", "DC", "DL", "DR")
config$IsCalibrated[config$Code %in% not.calibrated] <- 0

##################
# Create data file
##################

var <- names(initial.condi$var)
Bio.ini = data.frame(Code = unlist(initial.condi[1,2:(length(config$Code)+1)]),
                  Ini = round(as.numeric(unlist(initial.condi[2,2:(length(config$Code)+1)]))))
Bio.ini <- merge(Bio.ini, config[,c(1,4,18,34)], by = "Code")

Bio.ini <- Bio.ini[Bio.ini$IsFished==1,]   # Only Fished Species #




# Biomass #
for (i in 1:length(Bio.ini$Name)){
  if (Bio.ini$IsCalibrated[i] == 1){
    biomass = Bio.ini$Ini[i]
    data = data.frame(Time = 1:dt.timeseries, Biomass = rep(biomass*factor.unfished, dt.timeseries))
    write.csv(data,paste0(output_path, Bio.ini$Code[i],"_biomass.csv"), row.names = F)
  }
}


