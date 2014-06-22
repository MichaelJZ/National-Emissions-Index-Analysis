#Download the dataset from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#Unzip the folder into your working directory

NEI<-readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

#Creates a dataframe with the emissions data for only Baltimore
BALT.EI<-subset(NEI,NEI$fips=="24510")

#Creates a dataframe with the total yearly emission in Baltimore
balt.TYE <- tapply(BALT.EI$Emissions,BALT.EI$year,sum)

png("plot2.png")
par(mar=c(5,5,5,5))
plot(
    x = as.numeric(names(balt.TYE)),
    y = balt.TYE,
    main = "Decrease in Total PM2.5 Emissions in Baltimore from 1999 to 2008",
    type = "p",
    ylab = "Total PM2.5 Emissions (in tons)",
    xlab = "Year",
    xaxp = c(1999,2008,3)
    )
abline(lm(balt.TYE~as.numeric(names(balt.TYE))),col="blue")
dev.off()