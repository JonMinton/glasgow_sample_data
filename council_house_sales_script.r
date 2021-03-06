# First time do

require(plyr)
require(reshape2)
require(stringr)
require(ggplot2)


# datazones for east end of Glasgow
east_end_dzs <- c(
"S01003205",
"S01003248",
"S01003251",
"S01003254",
"S01003263",
"S01003270",
"S01003271",
"S01003328",
"S01003335",
"S01003313",
"S01003331",
"S01003333",
"S01003355",
"S01003368",
"S01003279",
"S01003347",
"S01003201",
"S01003217",
"S01003342",
"S01003353",
"S01003253",
"S01003269",
"S01003273",
"S01003289",
"S01003296",
"S01003299",
"S01003314"
)
# 27 Dzs 
# Source: http://www.scotland.gov.uk/Topics/ArtsCultureSport/Sport/MajorEvents/Glasgow-2014/Commonwealth-games/Indicators/S9

# 27 West End Datazones
west_end_dzs  <- c(
"S01003437",
"S01003450",
"S01003453",
"S01003454",
"S01003460",
"S01003464",
"S01003466",
"S01003468",
"S01003470",
"S01003474",
"S01003478",
"S01003479",
"S01003484",
"S01003485",
"S01003487",
"S01003497",
"S01003501",
"S01003503",
"S01003504",
"S01003509",
"S01003513",
"S01003514",
"S01003520",
"S01003521",
"S01003522",
"S01003542",
"S01003545"
)


# Look at data from Konrad

# Tables of interest
# House sales and prices 2001
# 
# House sales and prices 2010



# Council house sales 1980 to 2005

years_to_read <-   1980:2005

fn <- function(this_year){
  dta <- read.csv(
    paste0(
      "G:/dropbox/Dropbox/Data/SNS_FullData_CSV_14_3_2013/Housing_1764_Council House Sales_",
      this_year,
      "_ZN_C0R0_2_7_2012.csv"
      ),
    header=T
    )
  dta <- dta[-1,]
  names(dta)[1] <- "datazone"
  dta[,2] <- as.numeric(dta[,2])
  dta[,3] <- as.numeric(dta[,3])
  dta[,4] <- as.numeric(dta[,4])
  dta$year <- this_year
  
  return(dta)
}

sales_all <- ldply(
  years_to_read,
  fn
  )


# Council house sales for all of scotland

sales_all_scotland <- ddply(
  sales_all,
  .(year),
  summarise,
  all_tenant_sales=sum(HO.alltenantsale),
  flat_tenant_sales=sum(HO.Flattenantsale),
  house_tenant_sales=sum(HO.Housetenantsale)
  )

sales_all_scotland$area <- "scotland"

qplot(x=year, y=all_tenant_sales, data=sales_all_scotland, geom="line")
# Now just for east end of glasgow

sales_east_end <- subset(
  sales_all,
  subset=datazone %in% east_end_dzs
  )

sales_east_end_combined <- ddply(
  sales_east_end,
  .(year),
  summarise,
  all_tenant_sales=sum(HO.alltenantsale),
  flat_tenant_sales=sum(HO.Flattenantsale),
  house_tenant_sales=sum(HO.Housetenantsale)
)

sales_east_end_combined$area <- "east_end"
qplot(x=year, y=all_tenant_sales, data=sales_east_end_combined, geom="line")

######################

sales_west_end <- subset(
  sales_all,
  subset=datazone %in% west_end_dzs
)

sales_west_end_combined <- ddply(
  sales_west_end,
  .(year),
  summarise,
  all_tenant_sales=sum(HO.alltenantsale),
  flat_tenant_sales=sum(HO.Flattenantsale),
  house_tenant_sales=sum(HO.Housetenantsale)
)

sales_west_end_combined$area <- "west_end"

qplot(x=year, y=all_tenant_sales, data=sales_west_end_combined, geom="line")


# council house sales 
council_house_sales_combined <- rbind(
  sales_all_scotland,
  sales_east_end_combined,
  sales_west_end_combined
  )


#### How about house price sales?


years_to_read <-   1993:2010

