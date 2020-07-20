
setwd("C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator")
library(plyr)

rm(list=ls())

#Import Data
  #baseline
    baseline_assets<-read.csv("baseline_results_assets.csv", header = TRUE, fill = TRUE, sep = ",")
    baseline_industry<-read.csv("baseline_byindustry.csv", header = TRUE, fill = TRUE, sep = ",")
    baseline_full_assets<-read.csv("baseline_results_assets_FULL.csv", header = TRUE, fill = TRUE, sep = ",")
    
  #Biden
    biden_assets<-read.csv("biden_results_assets.csv", header = TRUE, fill = TRUE, sep = ",")
    biden_industry<-read.csv("biden_industry_results.csv", header = TRUE, fill = TRUE, sep = ",")
    biden_full_assets<-read.csv("biden_results_assets_FULL.csv", header = TRUE, fill = TRUE, sep = ",")
    biden_step_one<-read.csv("biden_1_results_assets.csv", header = TRUE, fill = TRUE, sep = ",")
    biden_step_two<-read.csv("biden_2_results_assets.csv", header = TRUE, fill = TRUE, sep = ",")
    
#Results by Asset
  #baseline
    baseline_asset_output<-ddply(baseline_assets,
                      .(asset_name, year),
                      summarize,
                      etr=weighted.mean(mettr_mix, assets),
                      assets=sum(assets))
  #Biden
    biden_asset_output<-ddply(biden_assets,
                        .(asset_name, year),
                        summarize,
                        etr=weighted.mean(mettr_mix, assets),
                        assets=sum(assets))
  #Biden Step 1
    biden_step1_asset_output<-ddply(biden_step_one,
                        .(asset_name, year),
                        summarize,
                        etr=weighted.mean(mettr_mix, assets),
                        assets=sum(assets))
  #Biden Step 2
    biden_step2_asset_output<-ddply(biden_step_two,
                                    .(asset_name, year),
                                    summarize,
                                    etr=weighted.mean(mettr_mix, assets),
                                    assets=sum(assets))
    
    
  #Debt/Equity Financed Overall
    #Baseline
      baseline_equity<-ddply(baseline_assets,
                             .(asset_name, year),
                             summarize,
                             equity_etr=weighted.mean(mettr_e, assets))
      
      baseline_debt<-ddply(baseline_assets,
                             .(asset_name, year),
                             summarize,
                             debt_etr=weighted.mean(mettr_d, assets))
    #Biden
      biden_equity<-ddply(biden_assets,
                             .(asset_name, year),
                             summarize,
                             equity_etr=weighted.mean(mettr_e, assets))
      
      biden_debt<-ddply(biden_assets,
                           .(asset_name, year),
                           summarize,
                           debt_etr=weighted.mean(mettr_d, assets))
    #Biden Step 1
      biden_step1_equity<-ddply(biden_step_one,
                          .(asset_name, year),
                          summarize,
                          equity_etr=weighted.mean(mettr_e, assets))
      
      biden_step1_debt<-ddply(biden_step_one,
                        .(asset_name, year),
                        summarize,
                        debt_etr=weighted.mean(mettr_d, assets))

    #Biden Step 2
      biden_step2_equity<-ddply(biden_step_two,
                                .(asset_name, year),
                                summarize,
                                equity_etr=weighted.mean(mettr_e, assets))
      
      biden_step2_debt<-ddply(biden_step_two,
                              .(asset_name, year),
                              summarize,
                              debt_etr=weighted.mean(mettr_d, assets))
      
