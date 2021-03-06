
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

# The following is the code to plot Polt2
png("figure/plot2.png", width = 480, height = 480)
plot(powerdata[,"datetime"], powerdata[,"Global_active_power"], ylab = "Global Active Power (kilowatts)", xlab = "",
     col = "tomato2", main = "", type = "l")
dev.off()
