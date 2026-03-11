# Script to use the initial condition and transform it into a target for calibrar #

# Package #

library(ncdf4)
meanNA <- function(x){return(mean(x, na.rm = T))}


# Open initial condition #
initial.condi <- nc_open("C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/AMPS_2024.nc")
path = "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/data/"
dt.timeseries = 5


##################
# Create data file
##################

var <- names(initial.condi$var)
list.res <- list()

# Waa #

for (i in 1:length(var)){
  if (grepl("_ResN$", var[i])){
    resN = ncatt_get(initial.condi, var[i])$`_FillValue`
    list.res[[var[i]]] <- resN
  }
}

# results[[species_name]] <- value
list.st <- list()

for (i in 1:length(var)){
  if (grepl("_StructN$", var[i])){
    stN = ncatt_get(initial.condi, var[i])$`_FillValue`
    print(var[i])
    print(stN)
    list.st[[var[i]]] <- stN
  }
}

list.weight <- list()
for (i in 1:length(names(list.res))){
  a <- unlist(strsplit(names(list.res)[i], split = "_"))
  a <- a[-length(a)]
  species <- paste(a, collapse = "_")
  list.weight[[species]] <-   (list.res[[paste0(species, "_ResN")]] +
  list.st[[paste0(species, "_StructN")]])*20*5.7/1e6
}



for (i in 1:length(list.weight)){
  name <- paste0(path, names(list.weight[i]), "_w.csv")
  Time = 1:dt.timeseries
  w <- rep(list.weight[i][[1]], dt.timeseries )
  if (list.weight[i][[1]]==0){ print(name)}
  data <- data.frame(Time = Time, Weight = w)
  write.csv(data, name, row.names = F)
}

####################################################

##################
# Create calibration setting file
##################


# Prepare the variable
files = list.files(path)
files = files[grep("_w.csv$", files)]
variable = sub(".csv$", "", files)
varid = rep("Weight", length(files))

# Prepare the file
settings <- data.frame(
  variable = variable,
  type = rep("lnorm2", length(files)),
  calibrate = rep(TRUE, length(files)),
  weight = rep(1, length(files)),
  use_data = rep(TRUE, length(files)),
  file = paste0("data/",files),
  varid = varid
)


write.csv(settings,
          "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/calibration_settings_waa.csv",
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

