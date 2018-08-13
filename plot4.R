url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = "project2_data.zip")
unzip("project2_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Across the United States, how have emissions from coal combustion-related
#sources changed from 1999–2008?
library(dplyr)
#check with sectors are related to coal combustion
sectors <- unique(SCC$EI.Sector) #3

coal_elec_gen <- SCC %>% 
  filter(EI.Sector == sectors[1])

coal_indus_boilers <- SCC %>% 
  filter(EI.Sector == sectors[6])

coal_comm_inst <- SCC %>% 
  filter(EI.Sector == sectors[11])

coal2 <- bind_rows(coal_indus_boilers, coal_elec_gen) #bind first two df
coal_combus <- bind_rows(coal_comm_inst, coal2) #and then third to give list of 99 SCC

NEI_coal <- NEI %>% 
  filter(SCC %in% coal_combus$SCC) %>% #retain only those SCCs related to coal combustion
  group_by(year) %>% 
  summarise(Total_Coal_Combustion_Related_Emissions = sum(Emissions, na.rm = TRUE))

png(filename='plot4.png', width = 600)
barplot(NEI_coal$Total_Coal_Combustion_Related_Emissions, 
        names = NEI_coal$year,
        xlab = "Year",
        ylab = "PM2.5 Emissions",
        main = "Total Emissions from PM2.5 related to coal combustion from 1999 to 2008")
dev.off()