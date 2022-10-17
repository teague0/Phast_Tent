# moveACC

library("move")
library("moveACC")

## get 2 example individuals from movebank.org
data(ACCtable) # this is the data set used for the following examples

## to download acceleration data from Movebank:
creds <-  movebankLogin()
ACCtable <- getMovebankNonLocationData(study="Study X", sensorID=2365683, login=creds)
?getMovebankNonLocationData ## see help for details

ACCtimeRange(ACCtable, units="days")

BurstSamplingScedule(ACCtable)

# Transform raw acceleration data into "g" of "m/s²"
sensitiv <- data.frame(TagID=1608, sensitivity="low")
transfDF <- TransformRawACC(ACCtable, sensitivity.settings=sensitiv, units="g")
cailbT1 <- data.frame(TagID=4159, nx=2040, ny=2050, nz=2045, cx=0.00196, cy=0.00195, cz=0.001955)
cailbT2 <- data.frame(TagID=1608, nx=2039, ny=2040, nz=2042, cx=0.00194, cy=0.00194, cz=0.001955)
cailb <- rbind(cailbT1,cailbT2)

transfDF <- TransformRawACC(df=ACCtable, calibration.values=cailb, units="g")

# transfDF <- TransformRawACC(df=ACCtable, sensitivity.settings=sensitiv, calibration.values=cailbT1, units="g")

myconstants <- data.frame(TagID=c(1608,4159), intercept=2040, slope=0.00194)
transfDF <- TransformRawACC(df=ACCtable, calibration.values=myconstants, units="g")

PlotAccData(df=ACCtable,indName="1608", bursts=c(2:6))

