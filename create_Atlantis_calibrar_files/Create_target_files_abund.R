# Script to use the initial condition and transform it into a target for calibrar #

# Package #

library(ncdf4)
sumNA <- function(x){return(sum(x, na.rm = T))}


# Open initial condition #
initial.condi <- nc_open("C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/AMPS_2024.nc")
path = "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/data/"
dt.timeseries = 10


##################
# Create data file
##################

var <- names(initial.condi$var)
list.nums <- list()

# Waa #

for (i in 1:length(var)){
  if (grepl("_Nums$", var[i])){
    Nums = sumNA(ncvar_get(initial.condi, var[i]))
    list.nums[[var[i]]] <- Nums
  }
}
species <- unique(gsub("([a-zA-Z]+)[0-9]+_Nums", "\\1", names(list.nums)))

for (i in 1:length(species)){
  age.class.max = sum(species[i]==gsub("([a-zA-Z]+)[0-9]+_Nums", "\\1", names(list.nums)))
  vector.abund <- rep(0,age.class.max)
  for (j in 1:age.class.max){
    vector.abund[j] <- list.nums[[paste0(species[i],j, "_Nums")]]
  }
  vector.abund[vector.abund==0]<-NA
  calibrar.format <- array( rep(0,dt.timeseries*(age.class.max+1)), dim = c(dt.timeseries,age.class.max+1))
  calibrar.format <- as.data.frame(calibrar.format)
  names(calibrar.format) <- c("Time", 1:age.class.max)
  calibrar.format$Time <- 1:dt.timeseries
  for (j in 1:dt.timeseries){
    calibrar.format[j,-1] <- vector.abund
  }
  write.csv(calibrar.format, paste0("data/", species[i], "_Nums.csv"), row.names = F)
}


####################################################

##################
# Create calibration setting file
##################


# Prepare the variable
files = list.files(path)
files = files[grep("_Nums.csv$", files)]
variable = sub(".csv$", "", files)
varid = rep("Abundance", length(files))

# Prepare the file
settings <- data.frame(
  variable = variable,
  type = rep("multinom", length(files)),
  calibrate = rep(TRUE, length(files)),
  weight = rep(1, length(files)),
  use_data = rep(TRUE, length(files)),
  file = paste0("data/",files),
  varid = NA
)


write.csv(settings,
          "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/calibration_settings_abund.csv",
          row.names = F)


####################################################

##################
# Create code for runModel function
##################
R_code <- c()

for (i in 1:length(varid)){
  if (i<length(varid)){
    a <- sub("_w", "",variable[i])
    b <- sub("_w", "",variable[i+1])
    a <- substr(a,1,nchar(a)-1)
    b <- substr(b ,1,nchar(b)-1)
    add.line = (a!=b)
  }

  if (add.line){
    line <- paste0(variable[i], ' = unname(unlist(atlantis.meanSizeByAge["')
    line <- paste0(line, sub("_w", "",variable[i]), '"])), \n')
    R_code <- c(R_code, line)
  }else{

    line <- paste0(variable[i], ' = unname(unlist(atlantis.meanSizeByAge["')
    line <- paste0(line, sub("_w", "",variable[i]), '"])),')
    R_code <- c(R_code, line)
  }


}


writeLines(R_code, con =
             "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/Waa.txt")


#### Waa crash
R_code <- c()

for (i in 1:length(varid)){

    line <- paste0(variable[i], ' = rep(0,',dt.timeseries,'), ')

    R_code <- c(R_code, line)
}


writeLines(R_code, con =
             "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/Waa_crach.txt")