fn <- function(this_year){
  dta <- read.csv(
    paste0(
      "G:/dropbox/Dropbox/Data/SNS_FullData_CSV_14_3_2013/Housing_2094_House sales and prices_",
      this_year,
      "_ZN_C0R0_2_7_2012.csv"
    ),
    header=T
  )
  dta <- dta[-1,]
  names(dta)[1] <- "datazone"
  dta[,2] <- as.numeric(dta[,2])
  dta[,3] <- as.numeric(dta[,3])
  dta[,4] <- as.numeric(dta[,4])
  dta[,5] <- as.numeric(dta[,5])
  
  dta$year <- this_year
  
  return(dta)
}

house_prices_all <- ldply(
  years_to_read,
  fn
)


# Council house sales for all of scotland

house_prices_all_scotland <- ddply(
  house_prices_all,
  .(year),
  summarise,
  house_price_lower_quartile=median(HO.hpricelquartile),
  house_price_mean = median(HO.hpricemean),
  house_price_median = median(HO.hpricemedian),
  house_price_upper_quartile = median(HO.hpriceuquartile),
  number_of_house_sales = sum(HO.hsalesno)
)
house_prices_all_scotland$area <- "scotland"


qplot(x=year, y=number_of_house_sales, data=house_price_all_scotland, geom="line")
# Now just for east end of glasgow

house_prices_east_end <- subset(
  house_prices_all,
  subset=datazone %in% east_end_dzs
)

house_prices_all_east_end <- ddply(
  house_prices_east_end,
  .(year),
  summarise,
  house_price_lower_quartile=median(HO.hpricelquartile),
  house_price_mean = median(HO.hpricemean),
  house_price_median = median(HO.hpricemedian),
  house_price_upper_quartile = median(HO.hpriceuquartile),
  number_of_house_sales = sum(HO.hsalesno)
)

house_prices_all_east_end$area <- "east_end"


qplot(x=year, y=number_of_house_sales, data=house_prices_all_east_end, geom="line")

#####
house_prices_west_end <- subset(
  house_prices_all,
  subset=datazone %in% west_end_dzs
)

house_prices_all_west_end <- ddply(
  house_prices_west_end,
  .(year),
  summarise,
  house_price_lower_quartile=median(HO.hpricelquartile),
  house_price_mean = median(HO.hpricemean),
  house_price_median = median(HO.hpricemedian),
  house_price_upper_quartile = median(HO.hpriceuquartile),
  number_of_house_sales = sum(HO.hsalesno)
)

house_prices_all_west_end$area <- "west_end"

qplot(x=year, y=number_of_house_sales, data=house_prices_all_west_end, geom="line")

qplot(x=year, y=house_price_median, data=house_prices_all_west_end, geom="line")

qplot(x=year, y=house_price_median, data=house_prices_all_east_end, geom="line")

house_prices_combined <- rbind(
  house_prices_all_scotland,
  house_prices_all_east_end,
  house_prices_all_west_end
)


# Now JSA


years_to_read <-   1999:2011
quarters <- 1:4
df <- expand.grid(
  year=years_to_read,
  quarter=quarters
  )

fn <- function(x){
  this_year <- x$year
  this_quarter <- x$quarter
  
  
   dta <- try(
     read.csv(
       paste0(
         "G:/dropbox/Dropbox/Data/SNS_FullData_CSV_14_3_2013/Economic Activity Benefits and Tax Credits_2250_Job Seekers Allowance_",
         this_year,
         "Q0",
         this_quarter,
         "_ZN_C0R0_2_7_2012.csv"
       ),
       header=T
     )
   )
  
   if (class(dta)!="try-error"){
     dta <- dta[-1,]
     names(dta)[1] <- "datazone"
     dta[,2] <- as.numeric(dta[,2])
     dta[,3] <- as.numeric(dta[,3])
     dta[,4] <- as.numeric(dta[,4])
     dta[,5] <- as.numeric(dta[,5])
     dta[,6] <- as.numeric(dta[,6])
     dta[,7] <- as.numeric(dta[,7])
     dta$year <- this_year
     dta$quarter <- this_quarter
     
     return(dta)
          
   }
}

jsa_all <- ddply(
  df,
  .(year, quarter),
  fn
)


write.csv(jsa_all, "jsa_merged.csv")
jsa_scotland <- ddply(
  jsa_all,
  .(year),
  summarise,
  jsa_claimants_16_to_24 = sum(CS.JSA_16to24),
  jsa_claimants_25_to_49 = sum(CS.JSA_25to49),
  jsa_claimants_50_plus = sum(CS.JSA_50plus),
  jsa_claimants_female = sum(CS.JSA_female),
  jsa_claimants_male = sum(CS.JSA_male),
  jsa_claimants_total = sum(CS.JSA_total)
  )

