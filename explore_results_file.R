a <- readRDS('/home/atlantis/psatlantismodel/Atlantis_Calibration/restart_file.results')
b <- read.csv('/home/atlantis/psatlantismodel/Atlantis_Calibration/calibration-parameters-complete.csv')
par(mfrow = c(1,2))


col <- b$names
col[regexpr("mum", b$names)>0] <- "red"
col[regexpr("KDENR", b$names)>0] <- "darkred"
col[regexpr("BHalpha", b$names)>0] <- "darkorange"
col[regexpr("mQ", b$names)>0] <- "brown"


gen <- length((a$trace$best))

plot(0:gen, c(5200, a$trace$fitness), type = "l", lwd = 2, xlab = "Generations", ylab = "Objective function value")
plot(0:gen, c(0, a$trace$par[,1]), type = "l", col = "brown", ylim = c(-1,1), lwd = 2, xlab = "Generations", ylab = "Parameter factor")




for (i in 1:length(b$names)){
  # if(col[i] == "brown")
  lines(0:gen, c(0, a$trace$par[,i]), type = "l", col = col[i], lwd = 2)
  
}

plot(density(a$trace$par[4,]))
param <- a$trace$par
colnames(param) <- b$names
exp(param)

# legend("bottomright", 
#        legend = c("Parameter 1 (mQ_SZ)", "Parameter 2 (mQ_MZ)", "Parameter 3 (mQ_LZ)"), 
#        col = c("darkorange", "red", "darkred"), 
#        lwd = 2, 
#        bty = "n")

