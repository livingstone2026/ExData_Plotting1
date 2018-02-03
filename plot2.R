plot2 <-function(){
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
     require(data.table)     
     }
#5)  read file
     hpc1<-fread("./hpc1.txt", header="auto")
     hpc1$Date <- as.POSIXct(hpc1$Date, tz="", "%Y-%m-%d %H:%M:%S")
     View(hpc1)
     str(hpc1)
     
     
#6) Plot line chart
     png("Plot2.png",width=480, height=480, units="px")
     par(mar=c(3,4.5,5.5,1))
     plot(hpc1$Date,hpc1$Global_active_power, xlab="", ylab="Global Active Power (kilowatts)", type="l")
     mtext(side=3,line=-1.5,text=" Plot 2", adj=0, outer=T, cex=1.3)
     dev.off()
}