setwd(getwd())
#install packages that are not already installed
listofPackages <- "downloader"
newPackages <- listofPackages[!(listofPackages %in% installed.packages()[,"Package"])]
if(length(newPackages)) install.packages(newPackages)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Call libraries
library(downloader)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# set working directory. The working directory will the local repo directory.
setwd(getwd())
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# the character string naming the URL of a resource to be downloaded.
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# Destination directory
destfile = "powerconsumption.zip"
#download the data and save it as a local copy
download(url, dest = destfile, mode="wb")
#Unzip the files
con1 <- unzip(destfile,list=TRUE)
for(i in 1:nrow(con1))
{
	unzip(destfile, files=con1$Name[i], exdir = getwd(), overwrite=TRUE) 
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# delete the zipfile
file.remove(destfile)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
### Cleaning and preparing the data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Read the file
powerdata = read.table("household_power_consumption.txt", header = TRUE, sep =";", na.strings = "?")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Select the data only between 2007-02-01 and 2007-02-02.
powerdata = powerdata[(as.Date(powerdata$Date, "%d/%m/%Y") > (as.Date("2007-02-01")-1) 
                      & as.Date(powerdata$Date, "%d/%m/%Y") <= as.Date("2007-02-02")), ]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#form datetime column using "Date" and "Time" columns
powerdata$datetime = as.POSIXct(paste(powerdata$Date, powerdata$Time), format = "%d/%m/%Y %H:%M:%S")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# The following is the code to plot Polt1
png("plot1.png", width = 480, height = 480)
hist(powerdata[,"Global_active_power"], xlab = "Global Active Power (kilowatts)", 
     col = "red", breaks =12, main = "Global Active Power")
dev.off()