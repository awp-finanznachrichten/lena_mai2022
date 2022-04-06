#Tierversuche
data_tierversuche <- read_csv("Output/Tierversuche_dw.csv")

data_tierversuche <- data_tierversuche %>%
  select(Gemeinde_Nr,
         Gemeinde_KT_d,
         Ja_Stimmen_In_Prozent,
         Nein_Stimmen_In_Prozent,
         Text_d)

colnames(data_tierversuche) <- c("Gemeinde_Nr","Gemeinde_Name",
                                 "Tierversuche_Ja_Anteil","Tierversuche_Nein_Anteil",
                                 "Tierversuche_Text")

#Tabakwerbung
data_tabakwerbung <- read_csv("Output/Tabakwerbung_dw.csv")

data_tabakwerbung <- data_tabakwerbung %>%
  select(Gemeinde_Nr,
         Ja_Stimmen_In_Prozent,
         Nein_Stimmen_In_Prozent,
         Text_d)

colnames(data_tabakwerbung) <- c("Gemeinde_Nr","Tabakwerbung_Ja_Anteil","Tabakwerbung_Nein_Anteil",
                                 "Tabakwerbung_Text")

#Stempelabgaben
data_stempelabgaben <- read_csv("Output/Stempelabgaben_dw.csv")

data_stempelabgaben <- data_stempelabgaben %>%
  select(Gemeinde_Nr,
         Ja_Stimmen_In_Prozent,
         Nein_Stimmen_In_Prozent,
         Text_d)

colnames(data_stempelabgaben) <- c("Gemeinde_Nr","Stempelabgaben_Ja_Anteil","Stempelabgaben_Nein_Anteil",
                                 "Stempelabgaben_Text")


#Medien
data_medien <- read_csv("Output/Medien_dw.csv")

data_medien  <- data_medien  %>%
  select(Gemeinde_Nr,
         Ja_Stimmen_In_Prozent,
         Nein_Stimmen_In_Prozent,
         Text_d)

colnames(data_medien) <- c("Gemeinde_Nr","Medien_Ja_Anteil","Medien_Nein_Anteil",
                                 "Medien_Text")

#Zusammenführen
datenfeed_all <- merge(data_tierversuche,data_tabakwerbung)
datenfeed_all <- merge(datenfeed_all,data_stempelabgaben)
datenfeed_all <- merge(datenfeed_all,data_medien)

#Datenfeed speichern
write.csv(datenfeed_all,"Output/Datenfeed_NAU.csv", na = "", row.names = FALSE, fileEncoding = "UTF-8")


