#Download the dataset from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#Unzip the folder into your working directory

SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

#Creates a dataframe with the emissions data for only Baltimore 
BALT.EI <- subset(NEI, NEI$fips == "24510")

#Finds all types of vehicle related emission sources using EI.Sector in the Source Classification Code
vtype <- grep("Vehicle", levels(SCC$EI.Sector), value=T)

#Subsets Source Classification Code to include only vehicle related emission sources 
vsource <- SCC$EI.Sector %in% vtype
SCC <- subset(SCC, vsource)

#Subsets the Baltimore dataframe to only include data from vehicle related emission sources 
balt.source <- BALT.EI$SCC %in% SCC$SCC
BALT.EI <- subset(BALT.EI, balt.source)

#Creates a dataframe containing the calculated total vehicle related emissions per year in Baltimore
BALT.Em <- aggregate( x = BALT.EI$Emissions, by = list(BALT.EI$year), FUN = sum)
colnames(BALT.Em) = c( "year", "Emissions")

png("plot5.png")
g <- ggplot(BALT.Em, aes(year, Emissions))
g+
    geom_point() +
    geom_smooth(method="lm") + 
    ylab("PM2.5 Emissions (in tons)") +
    xlab("Year") +
    scale_x_continuous(breaks=seq(1999, 2008, 3)) +
    ggtitle("Decrease in Vehicle Related PM2.5 Emissions \n in Baltimore from 1999 to 2008")
dev.off()