#Download the dataset from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#Unzip the folder into your working directory

NEI<-readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

#Creates a dataframe with the emissions data for only Baltimore
BALT.EI<-subset(NEI,NEI$fips=="24510")

#Creates a dataframe containing the calculated total emissions per year, per source in Baltimore
BALT.Em <- aggregate( x = BALT.EI$Emissions, by = list(BALT.EI$year,BALT.EI$type), FUN = sum)
colnames(BALT.Em) = c( "year", "type", "Emissions")

png("plot3.png",width=1080)
g<-ggplot(BALT.Em,aes(year,Emissions))
g+
    facet_grid(.~type) + 
    geom_point() +
    geom_smooth(method="lm") + 
    ylab("PM2.5 Emissions (in tons)") +
    xlab("Year") +
    scale_x_continuous(breaks=seq(1999, 2008, 3)) +
    ggtitle("Total PM2.5 Emissions in Baltimore from 1999 to 2008 by Source")
dev.off()