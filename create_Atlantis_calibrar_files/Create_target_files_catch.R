# Script to catch target for calibrar #

# Package and function#

library(ncdf4)
library(dplyr)
meanNA <- function(x){return(mean(x, na.rm = T))}


# Open initial condition #
input_path  = "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/"
output_path = "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/data_catch/"
dt.timeseries = 5

# 
row_data <- read.csv(paste0(input_path, "PS_catch_2011-2019.csv"))

total_catch_sp <- row_data %>%
  group_by(Name, year, Code)%>%
  mutate(catch_tons=sum(catch_tons))%>%
  distinct(catch_tons)%>%
  ungroup()

par(mfrow = c(4,5), mar = c(2,2,2,2))
for (i in unique(total_catch_sp$Name)){
  a <- total_catch_sp[total_catch_sp$Name==i,]
  plot(a$year, a$catch_tons, ylim = c(0, max(a$catch_tons)),
       main = unique(a$Code))
  ablines= mean(a$catch_tons)
  print(a$Name)
  print(mean(a$catch_tons))
  print(median(a$catch_tons))
}


for (i in unique(total_catch_sp$Name)){
    catch = median(total_catch_sp[total_catch_sp$Name==i,]$catch_tons)
    data = data.frame(Time = 1:dt.timeseries, Catch = rep(catch, dt.timeseries))
    write.csv(data,paste0(output_path, i,"_catch.csv"), row.names = F)
}



##################
# Create calibration setting file
##################

# Prepare the variable
files = list.files(output_path)
variable = paste0(unique(total_catch_sp$Name), "_catch")
varid = rep("Catch", length(unique(total_catch_sp$Name)))


# Prepare the file
settings <- data.frame(
  variable = variable,
  type = rep("lnorm2", length(unique(total_catch_sp$Name))),
  calibrate = rep(TRUE, length(unique(total_catch_sp$Name))),
  weight = rep(2, length(unique(total_catch_sp$Name))),
  use_data = rep(TRUE, length(unique(total_catch_sp$Name))),
  file = paste0("data/",unique(total_catch_sp$Name), "_catch.csv"),
  varid = varid)


write.csv(settings,
          "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/calibration_settings_catch.csv",
          row.names = F)


####################################################

##################
# Create code for runModel function
##################
R_code <- c()

for (i in 1:(length(varid))){
  if (grepl("_catch$", variable[i])){
    name = sub("_catch", "", variable[i])
    
    line <- paste0(variable[i], ' = unname(unlist(atlantis.catch["')
    line <- paste0(line, sub("_catch", "",name), '"])), ')
    
    R_code <- c(R_code, line)
    
  }
}


writeLines(R_code, con =
             "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/catch.txt")

R_code <- c()

for (i in 1:length(varid)){
  
  line <- paste0(variable[i], ' = rep(0,',dt.timeseries,'), ')
  
  R_code <- c(R_code, line)
}


writeLines(R_code, con =
             "C:/Users/Alaia/Desktop/Postdoc/PS/Calibration/Create_target_files/catch_crach.txt")



##################
# Create parameter files
##################

# F is called mFC in Atlantis --> code handled by the Create_target_files_biomass code
# that handled this part for all parameters


