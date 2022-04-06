#Working Directory definieren
setwd("C:/Users/simon/OneDrive/LENA_Project/lena_februar2022")

###LENA alle 5 Sekunden laufen lassen
#repeat{

#Sys.sleep(60)

###Config: Bibliotheken laden, Pfade/Links definieren, bereits vorhandene Daten laden
source("config.R",encoding = "UTF-8")

###Funktionen laden
source("functions_readin.R", encoding = "UTF-8")
source("functions_storyfinder.R", encoding = "UTF-8")
source("functions_storybuilder.R", encoding = "UTF-8")
source("functions_output.R", encoding = "UTF-8")

#Anzahl, Name und Nummer der Vorlagen von JSON einlesen
vorlagen <- get_vorlagen(json_data,"de")
vorlagen_fr <- get_vorlagen(json_data,"fr")
vorlagen_it <- get_vorlagen(json_data,"it")

time_start <- Sys.time()

###Nationale Abstimmungen###
source("nationale_abstimmungen.R", encoding="UTF-8")

###Kantonale Abstimmungen###
source("kantonale_abstimmungen.R", encoding="UTF-8")

###Kantonale Abstimmungen Sonderfälle###
source("kantonale_abstimmungen_special.R", encoding="UTF-8")

###Datenfeeds für Kunden###
source("datenfeeds_kunden.R", encoding="UTF-8")

#Make Commit
#git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
git2r::cred_token(token)
gitadd()
gitcommit()
gitpush()

#Tabellen aktualisieren
#source("topflop.R", encoding = "UTF-8")

#Make Commit
#token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
#git2r::cred_token(token)
#gitadd()
#gitcommit()
#gitpush()

cat("Daten erfolgreich auf Github hochgeladen\n")

#Wie lange hat LENA gebraucht
time_end <- Sys.time()
cat(time_end-time_start)

#}
