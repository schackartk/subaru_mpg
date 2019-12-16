library(shiny)
library(plotly)
library(tidyr)
library(readr)
library(dplyr)
library(directlabels)

# Fetch the dataset
big_epa_cars <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-15/big_epa_cars.csv")

# Clean up the data
epa_mtcars <-big_epa_cars %>% 
  mutate(
    fuel         = paste0(fuelType1,",",fuelType2),
    mpg_city     = paste0(city08 ,",",cityA08),
    mpg_hw       = paste0(highway08 ,",",highwayA08),
    c02          = paste0(co2,",",co2A),
    trany        = 
      gsub("Auto\\(AM-S(\\d+)\\)","Automatic \\1-spd",
           gsub("4-spd Doubled","4-spd",
                gsub("(variable gear ratios)","variable_gear_ratios",
                     trany)),perl=TRUE)
  ) %>% 
  separate(trany,c("transmission","gears"),sep=" ") %>% 
  mutate(gears = gsub("-spd","",gears)) %>% 
  select(
    make         = make,
    model        = model,
    year         = year,
    type         = VClass,
    displacement = displ,
    transmission,
    gears,
    cylinders    = cylinders,
    drive,
    fuel,
    mpg_city,
    mpg_hw,
    c02
  ) %>% 
  separate_rows(fuel,mpg_city,mpg_hw,c02,sep=",") %>% 
  filter(fuel     !="NA",
         mpg_city !=0) %>% 
  mutate(mpg_city  = as.numeric(mpg_city),
         mpg_hw    = as.numeric(mpg_hw),
         c02       = as.numeric(c02),
         c02       = na_if(c02,-1)) %>% 
  arrange(make,model,year)

# Filter the data to only include Subaru
sub_epa_mtcars <- filter(epa_mtcars,make == "Subaru")

# Collapse the model names so that there are fewer
sub_epa_mtcars$model[grepl("asc",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Ascent"
sub_epa_mtcars$model[grepl("tribeca",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Tribeca"
sub_epa_mtcars$model[grepl("baja",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Baja"
sub_epa_mtcars$model[grepl("brat",sub_epa_mtcars$model,ignore.case=TRUE)]<-"BRAT"
sub_epa_mtcars$model[grepl("brz",sub_epa_mtcars$model,ignore.case=TRUE)]<-"BRZ"
sub_epa_mtcars$model[grepl("XV",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Crosstrek"
sub_epa_mtcars$model[grepl("crosstrek",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Crosstrek"
sub_epa_mtcars$model[grepl("forester",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Forester"
sub_epa_mtcars$model[grepl("impreza",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Impreza"
sub_epa_mtcars$model[grepl("justy",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Justy"
sub_epa_mtcars$model[grepl("outback",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Outback"
sub_epa_mtcars$model[grepl("legacy",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Legacy"
sub_epa_mtcars$model[grepl("loyale",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Loyale"
sub_epa_mtcars$model[grepl("svx",sub_epa_mtcars$model,ignore.case=TRUE)]<-"SVX"
sub_epa_mtcars$model[grepl("wrx",sub_epa_mtcars$model,ignore.case=TRUE)]<-"WRX"
sub_epa_mtcars$model[grepl("xt",sub_epa_mtcars$model,ignore.case=TRUE)]<-"XT"
sub_epa_mtcars$model[grepl("^wagon",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Wagon"
sub_epa_mtcars$model[grepl("sedan",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Sedan"
sub_epa_mtcars$model[grepl("hatchback",sub_epa_mtcars$model,ignore.case=TRUE)]<-"Hatchback"

# Get rid of non descriptive model names (some of these may be valid, but it also cleans the plot)
sub_epa_mtcars <- sub_epa_mtcars %>% 
  filter(!model %in% c("Justy","Wagon", "3 Door 4WD Turbo", "Hatchback", "Sedan", "XT", "RX Turbo"))

# Calculate fleet mpg from the city and highway efficiencies
mpg_over_year <- sub_epa_mtcars %>% 
  mutate(mpg = mpg_hw * .45 + mpg_city * .55) %>% 
  group_by(model,year) %>% 
  summarize(fleet_mpg = mean(mpg),
            ncars = n())

# Plot the data
mpg_plot <-
  mpg_over_year %>% 
  ungroup() %>% 
  ggplot() +
  geom_line(aes( x = year,
                 y = fleet_mpg,
                 color = model,
                 group = model))+
  scale_color_manual(                # Default color scheme was impossible to read
    values = c("#BE9C00", #Ascent
               "#00BBDA", #Baja
               "#00C1AB", #BRAT 
               "#8CAB00", #BRZ
               "#24B700", #Crosstrek
               "#00BE70", #Forester
               "#F8766D", #Impreza
               "#00ACFC", #Legacy 
               "#E18A00", #Loyale
               "#8B93FF", #Outback
               "#D575FE", #SVX
               "#F962DD", #Tribeca
               "#FF65AC")) +
  ggtitle("Subaru Fuel Efficiency Over Time by Model")+
  xlab(NULL)+
  ylab("Average Fuel Efficiency (mpg)")+
  theme_bw() +
  geom_dl(aes(x = year, y = fleet_mpg, label = model),
          method = list(dl.combine("first.points"),cex = 0.8)) 

# Show the plot
mpg_plot

# Save plot
ggsave("subaru_mpg_by_model.png", width = 10)
