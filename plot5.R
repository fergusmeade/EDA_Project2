url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = "project2_data.zip")
unzip("project2_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

library(dplyr)
#check with sectors are related to motor vehicles
sectors <- unique(SCC$EI.Sector) #21-27

SCC_motor <- SCC %>% 
  filter(EI.Sector == sectors[21] | EI.Sector == sectors[22] | EI.Sector == sectors[23] | EI.Sector == sectors[24] | EI.Sector == sectors[25] | EI.Sector == sectors[26] | EI.Sector == sectors[27])

NEI_motor <- NEI %>% 
  filter(SCC %in% SCC_motor$SCC) %>% #retain only those SCCs related to motor vehicles
  filter(fips == 24510) %>%  #filter again for Baltimore
  group_by(year) %>% 
  summarise(Total_Motor_Related_Emissions = sum(Emissions, na.rm = TRUE))
NEI_motor

png(filename='plot5.png', width = 700)
barplot(NEI_motor$Total_Motor_Related_Emissions, 
        names = NEI_motor$year,
        xlab = "Year",
        ylab = "PM2.5 Emissions",
        main = "Total Emissions from PM2.5 related to motor vehicles in Baltimore from 1999 to 2008")
dev.off()