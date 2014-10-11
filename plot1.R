# clean house first
rm(list=ls(all=TRUE)) 
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
# create a histogram of Global Active Power
with(power,hist(power$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)",col="red"))
# copy plot to a PNG file
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()