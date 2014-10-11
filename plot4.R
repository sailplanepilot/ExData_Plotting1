# clean house first
rm(list=ls(all=TRUE)) 
#
# load libraries
library(lubridate)
# create a data.frame
power<-read.table("household_power_consumption.txt",header=TRUE,nrows=1, sep=";",stringsAsFactors = FALSE)
#
# open the file for reading
con <- file("household_power_consumption.txt", "r", blocking = FALSE)
# read the first line - the header - and discard it since we don't need it
readLines(con,n=1)
#
# I don't want to worry about reading in the whole file and running out of memory
# So I'll just bring n the rows I need. It's slow, but more efficient in the long run
repeat {
	pp<-readLines(con,n=1,warn=FALSE)
	# end the loop if we reached the end of the file
	if(length(pp)==0){
		close(con)
		break
	}
	# look for the dates we want
    	if(grepl("^1/2/2007|^2/2/2007",pp)){
		# grepl returns a single character string, so we need to break it up
        	p<-strsplit(pp,";")
		# and add it to the data frame
        	power<-rbind(power,unlist(p))
    	}
}
#
# delete the first row since we only read it to get the colnames
power<-power[-1,]
# change the classes beck to the originals, since they were coereced to char
power[,3:9]<-sapply(power[,3:9],as.numeric)
#
# make the fonts a little smaller
# par(cex=.75)
# set up multiple plots
par(mfrow=c(2,2),mar=c(4,4,2,1),oma=c(0,0,2,0))
# set the tick size
par(tcl= -0.5)
# create the plots
with(power,{
	plot(Global_active_power,type="l",ylab="Global Active Power",xaxt="n",xlab="")
		# create the X-axis with the day of the week
		axis(1, at=c(1,60*24,60*48), labels=c("Thu","Fri","Sat"), lwd=1, lwd.ticks=1)
	plot(Voltage,type="l",ylab="Voltage",xaxt="n",xlab=dmy(power$Date[1]))
		axis(1, at=c(1,60*24,60*48), labels=c("Thu","Fri","Sat"), lwd=1, lwd.ticks=1)
	plot(Sub_metering_1,type="l",ylab="Energy sub metering",xaxt="n",xlab="")
		lines(Sub_metering_2,col="red")
		lines(Sub_metering_3,col="blue")
		axis(1, at=c(1,60*24,60*48), labels=c("Thu","Fri","Sat"), lwd=1, lwd.ticks=1)
		# add a legend
		legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3 "), lty=1, col=c("black","red","blue"), bty="n")
	plot(Global_reactive_power,type="l",xaxt="n",xlab=dmy(power$Date[1]))
		axis(1, at=c(1,60*24,60*48), labels=c("Thu","Fri","Sat"), lwd=1, lwd.ticks=1)
})

# copy plot to a PNG file
dev.copy(png,file="plot4.png",width=480,height=480)
dev.off()