for (k in 1:length(kantonal_short) ) {
  
  cat(paste0("\nErmittle Daten für folgende Vorlage: ",kantonal_short[k],"\n"))
  
  results <- get_results_kantonal(json_data_kantone,
                                  kantonal_number[k],
                                  kantonal_add[k])
  

#Simulation Gemeinden
#source("data_simulation_gemeinden.R")
  
  #Daten anpassen Gemeinden
  results <- treat_gemeinden(results)
  results <- format_data_g(results)
  
  #Kantonsergebnis hinzufügen
  Ja_Stimmen_Kanton <- get_results_kantonal(json_data_kantone,
                                            kantonal_number[k],
                                            kantonal_add[k],
                                            "kantonal")
  
  results$Ja_Stimmen_In_Prozent_Kanton <- Ja_Stimmen_Kanton
#results$Ja_Stimmen_In_Prozent_Kanton <- 55  #Ja_Stimmen_Kanton Simulation
  
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
  
  #Ausgezählte Gemeinden auswählen
  results_notavailable <- results[results$Gebiet_Ausgezaehlt == FALSE,]
  results <- results[results$Gebiet_Ausgezaehlt == TRUE,]
  
  #Sind schon Daten vorhanden?
  if (nrow(results) > 0) {
    
    #Daten anpassen
    results <- augment_raw_data(results)
    
    #Intros generieren
    results <- normal_intro(results)

    
    
#Vergleich innerhalb des Kantons (falls Daten vom Kanton vorhanden) -> Ändern von FALSE auf TRUE
    
    if (json_data_kantone$kantone$vorlagen[[kantonal_number[k]]]$vorlageBeendet[[kantonal_add[k]]] == TRUE) {
      
    if (kantonal_short[k] == "BS_Primaten") {
    cat("Kein kantonaler Vergleich\n\n")  
    } else {  
    results <- kanton_storyfinder_kantonal(results)
    }
    }
    
    #Textvorlagen laden
    Textbausteine <- as.data.frame(read_excel(paste0("Data/Textbausteine_LENA_",abstimmung_date,".xlsx"), 
                                              sheet = kantonal_short[k]))

    cat("Textvorlagen geladen\n\n")
    
    #Texte einfügen
    results <- build_texts(results)
    
    #Variablen ersetzen 
    results <- replace_variables(results)
    
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
  #write.xlsx(results,paste0(kantonal_short[k],"_texte.xlsx"))
  
  ###Output generieren für Datawrapper
  output_dw <- get_output_gemeinden(results)
  
  write.csv(output_dw,paste0("Output/",kantonal_short[k],"_dw.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  
  cat(paste0("\nGenerated output for Vorlage ",kantonal_short[k],"\n"))
  
  
}
