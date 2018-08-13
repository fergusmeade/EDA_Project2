url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = "project2_data.zip")
unzip("project2_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 emission
#from all sources for each of the years 1999, 2002, 2005, and 2008.
head(NEI)
colnames(NEI)
str(NEI)
summary(NEI)
unique(NEI$year) # 4 years data only
library(dplyr)
summary <- NEI %>% 
  group_by(year) %>% 
  summarise(total = sum(Emissions, na.rm = TRUE))
summary
png(filename='plot1.png')
barplot(summary$total, 
        names = summary$year,
        xlab = "Year",
        ylab = "PM2.5 Emissions",
        main = "Total Emissions from PM2.5 from 1999 to 2008")
dev.off()