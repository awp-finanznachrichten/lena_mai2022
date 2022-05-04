#import
library(tidyverse)


#Loi Netflix
netflix_raw <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/Film_all_data.csv")

netflix_top <- netflix_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50)%>%
  select(Gemeinde_f,Gemeinde_d, Gemeinde_i, Kanton_Short,Ja_Stimmen_In_Prozent) %>%
  mutate(Commune = Gemeinde_f,
         Gemeinde = Gemeinde_d,
         Comune = Gemeinde_i,
         Canton = Kanton_Short,
         Kanton = Kanton_Short,
         Cantone = Kanton_Short,
         "Pourcentage de oui" = Ja_Stimmen_In_Prozent,
         "Ja in %" = Ja_Stimmen_In_Prozent,
         "Percentuale di sì" = Ja_Stimmen_In_Prozent)

write.csv(netflix_top,"Tableaux/netflix_top.csv", fileEncoding = "UTF-8")


netflix_flop <- netflix_raw %>%
  arrange(Ja_Stimmen_In_Prozent) %>%
  slice(1:50) %>%
  select(Gemeinde_f,Gemeinde_d, Gemeinde_i, Kanton_Short,Ja_Stimmen_In_Prozent) %>%
  mutate(Commune = Gemeinde_f,
         Gemeinde = Gemeinde_d,
         Comune = Gemeinde_i,
         Canton = Kanton_Short,
         Kanton = Kanton_Short,
         Cantone = Kanton_Short,
         "Pourcentage de non" = 100-Ja_Stimmen_In_Prozent,
         "Nein in %" = 100-Ja_Stimmen_In_Prozent,
         "Percentuale di no" = 100-Ja_Stimmen_In_Prozent)

write.csv(netflix_flop,"Tableaux/netflix_flop.csv", fileEncoding = "UTF-8")

##Frontex
frontex_raw <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/Frontex_all_data.csv")

frontex_top <- frontex_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50)%>%
  select(Gemeinde_f,Gemeinde_d, Gemeinde_i, Kanton_Short,Ja_Stimmen_In_Prozent) %>%
  mutate(Commune = Gemeinde_f,
         Gemeinde = Gemeinde_d,
         Comune = Gemeinde_i,
         Canton = Kanton_Short,
         Kanton = Kanton_Short,
         Cantone = Kanton_Short,
         "Pourcentage de oui" = Ja_Stimmen_In_Prozent,
         "Ja in %" = Ja_Stimmen_In_Prozent,
         "Percentuale di sì" = Ja_Stimmen_In_Prozent)

write.csv(frontex_top,"Tableaux/frontex_top.csv", fileEncoding = "UTF-8")


frontex_flop <- frontex_raw %>%
  arrange(Ja_Stimmen_In_Prozent) %>%
  slice(1:50) %>%
  select(Gemeinde_f,Gemeinde_d, Gemeinde_i, Kanton_Short,Ja_Stimmen_In_Prozent) %>%
  mutate(Commune = Gemeinde_f,
         Gemeinde = Gemeinde_d,
         Comune = Gemeinde_i,
         Canton = Kanton_Short,
         Kanton = Kanton_Short,
         Cantone = Kanton_Short,
         "Pourcentage de non" = 100-Ja_Stimmen_In_Prozent,
         "Nein in %" = 100-Ja_Stimmen_In_Prozent,
         "Percentuale di no" = 100-Ja_Stimmen_In_Prozent)

write.csv(frontex_flop,"Tableaux/frontex_flop.csv", fileEncoding = "UTF-8")

#Organes
org_raw <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_mai2022/master/Output/Transplantation_all_data.csv")

org_top <- org_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50)%>%
  select(Gemeinde_f,Gemeinde_d, Gemeinde_i, Kanton_Short,Ja_Stimmen_In_Prozent) %>%
  mutate(Commune = Gemeinde_f,
         Gemeinde = Gemeinde_d,
         Comune = Gemeinde_i,
         Canton = Kanton_Short,
         Kanton = Kanton_Short,
         Cantone = Kanton_Short,
         "Pourcentage de oui" = Ja_Stimmen_In_Prozent,
         "Ja in %" = Ja_Stimmen_In_Prozent,
         "Percentuale di sì" = Ja_Stimmen_In_Prozent)

write.csv(org_top,"Tableaux/org_top.csv", fileEncoding = "UTF-8")


org_flop <- org_raw %>%
  arrange(Ja_Stimmen_In_Prozent) %>%
  slice(1:50) %>%
  select(Gemeinde_f,Gemeinde_d, Gemeinde_i, Kanton_Short,Ja_Stimmen_In_Prozent) %>%
  mutate(Commune = Gemeinde_f,
         Gemeinde = Gemeinde_d,
         Comune = Gemeinde_i,
         Canton = Kanton_Short,
         Kanton = Kanton_Short,
         Cantone = Kanton_Short,
         "Pourcentage de non" = 100-Ja_Stimmen_In_Prozent,
         "Nein in %" = 100-Ja_Stimmen_In_Prozent,
         "Percentuale di no" = 100-Ja_Stimmen_In_Prozent)

write.csv(org_flop,"Tableaux/org_flop.csv", fileEncoding = "UTF-8")