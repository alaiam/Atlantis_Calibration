rm(list=ls())

# List of packages for session
.packages = c("atlantis2ls","calibrar", "stringr", "doSNOW")
# install.packages(.packages, dependencies = TRUE)
# devtools::install_github("https://github.com/alaiam/atlantis2ls", force = T)

# Load packages into session 
lapply(.packages, require, character.only=TRUE)

setwd("/home/atlantis/psatlantismodel/Atlantis_Calibration_fishing/")

source("runModel_Atlantis.R")

# creates a user defined likelihood function
minmaxt = function(obs, sim) {
  output = -1e+6*sum(log(pmin((sim+1)/(obs[, 1]+1), 1)), na.rm=TRUE) + 
    1e+6*sum(log(pmax((sim+1)/(obs[, 2]+1), 1)), na.rm=TRUE)
  return(output)
}

# reads calibration informations
setup = calibrar::calibration_setup(file="calibration_settings.csv") 
observed = calibrar::calibration_data(setup = setup,
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
objfn = calibrar::calibration_objFn(model=runModel, 
                          setup=setup, 
                          observed=observed, 
                          aggregate=FALSE,
                          forcing = forcing,
                          names=row.names(forcing))

control = list()
control$maxit = c(5)   # maximum number of iterations (former gen.max parameter)
control$maxgen = c(5)   # maximum number of iterations (former gen.max parameter)
control$master = "/home/atlantis/psatlantismodel/Atlantis_Calibration/configuration/"   # directory that will be copied
control$run = "/home/atlantis/psatlantismodel/Atlantis_Calibration/RUN"   # run directory
control$restart.file = "/home/atlantis/psatlantismodel/Atlantis_Calibration/restart_file"   # name of the restart file
control$REPORT = 1    # number of iterations to run before saving a restart
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

lbfgsb1 = calibrar::calibrate(par=forcing['paropt'], fn=objfn, 
                    method='AHR-ES', 
                    lower=forcing['parmin'],
                    upper=forcing['parmax'],
                    phases=forcing['parphase'], 
                    control=control, parallel = TRUE)

# stop the cluster
stopCluster(cl)


# readRDS('restart_file.restart')
a<- readRDS('restart_file.results')
