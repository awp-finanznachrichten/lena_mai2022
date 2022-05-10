#Film
data_Film <- read_csv("Output/Film_dw.csv")

data_Film <- data_Film %>%
  select(Gemeinde_Nr,
         Gemeinde_KT_d,
         Ja_Stimmen_In_Prozent,
         Nein_Stimmen_In_Prozent,
         Text_d)

colnames(data_Film) <- c("Gemeinde_Nr","Gemeinde_Name",
                                 "Film_Ja_Anteil","Film_Nein_Anteil",
                                 "Film_Text")

#Frontex
data_Frontex <- read_csv("Output/Frontex_dw.csv")

data_Frontex <- data_Frontex %>%
  select(Gemeinde_Nr,
         Ja_Stimmen_In_Prozent,
         Nein_Stimmen_In_Prozent,
         Text_d)

colnames(data_Frontex) <- c("Gemeinde_Nr","Frontex_Ja_Anteil","Frontex_Nein_Anteil",
                                 "Frontex_Text")

#Transplantation
data_Transplantation <- read_csv("Output/Transplantation_dw.csv")

data_Transplantation <- data_Transplantation %>%
  select(Gemeinde_Nr,
         Ja_Stimmen_In_Prozent,
         Nein_Stimmen_In_Prozent,
         Text_d)

colnames(data_Transplantation) <- c("Gemeinde_Nr","Transplantation_Ja_Anteil","Transplantation_Nein_Anteil",
                                 "Transplantation_Text")


#Medien
#data_medien <- read_csv("Output/Medien_dw.csv")

#data_medien  <- data_medien  %>%
#  select(Gemeinde_Nr,
#         Ja_Stimmen_In_Prozent,
#         Nein_Stimmen_In_Prozent,
#         Text_d)

#colnames(data_medien) <- c("Gemeinde_Nr","Medien_Ja_Anteil","Medien_Nein_Anteil",
#                                 "Medien_Text")

#Zusammenführen
datenfeed_all <- merge(data_Film,data_Frontex)
datenfeed_all <- merge(datenfeed_all,data_Transplantation)
#datenfeed_all <- merge(datenfeed_all,data_medien)

#Datenfeed speichern
write.csv(datenfeed_all,"Output/Datenfeed_NAU.csv", na = "", row.names = FALSE, fileEncoding = "UTF-8")


