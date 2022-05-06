library(rsvg)
library(magick)
library(DatawRappr)

link_json <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20220213-eidgAbstimmung.json" 
json_data <- fromJSON(link_json, flatten = TRUE)

#Vorlagen umbenennen
vorlagen$text[1] <- "Änderung des Filmgesetzes"
vorlagen$text[2] <- "Änderung des Transplantationsgesetzes"
vorlagen$text[3] <- "Ausbau von Frontex"

vorlagen_fr$text[1] <- "Modification de la loi sur le cinéma"
vorlagen_fr$text[2] <- "Modification de la loi sur la transplantation"
vorlagen_fr$text[3] <- "Développement de Frontex"

vorlagen_it$text[1] <- "Modifica della legge sul cinema"
vorlagen_it$text[2] <- "Modifica della legge sui trapianti"
vorlagen_it$text[3] <- "Ampliamento di Frontex"


for (i in 1:length(vorlagen_short) ) {

#Nationale Ergebnisse holen
results_national <- get_results(json_data,i,level="national")
Ja_Anteil <- round(results_national$jaStimmenInProzent,1)
Nein_Anteil <- round(100-results_national$jaStimmenInProzent,1)
Stimmbeteiligung <- round(results_national$stimmbeteiligungInProzent,1)
Staende_Ja <- results_national$jaStaendeGanz+(results_national$jaStaendeHalb/2)
Staende_Nein <- results_national$neinStaendeGanz+(results_national$neinStaendeHalb/2)



#####DEUTSCH

###Flexible Grafik-Bausteine erstellen
titel <- vorlagen$text[i]
undertitel_text <- paste0("<b>Eidgenössische Volksabstimmung vom 15. Mai 2022</b>")

#Undertitel Balken
length_yes <- round(Ja_Anteil/5)
length_no <- round(Nein_Anteil/5)
length_stimmbeteiligung <- round(Stimmbeteiligung/5)
length_Staende_Ja <- round(((Staende_Ja*100)/23)/5)
length_Staende_Nein <- round(((Staende_Nein*100)/23)/5)

undertitel_balken_firstline <- paste0("<b>",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",20),
                                      "</b>Volk",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",46),
                                      "</b>Stände",
                                      strrep("&nbsp;",22),
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      "</b>Stimmbeteiligung</b>"
                                      )

undertitel_balken_secondline <- paste0("Ja ",gsub("[.]",",",Ja_Anteil),"% ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_yes),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_no),"</b>",
                                       " ",gsub("[.]",",",Nein_Anteil),"% Nein",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",2),"</b>",
                                       "Ja ",Staende_Ja," ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Ja),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Nein),"</b>",
                                       " ",Staende_Nein," Nein",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",2),"</b>",
                                       '<b style="background:	#696969; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_stimmbeteiligung),"</b>",
                                       '<b style="background:		#DCDCDC; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",20-length_stimmbeteiligung),"</b> ",
                                       gsub("[.]",",",Stimmbeteiligung),"%"
                                       )

undertitel_all <- paste0(undertitel_text,"<br><br>",
                         undertitel_balken_firstline,
                         "<br>",
                         undertitel_balken_secondline,
                         "<br>&nbsp;")

#Fix 0
undertitel_all <- gsub('Ja 0 <b style="background:	#89CFF0; color:black; padding:1px 6px">',
                       'Ja 0 <b style="background:	#89CFF0; color:black; padding:1px 0px">',
                       undertitel_all)
undertitel_all <- gsub('6px"></b> 0 Nein',
                       '0px"></b> 0 Nein',
                       undertitel_all)

footer <- paste0('Quelle: BFS, Lena',
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",25),
                 "</b>Stand: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr"),
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",25),
                 "</b>Grafik: Keystone-SDA"
                 )

###Vorlage kopieren
new_chart <-dw_copy_chart("Tfr6N")

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              intro=undertitel_all,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/",vorlagen_short[i],"_dw_kantone.csv")),
              axes=list("values"="Kanton_color"),
              folderId = "100300")

###Bilddaten speichen und hochladen für Kanton

setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Kantone_",vorlagen_short[i],"_DE")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")


#Als SVG &  EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Kantone_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Kantone_",vorlagen_short[i],".eps"),width=4800)


