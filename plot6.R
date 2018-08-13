url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = "project2_data.zip")
unzip("project2_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Compare emissions from motor vehicle sources in Baltimore City with emissions 
#from motor vehicle sources in Los Angeles County, California (fips == "06037").

library(dplyr)
#check with sectors are related to motor vehicles
sectors <- unique(SCC$EI.Sector) #21-27

SCC_motor <- SCC %>% 
  filter(EI.Sector == sectors[21] | EI.Sector == sectors[22] | EI.Sector == sectors[23] | EI.Sector == sectors[24] | EI.Sector == sectors[25] | EI.Sector == sectors[26] | EI.Sector == sectors[27])

Balt_NEI_motor <- NEI %>% 
  filter(SCC %in% SCC_motor$SCC) %>% #retain only those SCCs related to motor vehicles
  filter(fips == 24510) %>%  #filter again for Baltimore
  group_by(year) %>% 
  summarise(Total_Motor_Related_Emissions = sum(Emissions, na.rm = TRUE))

LA_NEI_motor <- NEI %>% 
  filter(fips == "06037") %>%  #filter for LA
  filter(SCC %in% SCC_motor$SCC) %>% 
  group_by(year) %>% 
  summarise(Total_Motor_Related_Emissions = sum(Emissions, na.rm = TRUE))

LA_NEI_motor$City <- c("LA", "LA", "LA", "LA")
Balt_NEI_motor$City <- c("Baltimore", "Baltimore", "Baltimore", "Baltimore")

City_motor_emissions <- bind_rows(Balt_NEI_motor, LA_NEI_motor)
library(ggplot2)

png(filename='plot6.png', width = 700)
ggplot(City_motor_emissions, aes(as.factor(year), Total_Motor_Related_Emissions, fill = City)) +
  geom_bar(stat = "identity") +
  facet_grid(.~City, scales = "free", space="free") +
  labs(x= "Year", y= "Total PM2.5 Emission (Tons)") + 
  labs(title= "PM2.5 Emissions from motor vehicles in Baltimore & LA between 1999-2008") +
  theme_minimal()
dev.off()

#Which city has seen greater changes over time in motor vehicle emissions?
#LA