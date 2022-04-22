# download the data
if (!file.exists("data")){
    dir.create("data")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile = "./data/Dataset.zip",  method = "curl")
unzip("./data/Dataset.zip")

#read data, convert "?" to na, and assign data type for each column
library(data.table)
dt<-fread("household_power_consumption.txt", na.strings="?",colClasses=c(rep("character", 2), rep("numeric", 7)))

#format Date and Time and make a new variable of Day combines Date and Time
dt[, `:=`(Date=as.Date(Date, format="%d/%m/%Y"), 
          Time=format(Time,format="%H:%M:%S"),
          Day=strptime(paste(Date," ",Time),"%d/%m/%Y %H:%M:%S"))]


## subset data from 2007-02-01 and 2007-02-02
subdt <- dt[Date %in% as.Date(c("2007-02-01","2007-02-02"))]


#plot4: 4 (2x2) sub-plots 
png("plot4.png", width=480, height=480)
par(mfrow=c(2,2), mar=c(4,4,2,2))
#top left: "Global active power" 
plot(subdt$Day, subdt$Global_active_power, type="l", xlab="", ylab="Global Active Power")
#top right: "Voltage"
plot(subdt$Day, subdt$Voltage, type="l", xlab="datetime", ylab="Voltage")
#bottom left: energy sub metering
plot(subdt$Day, subdt$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(subdt$Day, subdt$Sub_metering_2,type="l", col= "red")
lines(subdt$Day, subdt$Sub_metering_3,type="l", col= "blue")
legend(c("topright"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),bty='n', lty=1,lwd=1, col = c("black", "red", "blue"))
#bottom right: "global reactive power"
plot(subdt$Day, subdt$Global_reactive_power, type="l", xlab="datatime", ylab="Global_reactive_power")
dev.off()