#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN ",vorlagen_short[i]," D\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAFIK - Eidgenoessische Volksabstimmung vom 15. Mai 2022 - ",titel,". Diese Infografik wurde automatisiert vom Schreibroboter Lena erstellt. (Infografik KEYSTONE)\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=Die Infografik kann im Grafikformat EPS und SVG bezogen werden. Diese Infografik wurde automatisiert vom Schreibroboter Lena erstellt.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
library(zip)
zip::zip(zipfile = paste0('LENA_Kantone_',vorlagen_short[i],'_DEU.zip'), 
         c(paste0("LENA_Kantone_",vorlagen_short[i],".eps"),paste0("LENA_Kantone_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Daten hochladen
#library(RCurl)
#ftp_adress <- paste0("ftp://ftp.keystone.ch/",paste0('LENA_Kantone_',vorlagen_short[i],'_DEU.zip'))
#ftpUpload(paste0('LENA_Kantone_',vorlagen_short[i],'_DEU.zip'), ftp_adress,userpwd="keyg_in:5r6368vz")

setwd("..")
setwd("..")


###Vorlage kopieren
new_chart <-dw_copy_chart("kDkMR")

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              intro=undertitel_text,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/",vorlagen_short[i],"_dw.csv")),
              axes=list("values"="Gemeinde_color"),
              folderId = "100300")


##Bilddaten speichen und hochladen für Gemeinde
setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Gemeinden_",vorlagen_short[i],"_DE")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN GEMEINDEN ",vorlagen_short[i]," D\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAFIK - Eidgenoessische Volksabstimmung vom 15. Mai 2022 Resultate Gemeinden - ",titel,". Diese Infografik wurde automatisiert vom Schreibroboter Lena erstellt.(Infografik KEYSTONE)\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=Die Infografik kann im Grafikformat EPS und SVG bezogen werden. Diese Infografik wurde automatisiert vom Schreibroboter Lena erstellt.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
library(zip)
zip::zip(zipfile = paste0('LENA_Gemeinden_',vorlagen_short[i],'_DEU.zip'), 
         c(paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Daten hochladen
#library(RCurl)
#ftp_adress <- paste0("ftp://ftp.keystone.ch/",paste0('LENA_Gemeinden_',vorlagen_short[i],'_DEU.zip'))
#ftpUpload(paste0('LENA_Gemeinden_',vorlagen_short[i],'_DEU.zip'), ftp_adress,userpwd="keyg_in:5r6368vz")

setwd("..")
setwd("..")

#####FRANZÖSISCH

###Flexible Grafik-Bausteine erstellen
titel <- vorlagen_fr$text[i]
undertitel_text <- paste0("<b>Votation populaire du 15 mai 2022</b>")



undertitel_balken_firstline <- paste0("<b>",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",10),
                                      "</b>Majorité du peuple",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",20),
                                      "</b>Majorité des Cantons",
                                      strrep("&nbsp;",6),
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      "</b>Taux de participation</b>"
)

undertitel_balken_secondline <- paste0("Oui ",gsub("[.]",",",Ja_Anteil),"% ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_yes),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_no),"</b>",
                                       " ",gsub("[.]",",",Nein_Anteil),"% Non",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",1),"</b>",
                                       "Oui ",Staende_Ja," ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Ja),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Nein),"</b>",
                                       " ",Staende_Nein," Non",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",0),"</b>",
                                       '<b style="background:	#696969; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_stimmbeteiligung),"</b>",
                                       '<b style="background:		#DCDCDC; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",20-length_stimmbeteiligung),"</b> ",
                                       gsub("[.]",",",Stimmbeteiligung),"%"
)

undertitel_all <- paste0(undertitel_text,"<br><br>",
                         undertitel_balken_firstline,
                         "<br>",
                         undertitel_balken_secondline,
                         "<br>&nbsp;")

#Fix 0
undertitel_all <- gsub('Oui 0 <b style="background:	#89CFF0; color:black; padding:1px 6px">',
                       'Oui 0 <b style="background:	#89CFF0; color:black; padding:1px 0px">',
                       undertitel_all)
undertitel_all <- gsub('6px"></b> 0 Non',
                       '0px"></b> 0 Non',
                       undertitel_all)

footer <- paste0('Source: OFS, Lena',
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",22),
                 "</b>Etat: ",format(Sys.time(),"%d.%m.%Y %Hh%M"),
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",22),
                 "</b>Infographie: Keystone-ATS"
                 )

###Vorlage kopieren
new_chart <-dw_copy_chart("Tfr6N")


#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              language="fr-CH",
              intro=undertitel_all,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/",vorlagen_short[i],"_dw_kantone.csv")),
              axes=list("values"="Kanton_color"),
              visualize = list("legend"=list("title"="Proportion de Oui")),
              folderId = "100300")

###Bilddaten speichen und hochladen für Kanton

setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Kantone_",vorlagen_short[i],"_FR")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Kantone_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Kantone_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN ",vorlagen_short[i]," F\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAPHIE - Votation populaire du 15 mai 2022 - ",titel,". Cette infographie a été réalisée de manière automatisée par le robot d'écriture Lena. (Infographie KEYSTONE)\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=L'infographie peut être obtenue aux formats graphiques EPS et SVG. Cette infographie a été réalisée de manière automatisée par le robot d'écriture Lena.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
library(zip)
zip::zip(zipfile = paste0('LENA_Kantone_',vorlagen_short[i],'_FR.zip'), 
         c(paste0("LENA_Kantone_",vorlagen_short[i],".eps"),paste0("LENA_Kantone_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Daten hochladen
#library(RCurl)
#ftp_adress <- paste0("ftp://ftp.keystone.ch/",paste0('LENA_Kantone_',vorlagen_short[i],'_FR.zip'))
#ftpUpload(paste0('LENA_Kantone_',vorlagen_short[i],'_FR.zip'), ftp_adress,userpwd="keyg_in:5r6368vz")

setwd("..")
setwd("..")


###Vorlage kopieren
new_chart <-dw_copy_chart("kDkMR")

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              language="fr-CH",
              intro=undertitel_text,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/",vorlagen_short[i],"_dw.csv")),
              axes=list("values"="Gemeinde_color"),
              visualize = list("legend"=list("title"="Proportion de Oui")),
              folderId = "100300")


##Bilddaten speichen und hochladen für Gemeinde
setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Gemeinden_",vorlagen_short[i],"_FR")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN GEMEINDEN ",vorlagen_short[i]," F\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAPHIE - Votation populaire du 15 mai 2022 - ",titel,". Cette infographie a été réalisée de manière automatisée par le robot d'écriture Lena. (Infographie KEYSTONE)\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=L'infographie peut être obtenue aux formats graphiques EPS et SVG. Cette infographie a été réalisée de manière automatisée par le robot d'écriture Lena.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
library(zip)
zip::zip(zipfile = paste0('LENA_Gemeinden_',vorlagen_short[i],'_FR.zip'), 
         c(paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Daten hochladen
#library(RCurl)
#ftp_adress <- paste0("ftp://ftp.keystone.ch/",paste0('LENA_Gemeinden_',vorlagen_short[i],'_FR.zip'))
#ftpUpload(paste0('LENA_Gemeinden_',vorlagen_short[i],'_FR.zip'), ftp_adress,userpwd="keyg_in:5r6368vz")

setwd("..")
setwd("..")


#####ITALIENISCH

###Flexible Grafik-Bausteine erstellen
titel <- vorlagen_it$text[i]
undertitel_text <- paste0("<b>Votatzione popolare del 15 maggio 2022</b>")

undertitel_balken_firstline <- paste0("<b>",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",20),
                                      "</b>Popolo",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",35),
                                      "</b>Cantoni",
                                      strrep("&nbsp;",15),
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      "</b>Tasso di partecipazione</b>"
)

undertitel_balken_secondline <- paste0("sì ",gsub("[.]",",",Ja_Anteil),"% ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_yes),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_no),"</b>",
                                       " ",gsub("[.]",",",Nein_Anteil),"% no",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",1),"</b>",
                                       "sì ",Staende_Ja," ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Ja),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_Staende_Nein),"</b>",
                                       " ",Staende_Nein," no",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",1),"</b>",
                                       '<b style="background:	#696969; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_stimmbeteiligung),"</b>",
                                       '<b style="background:		#DCDCDC; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",20-length_stimmbeteiligung),"</b> ",
                                       gsub("[.]",",",Stimmbeteiligung),"%"
)

undertitel_all <- paste0(undertitel_text,"<br><br>",
                         undertitel_balken_firstline,
                         "<br>",
                         undertitel_balken_secondline,
                         "<br>&nbsp;")

#Fix 0
undertitel_all <- gsub('sì 0 <b style="background:	#89CFF0; color:black; padding:1px 6px">',
                       'sì 0 <b style="background:	#89CFF0; color:black; padding:1px 0px">',
                       undertitel_all)
undertitel_all <- gsub('6px"></b> 0 no',
                       '0px"></b> 0 no',
                       undertitel_all)

footer <- paste0('Fonte: UTS, Lena',
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",25),
                 "</b>Stato: ",format(Sys.time(),"%d.%m.%Y %Hh%M"),
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",25),
                 "</b>Infografica: Keystone-ATS"
                 )

###Vorlage kopieren
new_chart <-dw_copy_chart("Tfr6N")


#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              language="it-CH",
              intro=undertitel_all,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/",vorlagen_short[i],"_dw_kantone.csv")),
              axes=list("values"="Kanton_color"),
              visualize = list("legend"=list("title"="Proporzione di sì")),
              folderId = "100300")

###Bilddaten speichen und hochladen für Kanton

setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Kantone_",vorlagen_short[i],"_IT")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als SVG und EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Kantone_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Kantone_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN ",vorlagen_short[i]," I\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAPHIE - Votatzione popolare del 15 maggio 2022 - ",titel,". Questa infografica è stata creata automaticamente dal robot di scrittura Lena. (Infografica KEYSTONE)\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=L'infografica può essere ottenuta nei formati grafici EPS e SVG. Questa infografica è stata creata automaticamente dal robot di scrittura Lena.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
library(zip)
zip::zip(zipfile = paste0('LENA_Kantone_',vorlagen_short[i],'_IT.zip'), 
         c(paste0("LENA_Kantone_",vorlagen_short[i],".eps"),paste0("LENA_Kantone_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Daten hochladen
#library(RCurl)
#ftp_adress <- paste0("ftp://ftp.keystone.ch/",paste0('LENA_Kantone_',vorlagen_short[i],'_IT.zip'))
#ftpUpload(paste0('LENA_Kantone_',vorlagen_short[i],'_IT.zip'), ftp_adress,userpwd="keyg_in:5r6368vz")

setwd("..")
setwd("..")


###Vorlage kopieren
new_chart <-dw_copy_chart("kDkMR")


#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              language="it-CH",
              intro=undertitel_text,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/",vorlagen_short[i],"_dw.csv")),
              axes=list("values"="Gemeinde_color"),
              visualize = list("legend"=list("title"="Proporzione di sì")),
              folderId = "100300")

metadata <- dw_retrieve_chart_metadata(new_chart$id)


##Bilddaten speichen und hochladen für Gemeinde
setwd("./Grafiken")

#Create Folder
folder_name <- paste0("LENA_Gemeinden_",vorlagen_short[i],"_IT")
dir.create(folder_name)

setwd(paste0("./",folder_name))

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
cat(map,file=paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"))
map <- charToRaw(map)
rsvg_eps(map,paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN GEMEINDEN ",vorlagen_short[i]," I\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAPHIE - Votatzione popolare del 15 maggio 2022 - ",titel,". Questa infografica è stata creata automaticamente dal robot di scrittura Lena. (Infografica KEYSTONE)\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=L'infografica può essere ottenuta nei formati grafici EPS e SVG. Questa infografica è stata creata automaticamente dal robot di scrittura Lena.\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=Lena\n",
                   "i122_writer=Lena\n")

cat(metadata,file="metadata.properties")

#Zip-File erstellen
library(zip)
zip::zip(zipfile = paste0('LENA_Gemeinden_',vorlagen_short[i],'_IT.zip'), 
         c(paste0("LENA_Gemeinden_",vorlagen_short[i],".eps"),paste0("LENA_Gemeinden_",vorlagen_short[i],".svg"),"preview.jpg","metadata.properties"), mode="cherry-pick")

#Daten hochladen
#library(RCurl)
#ftp_adress <- paste0("ftp://ftp.keystone.ch/",paste0('LENA_Gemeinden_',vorlagen_short[i],'_IT.zip'))
#ftpUpload(paste0('LENA_Gemeinden_',vorlagen_short[i],'_IT.zip'), ftp_adress,userpwd="keyg_in:5r6368vz")

setwd("..")
setwd("..")


}