#standard deviation by asset
  #baseline
    baseline_full_assets<-baseline_full_assets[(as.character(baseline_full_assets$asset_name)!=as.character(baseline_full_assets$major_asset_group) |
                                                as.character(baseline_full_assets$asset_name)!=as.character(baseline_full_assets$minor_asset_group)| 
                                                as.character(baseline_full_assets$asset_name)=="Land" |
                                                baseline_full_assets$asset_name=="Inventories") &
                                                baseline_full_assets$bea_asset_code!="",]
    
    baseline_full_assets$x_x <- NA
    baseline_full_assets$wt <- NA
    
    baseline_weighted_means<-ddply(baseline_full_assets,
                        .(year),
                        summarize,
                        assets=sum(assets)
                        )

    for (year in baseline_weighted_means$year){
      
      baseline_full_assets$x_x <- baseline_full_assets$mettr_mix[baseline_full_assets$year == year] - baseline_asset_output$etr[baseline_asset_output$year == year & baseline_asset_output$asset_name == "Overall"]
      baseline_full_assets$wt <- baseline_full_assets$assets[baseline_full_assets$year == year] / baseline_asset_output$assets[baseline_asset_output$year == year & baseline_asset_output$asset_name == "Overall"]
      baseline_weighted_means$sd_asset[baseline_weighted_means$year == year] <- sqrt(sum(baseline_full_assets$x_x[baseline_full_assets$year == year]^2 * baseline_full_assets$wt[baseline_full_assets$year == year]))
      
    }
    
  #Biden
    biden_full_assets<-biden_full_assets[(as.character(biden_full_assets$asset_name)!=as.character(biden_full_assets$major_asset_group) |
                                                  as.character(biden_full_assets$asset_name)!=as.character(biden_full_assets$minor_asset_group)| 
                                                  as.character(biden_full_assets$asset_name)=="Land" |
                                            biden_full_assets$asset_name=="Inventories") &
                                           biden_full_assets$bea_asset_code!="",]
    
    biden_full_assets$x_x <- NA
    biden_full_assets$wt <- NA
    
    biden_weighted_means<-ddply(biden_full_assets,
                                   .(year),
                                   summarize,
                                   assets=sum(assets)
    )
    

    for (year in biden_weighted_means$year){
      
      biden_full_assets$x_x <- biden_full_assets$mettr_mix[biden_full_assets$year == year] - biden_asset_output$etr[biden_asset_output$year == year & biden_asset_output$asset_name == "Overall"]
      biden_full_assets$wt <- biden_full_assets$assets[biden_full_assets$year == year] / biden_asset_output$assets[biden_asset_output$year == year & biden_asset_output$asset_name == "Overall"]
      biden_weighted_means$sd_asset[biden_weighted_means$year == year] <- sqrt(sum(biden_full_assets$x_x[biden_full_assets$year == year]^2 * biden_full_assets$wt[biden_full_assets$year == year]))
      
    }


################

#by Asset, corporate
  #Baseline
    corp_baseline_asset_output<-ddply(baseline_assets[baseline_assets$tax_treat=="corporate",],
                            .(asset_name, year),
                            summarize,
                            etr=weighted.mean(mettr_mix, assets))
    
    corp_baseline_asset_output<-reshape(corp_baseline_asset_output, 
                               idvar = "asset_name", 
                               timevar = "year", 
                               direction = "wide")
  #Biden
    corp_biden_asset_output<-ddply(biden_assets[biden_assets$tax_treat=="corporate",],
                                      .(asset_name, year),
                                      summarize,
                                      etr=weighted.mean(mettr_mix, assets))
    
    corp_biden_asset_output<-reshape(corp_biden_asset_output, 
                                        idvar = "asset_name", 
                                        timevar = "year", 
                                        direction = "wide")
  
  #Biden Step 1
    corp_biden_step1_asset_output<-ddply(biden_step_one[biden_step_one$tax_treat=="corporate",],
                                   .(asset_name, year),
                                   summarize,
                                   etr=weighted.mean(mettr_mix, assets))
    
    corp_biden_step1_asset_output<-reshape(corp_biden_step1_asset_output, 
                                     idvar = "asset_name", 
                                     timevar = "year", 
                                     direction = "wide")

  #Biden Step 2
    corp_biden_step2_asset_output<-ddply(biden_step_two[biden_step_two$tax_treat=="corporate",],
                                         .(asset_name, year),
                                         summarize,
                                         etr=weighted.mean(mettr_mix, assets))
    
    corp_biden_step2_asset_output<-reshape(corp_biden_step2_asset_output, 
                                           idvar = "asset_name", 
                                           timevar = "year", 
                                           direction = "wide")
    
