#Read the Data

install.packages("corrplot")
library(corrplot)
install.packages("ggplot2")
library(ggplot2)
install.packages("tidyr")
library(tidyr)
install.packages("lubridate")
library(lubridate)
install.packages("data.table")
install.packages("dplyr")
if(!require(DT)){
  install.packages("DT")
}
library(DT)
library(data.table)
library(dplyr)
setwd("..\\Zillow")
properties<-fread("C:\\Users\\Dhruvesh\\Documents\\Kaggle\\Zillow\\properties_2016.csv")
sample<-fread("C:\\Users\\Dhruvesh\\Documents\\Kaggle\\Zillow\\sample_submission.csv")
transactions<-fread("C:\\Users\\Dhruvesh\\Documents\\Kaggle\\Zillow\\train_2016.csv")

#Peak at the dataset

datatable(head(properties,100), style="bootstrap", class="table-condensed",options = list(dom='tp',scrollx=TRUE))

datatable(head(transactions,100), style="bootstrap", class="table-condensed", options = list(dom = 'tp'))

datatable(head(sample,10), style="bootstrap", class="table-condensed", options = list(dom = 'tp'))
View(properties)

#renaming the features

properties <- properties %>% rename(
  id_parcel = parcelid,
  build_year = yearbuilt,
  area_basement = basementsqft,
  area_patio = yardbuildingsqft17,
  area_shed = yardbuildingsqft26, 
  area_pool = poolsizesum,  
  area_lot = lotsizesquarefeet, 
  area_garage = garagetotalsqft,
  area_firstfloor_finished = finishedfloor1squarefeet,
  area_total_calc = calculatedfinishedsquarefeet,
  area_base = finishedsquarefeet6,
  area_live_finished = finishedsquarefeet12,
  area_liveperi_finished = finishedsquarefeet13,
  area_total_finished = finishedsquarefeet15,  
  area_unknown = finishedsquarefeet50,
  num_unit = unitcnt, 
  num_story = numberofstories,  
  num_room = roomcnt,
  num_bathroom = bathroomcnt,
  num_bedroom = bedroomcnt,
  num_bathroom_calc = calculatedbathnbr,
  num_bath = fullbathcnt,  
  num_75_bath = threequarterbathnbr, 
  num_fireplace = fireplacecnt,
  num_pool = poolcnt,  
  num_garage = garagecarcnt,  
  region_county = regionidcounty,
  region_city = regionidcity,
  region_zip = regionidzip,
  region_neighbor = regionidneighborhood,  
  tax_total = taxvaluedollarcnt,
  tax_building = structuretaxvaluedollarcnt,
  tax_land = landtaxvaluedollarcnt,
  tax_property = taxamount,
  tax_year = assessmentyear,
  tax_delinquency = taxdelinquencyflag,
  tax_delinquency_year = taxdelinquencyyear,
  zoning_property = propertyzoningdesc,
  zoning_landuse = propertylandusetypeid,
  zoning_landuse_county = propertycountylandusecode,
  flag_fireplace = fireplaceflag, 
  flag_tub = hashottuborspa,
  quality = buildingqualitytypeid,
  framing = buildingclasstypeid,
  material = typeconstructiontypeid,
  deck = decktypeid,
  story = storytypeid,
  heating = heatingorsystemtypeid,
  aircon = airconditioningtypeid,
  architectural_style= architecturalstyletypeid
)
str(transactions)
#Distribution of Logerror

transactions<-transactions%>%rename(date= transactiondate)%>%rename(id_parcel=parcelid)
transactions %>% ggplot(aes(x=logerror)) + 
  geom_histogram(bins=400, fill="red")+theme_bw()+xlab("Logerror")+
  ylab("Count")+coord_cartesian(x=c(-0.5,0.5))

#Distribution of Missing values
missing_values <- properties %>% summarize_each(funs(sum(is.na(.))/n()))
View(missing_values)

missing_values <- gather(missing_values, key="feature", value="missing_pct")

missing_values %>% ggplot(aes(x=reorder(feature,-missing_pct),y=missing_pct)) +
  geom_bar(stat="identity",fill="red")+coord_flip()+theme_bw()

#Correlation with outcome

tmp <- transactions %>% left_join(properties, by="id_parcel")
vars <- c("num_bathroom", "num_bedroom", "num_bath", "num_room", "num_unit")
tmp <- tmp %>% select(one_of(c(vars,"logerror")))
View(tmp)

corrplot(cor(tmp, use ="complete.obs"))
corrplot(cor(tmp, use='complete.obs'))

tmp <- transactions %>%  left_join(properties, by="id_parcel")
vars <- c("area_total_calc", "area_live_finished", "area_firstfloor_finished")
tmp <- tmp %>% select(one_of(c(vars,"logerror")))
corrplot(cor(tmp, use='complete.obs'))

#How does absolute log error change with time

transactions <- transactions %>% mutate(abs_logerror = abs(logerror))
  transactions %>% mutate(year_month= make_date(year=year(date),month=month(date))) %>% 
    group_by(year_month) %>% summarise(mean_abs_logerror=mean(abs_logerror))%>%
    ggplot(aes(x=year_month,y=mean_abs_logerror))+
    geom_line(size=1.5,color="red")+
    geom_point(size=5,color="blue") +theme_bw()
  
  transactions %>% 
    mutate(year_month = make_date(year=year(date),month=month(date)) ) %>% 
    group_by(year_month) %>% summarize(mean_abs_logerror = mean(abs_logerror)) %>% 
    ggplot(aes(x=year_month,y=mean_abs_logerror)) + 
    geom_line(size=1.5, color="red")+
    geom_point(size=5, color="red")+theme_bw()

