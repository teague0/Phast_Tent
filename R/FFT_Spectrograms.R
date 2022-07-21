# plot acc data as spectrogram

pacman::p_load(tuneR, seewave)
x <- sine(400, freq = 4, samp.rate = 4, bit = 32) 
updateWave(x)
plot(x)
?Wave
d <- seq(0,15*2*pi, length = 15 * 40)+.5
x <- sin(d)
plot(d,x, type = "o")
w <- Wave(left = x, samp.rate = 40) 
w %>% plot
spectro(x, wl = 4, f = 4, flim = c(0,100))


data(tico)
# simple plots
spectro(tico,f=22050)

norm <- rep(dnorm(-4000:3999, sd=1000), 2)
plot(norm)
toto <- synth2(env=norm, ifreq=500+(norm/max(norm))*1000, f=8000, plot=TRUE, osc=TRUE, ovlp=85)


pacman::p_load(signal)
data(wav)  # contains wav$rate, wav$sound
acc 
Fs <- wav$rate
step <- trunc(5*Fs/1000)             # one spectral slice every 5 ms
window <- trunc(40*Fs/1000)          # 40 ms data window
fftn <- 2^ceiling(log2(abs(window))) # next highest power of 2
spg <- specgram(wav$sound, fftn, Fs, window, window-step)
S <- abs(spg$S[2:(fftn*4000/Fs),])   # magnitude in range 0<f<=4000 Hz.
S <- S/max(S)         # normalize magnitude so that max is 0 dB.
S[S < 10^(-40/10)] <- 10^(-40/10)    # clip below -40 dB.
S[S > 10^(-3/10)] <- 10^(-3/10)      # clip above -3 dB.
image(t(20*log10(S)), axes = FALSE)  #, col = gray(0:255 / 255))




## The R implementation of these routines can be called "matlab-style",
bf <- butter(5, 0.2)
freqz(bf$b, bf$a)
## or "R-style" as:
freqz(bf)

## make a Chebyshev type II filter:
ch <- cheby2(5, 20, 0.2) 
freqz(ch, Fs = 100)  # frequency plot for a sample rate = 100 Hz

zplane(ch) # look at the poles and zeros

## apply the filter to a signal
t <- seq(0, 1, by = 0.01)                     # 1 second sample, Fs = 100 Hz
x <- sin(2*pi*t*2.3) + 0.25*rnorm(length(t))  # 2.3 Hz sinusoid+noise
z <- filter(ch, x)  # apply filter
plot(t, x, type = "l")
lines(t, z, col = "red")

# look at the group delay as a function of frequency
grpdelay(ch, Fs = 100)

pacman::p_load(hht)
data(PortFosterEvent)

dt <- mean(diff(tt))

ft <- list()
ft$nfft <- 4096
ft$ns <- 30
ft$nov <- 29

time.span <- c(5, 10)
freq.span <- c(0, 25)
amp.span <- c(1e-5, 0.0003)
FTGramImage(sig, dt, ft, time.span = time.span, freq.span = freq.span, 
            amp.span = amp.span, pretty = TRUE, img.x.format = "%.1f",
            img.y.format = "%.0f",
            main = "Port Foster Event - Fourier Spectrogram")
