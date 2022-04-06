for (k in 1:length(kantonal_short_special) ) {
  
  cat(paste0("\nErmittle Daten für folgende Vorlage: ",kantonal_short_special[k],"\n"))
  
  results <- get_results_kantonal(json_data_kantone,
                                  kantonal_number_special[k],
                                  kantonal_add_special[k])

#Simulation Gemeinden
#source("data_simulation_gemeinden.R")
 

  #Daten anpassen Gemeinden
  results <- treat_gemeinden(results)
  results <- format_data_g(results)
 

  #Wie viele Gemeinden sind ausgezählt?
  cat(paste0(sum(results$Gebiet_Ausgezaehlt)," Gemeinden sind ausgezählt.\n"))
  
  #Neue Variablen
  results <- results %>%
    mutate(Ja_Nein = NA,
           Oui_Non = NA,
           Nein_Stimmen_In_Prozent = NA,
           Unentschieden = NA,
           Einstimmig_Ja = NA,
           Einstimmig_Nein = NA,
           kleine_Gemeinde = NA,
           Highest_Yes_Kant = FALSE,
           Highest_No_Kant = FALSE,
           Storyboard = NA,
           Text_d = "Die Resultate dieser Gemeinde sind noch nicht bekannt.",
           Text_f = "Les résultats ne sont pas encore connus dans cette commune.",
           Text_i = "I resultati di questa comune non sono ancora noti.")
  
  hist_check <- FALSE
  
  #Gegenvorschlag hinzufügen
  results_gegenvorschlag <- get_results_kantonal(json_data_kantone,
                                                 kantonal_number_special[k],
                                                 kantonal_add_special[k]+1)
  
#Simulation Gemeinden
#source("data_simulation_gegenvorschlag.R")

  results_gegenvorschlag <- results_gegenvorschlag[,c(3:6,11)]
  results_gegenvorschlag$neinStimmenInProzent <- 100-results_gegenvorschlag$jaStimmenInProzent
  
  colnames(results_gegenvorschlag) <- c("Gebiet_Ausgezaehlt_Gegenvorschlag","Ja_Prozent_Gegenvorschlag","Ja_Absolut_Gegenvorschlag","Nein_Absolut_Gegenvorschlag",
                                        "Gemeinde_Nr","Nein_Prozent_Gegenvorschlag")

  results <- merge(results,results_gegenvorschlag)
  

  #Stichentscheid hinzufügen
  #results_stichentscheid <- get_results_kantonal(json_data_kantone,
  #                                               kantonal_number_special[k],
  #                                               kantonal_add_special[k]+2)
  
  #Simulation Gemeinden
  #source("data_simulation_stichentscheid.R")
  
  #results_stichentscheid  <- results_stichentscheid[,c(3:4,11)]
  #results_stichentscheid$neinStimmenInProzent <- 100-results_stichentscheid$jaStimmenInProzent
  
  #colnames(results_stichentscheid) <- c("Gebiet_Ausgezaehlt_Stichentscheid","Stichentscheid_Zustimmung_Hauptvorlage","Gemeinde_Nr","Stichentscheid_Zustimmung_Gegenvorschlag")
  
  #results <- merge(results,results_stichentscheid)

  #Ausgezählte Gemeinden auswählen
  results_notavailable <- results[results$Gebiet_Ausgezaehlt == FALSE |
                                    results$Gebiet_Ausgezaehlt_Gegenvorschlag == FALSE,]
  
  results <- results[results$Gebiet_Ausgezaehlt == TRUE &
                       results$Gebiet_Ausgezaehlt_Gegenvorschlag == TRUE,]
  
  #Sind schon Daten vorhanden?
  if (nrow(results) > 0) {
    
    #Daten anpassen
    results <- augment_raw_data(results)
    
    #Texte generieren
    results <- special_intro(results)
    
    #Textvorlagen laden
    Textbausteine <- as.data.frame(read_excel(paste0("Data/Textbausteine_LENA_",abstimmung_date,".xlsx"), 
                                              sheet = kantonal_short_special[k]))
    cat("Textvorlagen geladen\n\n")


    #Texte einfügen
    results <- build_texts(results)
    
 
    #Variablen ersetzen 
    results <- replace_variables_special(results)
    
    ###Texte anpassen und optimieren
    results <- excuse_my_french(results)
    
    #Print out texts
    #cat(paste0(results$Gemeinde_d,"\n",results$Text_d,"\n\n",results$Text_f,collapse="\n\n"))
    
  }
  ###Ausgezählte und nicht ausgezählte Gemeinden wieder zusammenführen -> Immer gleiches Format für Datawrapper
  if (nrow(results_notavailable) > 0) {
    
    results_notavailable$Ja_Stimmen_In_Prozent <- 0
    results_notavailable$Nein_Stimmen_In_Prozent <- 0
    results_notavailable$Gemeinde_color <- 50
    
    results <- rbind(results,results_notavailable) %>%
      arrange(Gemeinde_Nr)
    
  }
  

  
  #Texte speichern
  #library(xlsx)
  #write.xlsx(results,paste0(kantonal_short_special[k],"_texte.xlsx"))
  
  ###Output generieren für Datawrapper
  output_dw <- get_output_gemeinden(results)
  
  write.csv(output_dw,paste0("Output/",kantonal_short_special[k],"_dw.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  
  cat(paste0("\nGenerated output for Vorlage ",kantonal_short_special[k],"\n"))
  
}