#by Asset, non-corporate
  #Baseline
    noncorp_baseline_asset_output<-ddply(baseline_assets[baseline_assets$tax_treat=="non-corporate",],
                              .(asset_name, year),
                              summarize,
                              etr=weighted.mean(mettr_mix, assets))
    
    noncorp_baseline_asset_output<-reshape(noncorp_baseline_asset_output, 
                               idvar = "asset_name", 
                               timevar = "year", 
                               direction = "wide")
  #Biden

    noncorp_biden_asset_output<-ddply(biden_assets[biden_assets$tax_treat=="non-corporate",],
                                         .(asset_name, year),
                                         summarize,
                                         etr=weighted.mean(mettr_mix, assets))
    
    noncorp_biden_asset_output<-reshape(noncorp_biden_asset_output, 
                                           idvar = "asset_name", 
                                           timevar = "year", 
                                           direction = "wide")
  #Biden Step 1
    
    noncorp_biden_step1_asset_output<-ddply(biden_step_one[biden_step_one$tax_treat=="non-corporate",],
                                      .(asset_name, year),
                                      summarize,
                                      etr=weighted.mean(mettr_mix, assets))
    
    noncorp_biden_step1_asset_output<-reshape(noncorp_biden_step1_asset_output, 
                                        idvar = "asset_name", 
                                        timevar = "year", 
                                        direction = "wide")
  #Biden Step 1
    
    noncorp_biden_step2_asset_output<-ddply(biden_step_two[biden_step_two$tax_treat=="non-corporate",],
                                            .(asset_name, year),
                                            summarize,
                                            etr=weighted.mean(mettr_mix, assets))
    
    noncorp_biden_step2_asset_output<-reshape(noncorp_biden_step2_asset_output, 
                                              idvar = "asset_name", 
                                              timevar = "year", 
                                              direction = "wide")
        
#by Industry
  #Baseline
    baseline_industry_output<-ddply(baseline_industry,
                    .(major_industry, year),
                    summarize,
                    etr=weighted.mean(mettr_mix, assets))
  #Biden
    biden_industry_output<-ddply(biden_industry,
                           .(major_industry, year),
                           summarize,
                           etr=weighted.mean(mettr_mix, assets))

#Industry Standard Deviation
  #Baseline
    baseline_industry$x_x <- NA
    baseline_industry$wt <- NA
    
    for (year in baseline_weighted_means$year){
      
      baseline_industry$x_x <- baseline_industry$mettr_mix[baseline_industry$year == year] - baseline_asset_output$etr[baseline_asset_output$year == year & baseline_asset_output$asset_name == "Overall"]
      baseline_industry$wt <- baseline_industry$assets[baseline_industry$year == year] / baseline_asset_output$assets[baseline_asset_output$year == year & baseline_asset_output$asset_name == "Overall"]
      baseline_weighted_means$sd_industry[baseline_weighted_means$year == year] <- sqrt(sum(baseline_industry$x_x[baseline_industry$year == year]^2 * baseline_industry$wt[baseline_industry$year == year]))
      
    }
  #Biden
    biden_industry$x_x <- NA
    biden_industry$wt <- NA
    
    for (year in biden_weighted_means$year){
      
      biden_industry$x_x <- biden_industry$mettr_mix[biden_industry$year == year] - biden_asset_output$etr[biden_asset_output$year == year & biden_asset_output$asset_name == "Overall"]
      biden_industry$wt <- biden_industry$assets[biden_industry$year == year] / biden_asset_output$assets[biden_asset_output$year == year & biden_asset_output$asset_name == "Overall"]
      biden_weighted_means$sd_industry[biden_weighted_means$year == year] <- sqrt(sum(biden_industry$x_x[biden_industry$year == year]^2 * biden_industry$wt[biden_industry$year == year]))
      
    } 

