rm(list=ls())

library(calibrar)
library(stringr)
# #set config
# usethis::use_git_config(user.name = "alaiam", user.email = "alaia.morell@gmail.com")
# 
# #Go to github page to generate token
# usethis::create_github_token() 
# 
# #paste your PAT into pop-up that follows...
# credentials::set_github_pat()

require("atlantis2ls")
require("calibrar")
# devtools::install_github("alaiam/atlantis2ls")
# Need to load the doSNOW package, which is installed in my HOME: /home1/datahome/nbarrier/libs/R/lib
require("doSNOW")

setwd("/home/atlantis/psatlantismodel/Atlantis_Calibration/")

source("runModel_Atlantis.R")

# creates a user defined likelihood function
minmaxt = function(obs, sim) {
  output = -1e+6*sum(log(pmin((sim+1)/(obs[, 1]+1), 1)), na.rm=TRUE) + 
    1e+6*sum(log(pmax((sim+1)/(obs[, 2]+1), 1)), na.rm=TRUE)
  return(output)
}

# reads calibration informations
setup = calibration_setup(file="calibration_settings.csv") 
observed = calibration_data(setup = setup,
                           path=".", 
                           file = NULL, 
                           sep = ",")

# load calibration parameters
forcing = read.csv(file="calibration-parameters-complete.csv", 
                     header=TRUE, 
                     sep=",", 
                     row.names=1)

# create an objective function
# additional arguments to the runModel function
# are provided here.
objfn = calibration_objFn(model=runModel, 
                          setup=setup, 
                          observed=observed, 
                          aggregate=TRUE,
                          forcing = forcing,
                          names=row.names(forcing))

control = list()
control$maxit = c(8)   # maximum number of generations (former gen.max parameter)
control$maxgen = c(8)   # maximum number of generations (former gen.max parameter)
control$master = "/home/atlantis/psatlantismodel/Atlantis_Calibration/master/"   # directory that will be copied
control$run = "/home/atlantis/psatlantismodel/Atlantis_Calibration/RUN"   # run directory
control$restart.file = "/home/atlantis/psatlantismodel/Atlantis_Calibration/restart_file"   # name of the restart file
control$REPORT = 1    # number of generations to run before saving a restart
control$parallel = TRUE
control$nCores = 32
control$popsize = 32  # population  size (former seed parameter)
control$trace = 3 #global fitness and partial fitness

# call the RMPI/Snow make cluster (note here that there are no arguments!)
NumberOfCluster <- control$nCores
cl <-  makeCluster(NumberOfCluster)

# call the registerDoSNOW function instead of the registerDoParallel
registerDoSNOW (cl)

# send the variables and loaded libraries defined in the above to the nodes
clusterExport(cl, c("control","objfn", "forcing", "observed", "setup", "minmaxt"))
clusterEvalQ(cl, library("atlantis2ls"))
clusterEvalQ(cl, library("calibrar"))
clusterEvalQ(cl, library("stringr"))

# run the calibration

lbfgsb1 = calibrate(par=forcing['paropt'], fn=objfn, 
                    method='AHR-ES', 
                    lower=forcing['parmin'],
                    upper=forcing['parmax'],
                    phases=forcing['parphase'], 
                    control=control, parallel = TRUE)

# stop the cluster
stopCluster(cl)


# readRDS('restart_file.restart')
readRDS('restart_file.results')

