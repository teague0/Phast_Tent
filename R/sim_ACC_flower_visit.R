## simulate a pause in flapping
cycles = 15
sampling = 4
s1 <- sin(seq(0, cycles*2*pi, length = cycles*sampling))
plot(s1, type = "o")

pause_duration <- 2*sampling 
pause <- (length(s1)/2):((length(s1)/2)+pause_duration)
sp <- s1
sp[pause] <- sp[pause] * .1 + runif(1, min = -1)
plot(sp, type = "o")