#Final data sets

  #join sd and other data
  #baseline_industry_output<-join(baseline_industry_output, baseline_weighted_means, type="left", by="year")
  #baseline_asset_output<-join(baseline_asset_output, baseline_weighted_means, type="left", by="year")

  #clean
    #Baseline
      baseline_asset_output = subset(baseline_asset_output, select = -c(assets))
    #Biden
      biden_asset_output = subset(biden_asset_output, select = -c(assets))
      biden_step1_asset_output = subset(biden_step1_asset_output, select = -c(assets))
      biden_step2_asset_output = subset(biden_step2_asset_output, select = -c(assets))
      
  #to wide 
    #Baseline
      baseline_asset_output<-reshape(baseline_asset_output, 
                            idvar = "asset_name", 
                            timevar = "year", 
                            direction = "wide")

      baseline_industry_output<-reshape(baseline_industry_output, 
                               idvar = "major_industry", 
                               timevar = "year", 
                               direction = "wide")
    #Biden
      biden_asset_output<-reshape(biden_asset_output, 
                                     idvar = "asset_name", 
                                     timevar = "year", 
                                     direction = "wide")
      
      biden_industry_output<-reshape(biden_industry_output, 
                                        idvar = "major_industry", 
                                        timevar = "year", 
                                        direction = "wide")
  
    #Biden Step 1
      biden_step1_asset_output<-reshape(biden_step1_asset_output, 
                                  idvar = "asset_name", 
                                  timevar = "year", 
                                  direction = "wide")
      
    #Biden Step 2
      biden_step2_asset_output<-reshape(biden_step2_asset_output, 
                                        idvar = "asset_name", 
                                        timevar = "year", 
                                        direction = "wide")
 
  #Add Standard Deviation, Equity, and Debt data
    #Baseline
      #Asset Table
        levels(baseline_asset_output$asset_name) <- c(levels(baseline_asset_output$asset_name), "Debt Financed")
        levels(baseline_asset_output$asset_name) <- c(levels(baseline_asset_output$asset_name), "Equity Financed")
        levels(baseline_asset_output$asset_name) <- c(levels(baseline_asset_output$asset_name), "Standard Deviation")
        baseline_asset_output<-rbind(baseline_asset_output, c("Debt Financed", baseline_debt$debt_etr[baseline_debt$asset_name == "Overall"]))
        baseline_asset_output<-rbind(baseline_asset_output, c("Equity Financed", baseline_equity$equity_etr[baseline_equity$asset_name == "Overall"]))
        baseline_asset_output<-rbind(baseline_asset_output, c("Standard Deviation", baseline_weighted_means$sd_asset))
        
      #Industry Table
        levels(baseline_industry_output$major_industry) <- c(levels(baseline_industry_output$major_industry), "Standard Deviation")
        baseline_industry_output<-rbind(baseline_industry_output, c("Standard Deviation", baseline_weighted_means$sd_industry))
    #Biden
      #Asset Table
        levels(biden_asset_output$asset_name) <- c(levels(biden_asset_output$asset_name), "Debt Financed")
        levels(biden_asset_output$asset_name) <- c(levels(biden_asset_output$asset_name), "Equity Financed")
        levels(biden_asset_output$asset_name) <- c(levels(biden_asset_output$asset_name), "Standard Deviation")
        biden_asset_output<-rbind(biden_asset_output, c("Debt Financed", biden_debt$debt_etr[biden_debt$asset_name == "Overall"]))
        biden_asset_output<-rbind(biden_asset_output, c("Equity Financed", biden_equity$equity_etr[biden_equity$asset_name == "Overall"]))
        biden_asset_output<-rbind(biden_asset_output, c("Standard Deviation", biden_weighted_means$sd_asset))
      #Industry Table
        levels(biden_industry_output$major_industry) <- c(levels(biden_industry_output$major_industry), "Standard Deviation")
        biden_industry_output<-rbind(biden_industry_output, c("Standard Deviation", biden_weighted_means$sd_industry))
 
    #Biden Step 1
      #Asset Table
        levels(biden_step1_asset_output$asset_name) <- c(levels(biden_step1_asset_output$asset_name), "Debt Financed")
        levels(biden_step1_asset_output$asset_name) <- c(levels(biden_step1_asset_output$asset_name), "Equity Financed")
        levels(biden_step1_asset_output$asset_name) <- c(levels(biden_step1_asset_output$asset_name), "Standard Deviation")
        biden_step1_asset_output<-rbind(biden_step1_asset_output, c("Debt Financed", biden_step1_debt$debt_etr[biden_step1_debt$asset_name == "Overall"]))
        biden_step1_asset_output<-rbind(biden_step1_asset_output, c("Equity Financed", biden_step1_equity$equity_etr[biden_step1_equity$asset_name == "Overall"]))
        biden_step1_asset_output<-rbind(biden_step1_asset_output, c("Standard Deviation", biden_weighted_means$sd_asset))
        
    #Biden Step 1
      #Asset Table
        levels(biden_step2_asset_output$asset_name) <- c(levels(biden_step2_asset_output$asset_name), "Debt Financed")
        levels(biden_step2_asset_output$asset_name) <- c(levels(biden_step2_asset_output$asset_name), "Equity Financed")
        levels(biden_step2_asset_output$asset_name) <- c(levels(biden_step2_asset_output$asset_name), "Standard Deviation")
        biden_step2_asset_output<-rbind(biden_step2_asset_output, c("Debt Financed", biden_step2_debt$debt_etr[biden_step2_debt$asset_name == "Overall"]))
        biden_step2_asset_output<-rbind(biden_step2_asset_output, c("Equity Financed", biden_step2_equity$equity_etr[biden_step2_equity$asset_name == "Overall"]))
        biden_step2_asset_output<-rbind(biden_step2_asset_output, c("Standard Deviation", biden_weighted_means$sd_asset))
        
        
  #Output
        write.csv(baseline_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/baseline_assets_table.csv",  row.names = TRUE)
        write.csv(baseline_industry_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/baseline_industry_table.csv",  row.names = TRUE)
        write.csv(corp_baseline_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/baseline_corp_asset_table.csv",  row.names = TRUE)
        write.csv(noncorp_baseline_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/baseline_noncorp_asset_table.csv",  row.names = TRUE)
        write.csv(biden_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_assets_table.csv",  row.names = TRUE)
        write.csv(biden_step1_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_step1_assets_table.csv",  row.names = TRUE)
        write.csv(biden_step2_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_step2_assets_table.csv",  row.names = TRUE)
        write.csv(biden_industry_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_industry_table.csv",  row.names = TRUE)
        write.csv(corp_biden_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_corp_asset_table.csv",  row.names = TRUE)
        write.csv(corp_biden_step1_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_step1_corp_asset_table.csv",  row.names = TRUE)
        write.csv(corp_biden_step2_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_step2_corp_asset_table.csv",  row.names = TRUE)
        write.csv(noncorp_biden_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_noncorp_asset_table.csv",  row.names = TRUE)
        write.csv(noncorp_biden_step1_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_step1_noncorp_asset_table.csv",  row.names = TRUE)
        write.csv(noncorp_biden_step2_asset_output, "C:/Users/kylep/Documents/Github/CCC/Cost-of-Capital-Calculator/biden_step2_noncorp_asset_table.csv",  row.names = TRUE)

        
      