jsa_scotland$area <- "scotland"


jsa_east_end <- subset(
  jsa_all,
  subset=datazone %in% east_end_dzs
)

jsa_all_east_end <- ddply(
  jsa_east_end,
  .(year),
  summarise,
  jsa_claimants_16_to_24 = sum(CS.JSA_16to24),
  jsa_claimants_25_to_49 = sum(CS.JSA_25to49),
  jsa_claimants_50_plus = sum(CS.JSA_50plus),
  jsa_claimants_female = sum(CS.JSA_female),
  jsa_claimants_male = sum(CS.JSA_male),
  jsa_claimants_total = sum(CS.JSA_total)
)

jsa_all_east_end$area <- "east_end"

#####
jsa_west_end <- subset(
  jsa_all,
  subset=datazone %in% west_end_dzs
)

jsa_all_west_end <- ddply(
  jsa_west_end,
  .(year),
  summarise,
  jsa_claimants_16_to_24 = sum(CS.JSA_16to24),
  jsa_claimants_25_to_49 = sum(CS.JSA_25to49),
  jsa_claimants_50_plus = sum(CS.JSA_50plus),
  jsa_claimants_female = sum(CS.JSA_female),
  jsa_claimants_male = sum(CS.JSA_male),
  jsa_claimants_total = sum(CS.JSA_total)
)

jsa_all_west_end$area <- "west_end"

###########

# Combine all into a single dataset

jsa_combined <- rbind(
  jsa_scotland,
  jsa_all_east_end,
  jsa_all_west_end
  )



# join all to a single dataset

all_simplified_data <- join(
  council_house_sales_combined,
  house_prices_combined  
  )

all_simplified_data <- join(
  all_simplified_data,
  jsa_combined
  )

write.csv(all_simplified_data, "all_simplified_data.csv")


###################################

# Access to services

# Drive time
Access to Services_2047_Drive Time
Years: 2003 2006 2009

Public transport times
Access to Services_2047_Public Transport Times
Years: 2006 2009

# Community Care

Community Care_2189_Number of Care Homes
Years: 2000:2006

Community Care_2189_Places in Care Homes
Years: 2000:2006

Community Care_2189_Occupancy rate in Care Homes
Years: 2003:2005

Community Care_2189_Ensuite places in care homes
Years: 2003:2005

Community Care_2189_Places in single roooms in care homes
Years: 2003:2005

# Crime and Justice

Crimes and offences recorded by the police
Crime and Justice_2267_SIMD Crime and offences recorded by the police)
Years: 2004, 2007/2008 (combined)


# Economic Activity Benefits and Tax Credits
Economic Activity Benefits and Tax Credits_2041_Income Deprivation
Years: 2002, 2005, 2008, 2008/2009, 2009/2010

Economic Activity Benefits and Tax Credits_2041_Employment Deprivation
Years: 2002, 2005, 2008, 2009, 2010

Economic Activity Benefits and Tax Credits_2041_Working Age Claimants of Benefi
Years: 1999:2011
Quarters: 1:4

Economic Activity Benefits and Tax Credits_2041_Child Benefit
Years: 2003:2011

Economic Activity Benefits and Tax Credits_2041_Retirement Pension
Years: 2002:2011
Quarters: 1:4

Economic Activity Benefits and Tax Credits_2041_Income Support
Years: 1999: 2011
Quarters: 1:4

Economic Activity Benefits and Tax Credits_2041_Pension Credits
Years: 2003:2011
Quarters: 1:4

Economic Activity Benefits and Tax Credits_2041_Comparative Illness
Years: 2003:2010

Economic Activity Benefits and Tax Credits_2041_Workless Client Group
Years: 1999:2011
Quarters: 1:4

Economic Activity Benefits and Tax Credits_2041_Job Seekers Allowance
Years: 1999:2011
Quarters: 1:4

Economic Activity Benefits and Tax Credits_2041_Incapacity Benefit and Severe D
Years: 1999:2011
Quarters: 1:4

Economic Activity Benefits and Tax Credits_2041_Attendance Allowance
Years: 2008:2011
Quarters: 1:4

Economic Activity Benefits and Tax Credits_2041_Attendance Allowance
Years: 2008:2011
Quarters: 1:4




