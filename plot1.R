plot1 <-function(){
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
     #hpc<-subset(hpc,Date=="1/2/2007" | Date=="2/2/2007")  also works
     hpc$Date <- paste(hpc$Date, hpc$Time)
     hpc$Date <- as.POSIXct(hpc$Date, tz="", "%d/%m/%Y %H:%M:%S")
     
     hpc<-select(hpc,-contains("Time")) 
     #hpc$Date<-as.Date(hpc$Date,"%d/%m/%Y")  - works
     #hpc[,1]<-as.Date(hpc[,1], "%d/%m/%Y")   - does not work and generates error message below
     #Error in as.Date.default(hpc[, 1], "%d/%m/%Y") : 

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
     
     
#6) Plot histogram
     png("Plot1.png",width=480, height=480, units="px")
     #saved as a png file but not shown on monitor
     
     par(mar=c(5,4.5,5.5,1))  #it seems that setting margin needs to be done before the chart is plot
    
     hist(hpc1$Global_active_power,col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency")

     mtext(side=3,line=-1.5,text=" Plot 1", adj=0, outer=T, cex=1.3)  


     #Below 3 lines only put the text "Plot 1" on top left graph corner 
     #but outside the graph and near the edge
     #par(xpd=TRUE)
     #text(0,1400,"Plot 1")
     #par(xpd=FALSE)
     
     #legend("topleft","Plot1") - places the text inside the chart's top left corner, 
     #but not outside the chart and near the edge
     
     #Use this if you want to show on monitor and save the file
     #dev.copy(png,"plot1.png", width=480, height=480, units="px")
     dev.off()
}