
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

# First ceheck wherther "powerdata" object exists in the current session
if (!exists("powerdata"))
{
	# if "powerdata"  doesn't exists, see if "household_power_consumption.txt" ecists in the 
	# working directory. If it doesnot then download the zip file and unzip it
	if (!file.exists("household_power_consumption.txt"))
	{
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
	}

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
}

# The following is the code to plot Polt4

png("figure/plot4.png", width = 480, height = 480)
par(mfrow=c(2,2), mar = c(3,3,2,1), mgp = c(2.0, 0.5, 0))

plot(powerdata[,"datetime"], powerdata[,"Global_active_power"], ylab = "Global Active Power", xlab = "",
     col = "tomato2", main = "", type = "l")

plot(powerdata[,"datetime"], powerdata[,"Voltage"], ylab = "Voltage", xlab = "datetime",
     col = "tomato2", main = "", type = "l")

yrange= range(powerdata[,"Sub_metering_1"], powerdata[,"Sub_metering_2"], powerdata[,"Sub_metering_3"])
plot(powerdata[,"datetime"], powerdata[,"Sub_metering_1"], ylab = "Global Active Power (kilowatts)", xlab = "",
     col = "black", main = "", type = "l", ylim = yrange)
lines(powerdata[,"datetime"], powerdata[,"Sub_metering_2"], col = "red")
lines(powerdata[,"datetime"], powerdata[,"Sub_metering_3"], col = "blue")
legend("topright", bty = "n", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lwd = 1.0)

plot(powerdata[,"datetime"], powerdata[,"Global_reactive_power"], ylab = "Global_rective_power", xlab = "datetime",
     col = "tomato2", main = "", type = "l")

dev.off()
