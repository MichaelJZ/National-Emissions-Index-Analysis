#Download the dataset from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#Unzip the folder into your working directory

SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

#Finds all types of coal related emission sources using EI.Sector in the Source Classification Code
ctype <- grep("Coal", levels(SCC$EI.Sector), value=T)
#Finds all coal related emission sources that are also combustion related 
ctype <- grep("Comb", ctype, value=T)

#Subsets Source Classification Code to include only coal combustion related emission sources 
csource <- SCC$EI.Sector %in% ctype
SCC <- subset(SCC, csource)

#Subsets NEI to only include data from coal combustion related emission sources 
NEI.source <- NEI$SCC %in% SCC$SCC
NEI <- subset(NEI, NEI.source)

#Creates a dataframe containing the calculated total coal combustion related emissions per year
NEI <- aggregate( x = NEI$Emissions, by = list(NEI$year), FUN = sum)
colnames(NEI) = c( "year", "Emissions")


png("plot4.png")
g <- ggplot(NEI, aes(year,Emissions))
g+
    geom_point() +
    geom_smooth(method="lm", se=F) +
    ylab("PM2.5 Emissions (in tons)") +
    xlab("Year") +
    scale_x_continuous(breaks=seq(1999, 2008, 3)) +
    ggtitle("Decrease in Coal Combustion Related PM2.5 Emissions \n in US from 1999 to 2008")
dev.off()