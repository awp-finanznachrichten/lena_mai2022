#Daten für Uebersicht
data_overview <- data.frame(50,50,"Abstimmung_de","Abstimmung_fr","Abstimmung_it")
colnames(data_overview) <- c("Ja","Nein","Abstimmung_de","Abstimmung_fr","Abstimmung_it")

for (i in 1:length(vorlagen_short)) {

  cat(paste0("\nErmittle Daten für folgende Vorlage: ",vorlagen$text[i],"\n"))
  
  ###Nationale Resultate aus JSON auslesen
  results_national <- get_results(json_data,i,level="national")
  
###Nationale Resultate simulieren
#set.seed(i)
#results_national$jaStimmenInProzent <- sample(0:100,1)

  ###Resultate aus JSON auslesen für Gemeinden
  results <- get_results(json_data,i)
  
#Simulation Gemeinden
#source("data_simulation_gemeinden.R")
  

  #Emergency adapt
  #results$gebietAusgezaehlt[155] <- TRUE
  #results$gebietAusgezaehlt[897] <- TRUE
  #results$gebietAusgezaehlt[898] <- TRUE
  #results$gebietAusgezaehlt[899] <- TRUE
  
  #Daten anpassen Gemeinden
  results <- treat_gemeinden(results)
  results <- format_data_g(results)
  
  #Kantonsdaten hinzufügen
  results_kantone <- get_results(json_data,i,"cantonal")
  
#Simulation Kantone
#source("data_simulation_kantone.R")
  
  Ja_Stimmen_Kanton <- results_kantone %>%
    select(Kantons_Nr,jaStimmenInProzent) %>%
    rename(Ja_Stimmen_In_Prozent_Kanton = jaStimmenInProzent) %>%
    mutate(Highest_Yes_Kant = FALSE,
           Highest_No_Kant = FALSE)
  
  results <- merge(results,Ja_Stimmen_Kanton)
  results_all <- results
  
  #Alle Daten speichern
  write.csv(results_all,paste0("Output/",vorlagen_short[i],"_all_data.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

  #Wie viele Gemeinden sind ausgezählt
  cat(paste0(sum(results$Gebiet_Ausgezaehlt)," Gemeinden sind ausgezählt.\n"))
  

  #Neue Variablen
  results <- results %>%
    mutate(Ja_Nein = NA,
           Oui_Non = NA,
           Unentschieden = NA,
           Einstimmig_Ja = NA,
           Einstimmig_Nein = NA,
           kleine_Gemeinde = NA,
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
    
    #LENA-Classics (falls alle Gemeinden ausgezählt):
    if (nrow(results_notavailable) == 0) {
      
      results <- lena_classics(results)
      
    }  
    
    #Historischer Vergleich (falls vorhanden)
    
    #Check Vorlagen-ID
    
    if (vorlagen$id[i] == "6510") { 
      hist_check <- TRUE 
      data_hist <- format_data_hist(daten_tierversuche_bfs)
      results <- merge(results,data_hist,all.x = TRUE)
      results <- hist_storyfinder(results)

    }
    
    if (vorlagen$id[i] == "6520") { 
      hist_check <- TRUE 
      data_hist <- format_data_hist(daten_tabak_bfs)
      results <- merge(results,data_hist,all.x = TRUE)
      results <- hist_storyfinder(results)
      
    }
    
  
    #Vergleich innerhalb des Kantons (falls alle Daten vom Kanton vorhanden)
    
    #Check Vorlagen-ID
    if (vorlagen$id[i] == "6530" || vorlagen$id[i] == "6540") {
      
      #Falls mindestens ein Kanton ausgezählt -> Stories für die Kantone finden
      
      if (length(unique(results_notavailable$Kantons_Nr)) < 26) {
        
        results <- kanton_storyfinder(results)
        
      }
      
    }
    
    
    ###Storybuilder
    
    #Textvorlagen laden
    Textbausteine <- as.data.frame(read_excel(paste0("Data/Textbausteine_LENA_",abstimmung_date,".xlsx"), 
                                              sheet = vorlagen_short[i]))
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
    
    if (hist_check == TRUE) {
      results_notavailable$Hist_Ja_Stimmen_In_Prozent <- NA
      results_notavailable$Hist_Ja_Stimmen_Absolut <- NA
      results_notavailable$Hist_Nein_Stimmen_In_Prozent <- NA
      results_notavailable$Hist_Nein_Stimmen_Absolut <- NA
    }
    
    results <- rbind(results,results_notavailable) %>%
      arrange(Gemeinde_Nr)
    
  }
  

  #Texte speichern
  #library(xlsx)
  #write.xlsx(results,paste0(vorlagen_short[i],"_texte.xlsx"),row.names = FALSE)
  
  ###Output generieren für Datawrapper
  
  #Output Abstimmungen Gemeinde
  output_dw <- get_output_gemeinden(results)

  
  
  #Output speichern
  write.csv(output_dw,paste0("Output/",vorlagen_short[i],"_dw.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  
  count_non_gemeinden <- output_dw[output_dw$Nein_Stimmen_In_Prozent>50,]
  
  count_yes_gemeinden <- output_dw[output_dw$Ja_Stimmen_In_Prozent>50,]
  
  count_tie_gemeinden <- output_dw[output_dw$Ja_Stimmen_In_Prozent == 50,]
  
  print(paste0("Nein-Stimmen: ",nrow(count_non_gemeinden),"; Ja-Stimmen: ",nrow(count_yes_gemeinden),
               "; Unentschieden: ",nrow(count_tie_gemeinden)))
  
  #Stimmbeteiligung und Ständemehr
  print(paste0("Stimmbeteiligung: ",results_national$stimmbeteiligungInProzent," %"))
  print(paste0("Stände JA: ",results_national$jaStaendeGanz+(results_national$jaStaendeHalb/2)))
  print(paste0("Stände NEIN: ",results_national$neinStaendeGanz+(results_national$neinStaendeHalb/2)))
  

  
  source("outputs_einzugsgebiete.R", encoding = "UTF-8")
  
  #Log Kantone
  cat(paste0("\n\n",Sys.time()," ",vorlagen_short[i],"\n"),file="Output/log_file.txt",append = TRUE)
  
  #Output Abstimmungen Kantone
  output_dw_kantone <- get_output_kantone(results)
  
  write.csv(output_dw_kantone,paste0("Output/",vorlagen_short[i],"_dw_kantone.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  
  cat(paste0("\nGenerated output for Vorlage ",vorlagen_short[i],"\n"))
  
  
  #Datawrapper-Karten aktualisieren
  undertitel_de <- "Es sind noch keine Gemeinden ausgezählt."
  undertitel_fr <- "Aucun résultat n'est encore connu."
  undertitel_it <- "Nessun risultato è ancora noto."

  
  if (sum(results$Gebiet_Ausgezaehlt) > 0 ) {
    
    undertitel_de <- paste0("Es sind <b>",sum(results$Gebiet_Ausgezaehlt),"</b> von <b>",nrow(results),
                            "</b> Gemeinden ausgezählt. Stand: <b>",
                            round(results_national$jaStimmenInProzent,1)," %</b> Ja, <b>",
                            round(100-results_national$jaStimmenInProzent,1)," %</b> Nein")
    
    undertitel_fr <- paste0("Les résultats de <b>",sum(results$Gebiet_Ausgezaehlt),"</b> des <b>",nrow(results),
                            "</b> communes sont connus. Etat: <b>",
                            round(results_national$jaStimmenInProzent,1)," %</b> oui, <b>",
                            round(100-results_national$jaStimmenInProzent,1)," %</b> non")
    
    undertitel_it <- paste0("I risultati di <b>",sum(results$Gebiet_Ausgezaehlt),"</b> dei <b>",nrow(results),
                            "</b> comuni sono noti. Stato: <b>",
                            round(results_national$jaStimmenInProzent,1)," %</b> sì, <b>",
                            round(100-results_national$jaStimmenInProzent,1)," %</b> no")
  }
   
    #Karten Gemeinden
    dw_edit_chart(datawrapper_codes[i,2],intro=undertitel_de,annotate=paste0("Letzte Aktualisierung: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
    dw_publish_chart(datawrapper_codes[i,2])
    
    dw_edit_chart(datawrapper_codes[i,4],intro=undertitel_fr,annotate=paste0("dernière mise à jour: ",format(Sys.time(),"%d.%m.%Y %Hh%M")))
    dw_publish_chart(datawrapper_codes[i,4])
    
    dw_edit_chart(datawrapper_codes[i,6],intro=undertitel_it,annotate=paste0("Ultimo aggiornamento: ",format(Sys.time(),"%d.%m.%Y %H:%M")))
    dw_publish_chart(datawrapper_codes[i,6])
    
    #Karten Kantone
    dw_edit_chart(datawrapper_codes[i,3],intro=undertitel_de,annotate=paste0("Letzte Aktualisierung: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
    dw_publish_chart(datawrapper_codes[i,3])
    
    dw_edit_chart(datawrapper_codes[i,5],intro=undertitel_fr,annotate=paste0("dernière mise à jour: ",format(Sys.time(),"%d.%m.%Y %Hh%M")))
    dw_publish_chart(datawrapper_codes[i,5])
    
    dw_edit_chart(datawrapper_codes[i,7],intro=undertitel_it,annotate=paste0("Ultimo aggiornamento: ",format(Sys.time(),"%d.%m.%Y %H:%M")))
    dw_publish_chart(datawrapper_codes[i,7])
    


#Eintrag für Uebersicht
uebersicht_text_de <- paste0("<b>",vorlagen$text[i],"</b><br>",
                             "Es sind noch keine Gemeinden ausgezählt.")

uebersicht_text_fr <- paste0("<b>",vorlagen_fr$text[i],"</b><br>",
                             "Aucun résultat n'est encore connu.")

uebersicht_text_it <- paste0("<b>",vorlagen_it$text[i],"</b><br>",
                             "Nessun risultato è ancora noto.")
Ja_Anteil <- 50
Nein_Anteil <- 50
  
if (sum(results$Gebiet_Ausgezaehlt) > 0 ) {  

uebersicht_text_de <- paste0("<b>",vorlagen$text[i],"</b><br>",
                          sum(results$Gebiet_Ausgezaehlt)," von ",nrow(results)," Gemeinden ausgezählt (",
                          round((sum(results$Gebiet_Ausgezaehlt)*100)/nrow(results),1),
                          "%)")

uebersicht_text_fr <- paste0("<b>",vorlagen_fr$text[i],"</b><br>",
                             sum(results$Gebiet_Ausgezaehlt)," des ",nrow(results)," communes sont connus (",
                             round((sum(results$Gebiet_Ausgezaehlt)*100)/nrow(results),1),
                             "%)")

uebersicht_text_it <- paste0("<b>",vorlagen_it$text[i],"</b><br>",
                             sum(results$Gebiet_Ausgezaehlt)," dei ",nrow(results)," comuni sono noti (",
                             round((sum(results$Gebiet_Ausgezaehlt)*100)/nrow(results),1),
                             "%)")

Ja_Anteil <- round(results_national$jaStimmenInProzent,1)
Nein_Anteil <- round(100-results_national$jaStimmenInProzent,1)

}

entry_overview <- data.frame(Ja_Anteil,Nein_Anteil,uebersicht_text_de,uebersicht_text_fr,uebersicht_text_it)
colnames(entry_overview) <- c("Ja","Nein","Abstimmung_de","Abstimmung_fr","Abstimmung_it")
data_overview <- rbind(data_overview,entry_overview)

}

#Uebersicht für Datawrapper
data_overview <- data_overview[-1,]

write.csv(data_overview,"Output/Uebersicht_dw.csv", na = "", row.names = FALSE, fileEncoding = "UTF-8")

#Charts Uebersicht

dw_edit_chart("7rtNh",intro=paste0("Letzte Aktualisierung: ",format(Sys.time(),"%H:%M Uhr")))
dw_publish_chart("7rtNh")

dw_edit_chart("GZxtj",intro=paste0("Dernière mise à jour: ",format(Sys.time(),"%Hh%M")))
dw_publish_chart("GZxtj")

dw_edit_chart("Yxy8g",intro=paste0("Ultimo aggiornamento: ",format(Sys.time(),"%H:%M")))
dw_publish_chart("Yxy8g")

