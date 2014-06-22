#Download the dataset from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#Unzip the folder into your working directory

NEI<-readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

#Creates a dataframe with the total yearly emission in the US
total.yearly.emissions <- tapply(NEI$Emissions,NEI$year,sum)

png("plot1.png")
par(mar=c(5,5,5,5))
plot(
    x = as.numeric(names(total.yearly.emissions)),
    y = total.yearly.emissions,
    main = "Decrease in Total PM2.5 Emissions in the US from 1999 to 2008", 
    type = "p",
    ylab = "Total PM2.5 Emissions (in tons)",
    xlab = "Year",
    xaxp = c(1999,2008,3)
    )
abline(lm(total.yearly.emissions~as.numeric(names(total.yearly.emissions))),col="blue")
dev.off()