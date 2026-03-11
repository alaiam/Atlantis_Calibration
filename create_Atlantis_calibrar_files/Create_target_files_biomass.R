# Script to use the initial condition and transform it into a target for calibrar #

# Package and function#

library(ncdf4)
meanNA <- function(x){return(mean(x, na.rm = T))}


# Open initial condition #
input_path  = "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/"
output_path = "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/data/"
initial.condi <- nc_open(paste0(input_path, "/AMPS.nc"))
config <- read.csv(paste0(input_path, "/PugetSoundAtlantisFunctionalGroups_2024.csv"))
initial.condi <- read.table(paste0(input_path, "/AMPS_OUTBiomIndx.txt"))
repro.option <- read.csv(paste0(input_path, "/reproduction-option.csv"))

dt.timeseries = 5

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
Bio.ini <- merge(Bio.ini, config[,c(1,4,34)], by = "Code")



# Biomass #
for (i in 1:length(Bio.ini$Name)){
  if (Bio.ini$IsCalibrated[i] == 1){
    biomass = Bio.ini$Ini[i]
    data = data.frame(Time = 1:dt.timeseries, Biomass = rep(biomass, dt.timeseries))
    write.csv(data,paste0(output_path, Bio.ini$Code[i],"_biomass.csv"), row.names = F)
  }
}


##################
# Create calibration setting file
##################
Bio.ini <- Bio.ini[Bio.ini$IsCalibrated==1,]

# Prepare the variable
files = list.files(output_path)
variable = paste0(Bio.ini$Name, "_biomass")
varid = rep("Biomass", length(Bio.ini$Name))


# Prepare the file
settings <- data.frame(
  variable = variable,
  type = rep("lnorm2", length(Bio.ini$Name)),
  calibrate = rep(TRUE, length(Bio.ini$Name)),
  weight = rep(1, length(Bio.ini$Name)),
  use_data = rep(TRUE, length(Bio.ini$Name)),
  file = paste0("data/",Bio.ini$Name, "_biomass.csv"),
  varid = varid
)


write.csv(settings,
          "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/calibration_settings.csv",
          row.names = F)


####################################################

##################
# Create code for runModel function
##################
R_code <- c()

for (i in 1:(length(varid)-1)){
  if (grepl("_biomass$", variable[i])){
    name = sub("_biomass", "", variable[i])

    line <- paste0(variable[i], ' = unname(atlantis.biomass["')
    line <- paste0(line, sub("_biomass", "",name), '"]), ')

    R_code <- c(R_code, line)

  }
}


writeLines(R_code, con =
             "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/biomass.txt")

R_code <- c()

for (i in 1:length(varid)){

  line <- paste0(variable[i], ' = rep(0,',dt.timeseries,'), ')

  R_code <- c(R_code, line)
}


writeLines(R_code, con =
             "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/biomass_crach.txt")



##################
# Create parameter files
##################

# mum
names = paste0("mum_",Bio.ini$Code,"_factor")
param <- data.frame(
  names = names,
  paropt = rep(0, (length(Bio.ini$Code))),
  parmin = rep(-1, (length(Bio.ini$Code))),
  parmax = rep(1, (length(Bio.ini$Code))),
  parphase = rep(1, (length(Bio.ini$Code)))
)

## Reproductive parameters

Bio.ini_repro <- merge(Bio.ini, repro.option, by = "Code")
Bio.ini <- merge(Bio.ini, config[,c("Code", "IsFished")], by = "Code")

#BHalpha
names = paste0("BHalpha_",Bio.ini_repro$Code[Bio.ini_repro$flagrecruit!=12],"_factor")
param2 <- data.frame(
  names = names,
  paropt = rep(0, length(names)),
  parmin = rep(-1, length(names)),
  parmax = rep(1, length(names)),
  parphase = rep(1, length(names))
)

calib.param <- rbind(param, param2)

#KDENR
names = paste0("KDENR_",Bio.ini$Code[Bio.ini$flagrecruit==12],"_factor")
param2 <- data.frame(
  names = names,
  paropt = rep(0, length(names)),
  parmin = rep(-1, length(names)),
  parmax = rep(1, length(names)),
  parphase = rep(1, length(names))
)

calib.param <- rbind(calib.param, param2)

#mfc
names = paste0("mfc_",Bio.ini$Code[Bio.ini$IsFished==1],"_factor")
param2 <- data.frame(
  names = names,
  paropt = rep(0, length(names)),
  parmin = rep(-1, length(names)),
  parmax = rep(1, length(names)),
  parphase = rep(1, length(names))
)

calib.param <- rbind(calib.param, param2)

# mQ

names = paste0(c("ZS", "ZM", "ZL"),"_mQ_factor")
param2 <- data.frame(
  names = names,
  paropt = rep(0, length(names)),
  parmin = rep(-1, length(names)),
  parmax = rep(1, length(names)),
  parphase = rep(1, length(names))
)

calib.param <- rbind(calib.param, param2)


write.csv(calib.param,
          "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/calibration-parameters-complete.csv",
          row.names = F)
