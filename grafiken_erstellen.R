library(rsvg)
library(magick)

###Daten holen

###Text und flexible Grafik-Bausteine erstellen

###Bilddaten speichen und hochlasen

#Als JPEG
map <- dw_export_chart("N2EY7", plain=FALSE,border_width = 20)
image_write(map,path="./SDA_Grafik/preview.jpg",format="jpeg")

#Als EPS
map <- dw_export_chart("N2EY7", type="svg",plain=FALSE,border_width = 20)
map <- charToRaw(map)
rsvg_eps(map,"./SDA_Grafik/LENA_Tabak.eps",width=4800)

#Metadata
metadata <- paste0("i5_object_name=SCHWEIZ ABSTIMMUNGEN TABAKWERBEVERBOT D\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption=INFOGRAFIK - Eidgenoessische Volksabstimmung vom 13. Februar 2022 - Tabakwerbeverbotsinitiative. (Infografik KEYSTONE)\n",
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

cat(metadata,file="./SDA_Grafik/metadata.properties")

#Zip-File erstellen
library(zip)
zip::zip(zipfile = 'SDA_Grafik/LENA_Tabak_DEU.zip', c("SDA_Grafik/LENA_Tabak.eps","SDA_Grafik/preview.jpg","SDA_Grafik/metadata.properties"), mode="cherry-pick")
library(RCurl)

#Daten hochladen
#ftp_adress <- paste0("ftp://ftp.keystone.ch/Impfquote_DEU.zip")
#ftpUpload("./SDA_Grafik/Impfquote_DEU.zip", ftp_adress,userpwd="keyg_in:5r6368vz")
