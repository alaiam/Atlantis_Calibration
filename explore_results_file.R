a <- readRDS('restart_file.results')
par(mfrow = c(1,2))

gen <- length((a$trace$best))

plot(0:gen, c(6500, a$trace$fitness), type = "l", lwd = 2, xlab = "Generations", ylab = "Objective function value")
plot(0:gen, c(1, a$trace$par[,1]), type = "l", col = "darkorange", ylim = c(0.25,2.5), lwd = 2, xlab = "Generations", ylab = "Parameter factor")

for (i in 1:39){
  lines(0:gen, c(1, a$trace$par[,3*(i-1)+1]), type = "l", col = "darkorange", lwd = 2)
  lines(0:gen, c(1, a$trace$par[,3*(i-1)+2]), col = "red", lwd = 2)
  lines(0:gen, c(1, a$trace$par[,3*(i-1)+3]), col = "darkred", lwd = 2)
  
}

# legend("bottomright", 
#        legend = c("Parameter 1 (mQ_SZ)", "Parameter 2 (mQ_MZ)", "Parameter 3 (mQ_LZ)"), 
#        col = c("darkorange", "red", "darkred"), 
#        lwd = 2, 
#        bty = "n")

