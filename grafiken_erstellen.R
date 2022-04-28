library(rsvg)
library(magick)
library(DatawRappr)

link_json <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20220213-eidgAbstimmung.json" 
json_data <- fromJSON(link_json, flatten = TRUE)


for (i in 1:length(vorlagen_short) ) {

#Nationale Ergebnisse holen
results_national <- get_results(json_data,i,level="national")
Ja_Anteil <- round(results_national$jaStimmenInProzent,1)
Nein_Anteil <- round(100-results_national$jaStimmenInProzent,1)
Stimmbeteiligung <- round(results_national$stimmbeteiligungInProzent,1)
Staende_Ja <- results_national$jaStaendeGanz+(results_national$jaStaendeHalb/2)
Staende_Nein <- results_national$neinStaendeGanz+(results_national$neinStaendeHalb/2)

###Flexible Grafik-Bausteine erstellen
titel <- vorlagen$text[i]
undertitel_text <- paste0("<b>Eidgenössische Volksabstimmung vom 15. Mai 2022</b>")

#Undertitel Balken
length_yes <- round(Ja_Anteil/5)
length_no <- round(Nein_Anteil/5)
length_stimmbeteiligung <- round(Stimmbeteiligung/5)

undertitel_balken_firstline <- paste0("<b>",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",20),
                                      "</b>Volk",
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      strrep("&nbsp;",52),
                                      "</b>Stände",
                                      strrep("&nbsp;",28),
                                      '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                      "</b>Stimmbeteiligung</b>"
                                      )

undertitel_balken_secondline <- paste0("Ja ",gsub("[.]",",",Ja_Anteil),"% ",
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_yes),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",length_no),"</b>",
                                       gsub("[.]",",",Nein_Anteil),"% Nein",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",4),"</b>",
                                       "Ja ",Staende_Ja,
                                       '<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",Staende_Ja),"</b>",
                                       '<b style="background:		#F88379; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",Staende_Nein),"</b>",
                                       Staende_Nein," Nein",
                                       '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                                       strrep("&nbsp;",4),"</b>",
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
undertitel_all <- gsub('Ja 0<b style="background:	#89CFF0; color:black; padding:1px 6px">',
                       'Ja 0<b style="background:	#89CFF0; color:black; padding:1px 0px">',
                       undertitel_all)
undertitel_all <- gsub('6px"></b>0 Nein',
                       '0px"></b>0 Nein',
                       undertitel_all)

footer <- paste0('<b>Quelle: BFS, Lena',
                 '<b style="background:	#FFFFFF; color:black; padding:1px 6px">',
                 strrep("&nbsp;",94),
                 "</b>Grafik: Keystone-SDA")


###Vorlage kopieren
new_chart <-dw_copy_chart("Tfr6N")

#Grafik anpassen
dw_edit_chart(new_chart$id,title=titel,
              intro=undertitel_all,
              annotate=footer,
              data=list("external-data"=paste0("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/",vorlagen_short[i],"_dw_kantone.csv")),
              axes=list("values"="Kanton_color"),
              folderId = "100300")



###Bilddaten speichen und hochladen

#Als JPEG
map <- dw_export_chart(new_chart$id, plain=FALSE,border_width = 20)
image_write(map,path="./Grafiken/preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart(new_chart$id, type="svg",plain=FALSE,border_width = 20)
map <- charToRaw(map)
rsvg_eps(map,paste0("./Grafiken/LENA_",vorlagen_short[i],".eps"),width=4800)

#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN ",vorlagen_short[i]," D\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAFIK - Eidgenoessische Volksabstimmung vom 15. Mai 2022 - ",titel,". (Infografik KEYSTONE)\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code=CHE\n",
                   "i15_category=N\n",
                   "i105_headline=Politik, Wirtschaft\n",
                   "i40_special_instructions=\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline=AWP Finanznachrichten\n",
                   "i122_writer=AWP\n")

cat(metadata,file="./Grafiken/metadata.properties")

#Zip-File erstellen
library(zip)
zip::zip(zipfile = paste0('Grafiken/LENA_',vorlagen_short[i],'_DEU.zip'), c(paste0("Grafiken/LENA_",vorlagen_short[i],".eps"),"Grafiken/preview.jpg","Grafiken/metadata.properties"), mode="cherry-pick")

}
#library(RCurl)
#Daten hochladen
#ftp_adress <- paste0("ftp://ftp.keystone.ch/Impfquote_DEU.zip")
#ftpUpload("./SDA_Grafik/Impfquote_DEU.zip", ftp_adress,userpwd="keyg_in:5r6368vz")
