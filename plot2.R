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


## plot2: line plot of "Global active power" vs "Day"
png("plot2.png", width=480, height=480)
plot(subdt$Day, subdt$Global_active_power, type="l",
     xlab='',ylab='Global Active Power (kilowatts)')
dev.off()

