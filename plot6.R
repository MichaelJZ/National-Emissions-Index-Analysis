#Download the dataset from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#Unzip the folder into your working directory

SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

#Creates two dataframes with the emissions data for Baltimore and Los Angeles
BALT.EI <- subset(NEI, NEI$fips == "24510")
LA.EI <- subset(NEI, NEI$fips == "06037")

#Finds all types of vehicle related emission sources using EI.Sector in the Source Classification Code
vtype <- grep("Vehicle", levels(SCC$EI.Sector), value=T)

#Subsets Source Classification Code to include only vehicle related emission sources 
vsource <- SCC$EI.Sector %in% vtype
SCC <- subset(SCC, vsource)

#Subsets the Baltimore dataframe to only include data from vehicle related emission sources 
balt.source <- BALT.EI$SCC %in% SCC$SCC
BALT.EI <- subset(BALT.EI, balt.source)

#Subsets the Los Angeles dataframe to only include data from vehicle related emission sources 
la.source <- LA.EI$SCC %in% SCC$SCC
LA.EI <- subset(LA.EI, la.source)

#Creates the data dataframe, which containing the calculated total vehicle related emissions per year in Los Angeles and in Baltimore
LA.Em <- aggregate( x = LA.EI$Emissions, by = list(LA.EI$year), FUN = sum)
BALT.Em <- aggregate( x = BALT.EI$Emissions, by = list(BALT.EI$year), FUN = sum)
LA.Em$city = "Los Angeles"
BALT.Em$city = "Baltimore"
data <- rbind(LA.Em, BALT.Em)
colnames(data) = c( "year", "Emissions")

png("plot6.png")
g <- ggplot(data = data, aes(year,Emissions))
g+
    facet_grid(.~city) +
    ylab("PM2.5 Emissions (in tons)") +
    xlab("Year") +
    scale_x_continuous( breaks=seq(1999, 2008, 3)) +
    ggtitle("Baltimore vs Los Angeles \n PM2.5 Vehicle Emissions from 1999 to 2008") +
    geom_point() +
    geom_smooth( method = "lm")
dev.off()