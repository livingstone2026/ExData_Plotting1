plot4 <-function(){
     rm(list=ls())
     
#0) Set project directory
     #The name of directory for downloading data.  You may change
     projDir <- './plot'
     
     #check if the directory exists.  If not, create it
     if(!dir.exists(projDir)) {dir.create(projDir)}
     
     
     if(!file.exists("./hpc1.txt")){
     #download, unzipping, select/filter and saving a more compact data file
#1) Download the zip file
     temp <- paste0(projDir, '/a.zip')
     fileUrl <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
     download.file(fileUrl, temp)
     
     
#2) unzip the file
     unzip(temp, exdir = projDir)
     
     
#3) data.table fread to read the file
     require(data.table)
     hpc<-fread(paste0(projDir, "/household_power_consumption.txt"), 
                header="auto",na.strings="?",skip="1/2/2007",nrow=3000)
     hpcHeader <-fread(paste0(projDir, "/household_power_consumption.txt"),nrow=0)
     colnames(hpc)<-colnames(hpcHeader)
     
     require(dplyr)

     hpc<-filter(hpc, Date=="1/2/2007" | Date=="2/2/2007")
     hpc$Date <- paste(hpc$Date, hpc$Time)
     hpc$Date <- as.POSIXct(hpc$Date, tz="", "%d/%m/%Y %H:%M:%S")
     
     hpc<-select(hpc,-contains("Time")) 
 
#4) Save as hpc1.txt for later use
     write.table(hpc, file = "./hpc1.txt", sep=",", row.name=FALSE)
     #more compact data file created for later use
     }
     else {
     #require(dplyr)     
     require(data.table)     
     }
#5)  read file
     hpc1<-fread("./hpc1.txt", header="auto")
     hpc1$Date <- as.POSIXct(hpc1$Date, tz="", "%Y-%m-%d %H:%M:%S")
     View(hpc1)
     str(hpc1)
     
     
#6) Plot line chart
     fSize =  0.9
     
     png("Plot4.png",width=480, height=480, units="px")
     par(mfcol=c(2,2),mar = c(4,4,4,2), oma=c(0,0,2,0))
     plot(hpc1$Date,hpc1$Global_active_power, xlab="", ylab="Global Active Power", type="l",cex.lab=fSize, cex.axis=fSize)

     plot(hpc1$Date,hpc1$Sub_metering_1, xlab="", ylab="Energy sub metering", type="l",cex.lab=fSize, cex.axis=fSize)
     lines(hpc1$Date,hpc1$Sub_metering_2, xlab="", ylab="Energy sub metering", type="l",col="red",cex.lab=fSize, cex.axis=fSize)
     lines(hpc1$Date,hpc1$Sub_metering_3, xlab="", ylab="Energy sub metering", type="l",col="blue",cex.lab=fSize, cex.axis=fSize)
     legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
            lty=c(1, 1, 1), col=c("black","red","blue"), bty="n", cex=0.9)
     
     plot(hpc1$Date,hpc1$Voltage, xlab="datetime", ylab="Voltage", type="l",cex.lab=fSize, cex.axis=fSize)
     
     plot(hpc1$Date,hpc1$Global_reactive_power, xlab="datetime", ylab="Global_reactive_power", type="l",cex.lab=fSize, cex.axis=fSize)
     
     mtext(side=3,line=0,text=" Plot 4", adj=0, outer=T, cex=1.3)
     dev.off()
}