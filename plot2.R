url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = "project2_data.zip")
unzip("project2_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
#Use the base plotting system to make a plot answering this question.

library(dplyr)
baltimore <- NEI %>% 
  filter(fips == 24510) %>% 
  group_by(year) %>% 
  summarise(total = sum(Emissions, na.rm = TRUE))
baltimore

png(filename='plot2.png')
barplot(baltimore$total, 
        names = baltimore$year,
        xlab = "Year",
        ylab = "PM2.5 Emissions",
        main = "Total Emissions from PM2.5 in Baltimore from 1999 to 2008")
dev.off()