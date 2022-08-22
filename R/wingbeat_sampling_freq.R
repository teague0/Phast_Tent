## At what resolution can we detect changes in wingbeat frequency?

lens <- 3:6#seq(10, 50, by = 5)
cycles <- 15:50
i = 2
j = 10
#for(i in 1:length(lens)){
for(j in 1:length(cycles)){
  d <- seq(0,cycles[10]*2*pi, length = cycles[j] * lens[i])+.5
  x <- sin(d)
  plot(d,x, type = "o")
  
  s <- localMaxima(x)
  # length(s) %>% print
  dd <- diff(d[s])
  hist(dd, breaks = 100)
  hz <- 1/((dd))
  round(sd(hz),4)
  print(paste0("sampling: ", round(mean(diff(s)), 2), 
               # ", Hz: Q1_", round(summary(hz)[2],4), 
               ", Period Mean:", round(summary(dd)[4],2), 
               # " Q3_", round(summary(hz)[5],4),
                     #round(hz,4), 
               ", sd: ", round(sd(dd),2)))  
}


plot(d,x, type = "o")

x1 <- sin(seq(0,10*pi,length = 100))
s1 <- localMaxima(x1)
hz1 <- 1/(mean(diff(s1)))
hz1

x2 <- sin(seq(0,10*pi,length = 200))
s2 <- localMaxima(x2)
hz2 <- 1/(mean(diff(s2)))
hz2

# simulate a change in frequencies

# how much would we expect a bat's wingbeat frequency to change during the night?

m2 = (f2/f1)^2*m1
m2/m1 = (f2/f1)^2
sqrt(m2/m1) = f2/f1
sqrt(m2/m1)*f1 = f2

m1 = 100
m2 = 120
f1 = 6
sqrt(m2/m1)*f1 # 6.57

f1 = 6.25
f2 = 8.3
m1 = 100
m2 = (f2/f1)^2*m1


library(pacman)
p_load(stats)

x <- 1:4
fft(x)
fft(fft(x), inverse = TRUE)/length(x)

## Slow Discrete Fourier Transform (DFT) - e.g., for checking the formula
fft0 <- function(z, inverse=FALSE) {
  n <- length(z)
  if(n == 0) return(z)
  k <- 0:(n-1)
  ff <- (if(inverse) 1 else -1) * 2*pi * 1i * k/n
  vapply(1:n, function(h) sum(z * exp(ff*(h-1))), complex(1))
}

relD <- function(x,y) 2* abs(x - y) / abs(x + y)
n <- 2^8
z <- complex(n, rnorm(n), rnorm(n))
# }
# NOT RUN {
## relative differences in the order of 4*10^{-14} :
summary(relD(fft(z), fft0(z)))
summary(relD(fft(z, inverse=TRUE), fft0(z, inverse=TRUE)))
# }

# http://www.di.fc.ul.pt/~jpn/r/fourier/fourier.html