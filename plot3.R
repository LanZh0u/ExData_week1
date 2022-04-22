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



#plot3: line plot of "energy sub metering" vs "Day"
png("plot3.png", width=480, height=480)
plot(subdt$Day, subdt$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(subdt$Day, subdt$Sub_metering_2,type="l", col= "red")
lines(subdt$Day, subdt$Sub_metering_3,type="l", col= "blue")
legend(c("topright"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty= 1, lwd=2, col = c("black", "red", "blue"))
dev.off()
