data <- read.csv(unzip("activity.zip"))

sumSteps <- aggregate(steps~date,data,sum)
p<-ggplot(sumSteps, aes(x=steps))
p<-p+geom_histogram(binwidth=max(sumSteps$steps)/30, colour="black", fill="white")
p
mean(sumSteps$steps)
median(sumSteps$steps)

avgInterval <- aggregate(steps~interval, FUN=mean, data=data)
p<-ggplot(avgInterval, aes(interval,steps))
p<-p+geom_line()
p
avgInterval[with(avgInterval,order(-steps))[1],c("interval")]

nrow(data[!complete.cases(data),])
dataAvg <- merge(data,avgInterval,by="interval")
dataAvg$steps.x[is.na(dataAvg$steps.x)] <- dataAvg$steps.y
sumStepsNA <- aggregate(steps.x~date,dataAvg,sum)
p<-ggplot(sumStepsNA, aes(x=steps.x))
p<-p+geom_histogram(binwidth=max(sumSteps$steps)/30,colour="black", fill="white")
p
mean(sumStepsNA$steps.x)
median(sumStepsNA$steps.x)

mean(sumSteps$steps)/mean(sumStepsNA$steps.x)
median(sumSteps$steps)/median(sumStepsNA$steps.x)

boolWeekname=c("Weekday","Weekend")
dataAvg$weekday<-as.numeric(as.numeric(format(as.Date(dataAvg$date),format="%w"))/6>2/3)+1
dataAvg$weekday<-boolWeekname[dataAvg$weekday]
avgIntervalWeekday <- aggregate(steps.x~interval+weekday, data=dataAvg, FUN=mean)
p<-ggplot(avgIntervalWeekday, aes(interval,steps.x))
p<-p+geom_line()
p<-p+geom_line()+facet_grid(weekday~.)
p
