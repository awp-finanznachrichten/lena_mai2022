#Bibliotheken laden
library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(ggplot2)
library(stringr)
library(stringi)
library(xml2)
library(rjson)
library(jsonlite)
library(readxl)
library(git2r)
library(DatawRappr)

cat("Benoetigte Bibliotheken geladen\n")

#Welche Abstimmung?
abstimmung_date <- "Mai2022"

#Link zu JSON-Daten / Daten einlesen
link_json <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20220515-eidgAbstimmung.json" 
json_data <- fromJSON(link_json, flatten = TRUE)

link_json_kantone <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20220515-kantAbstimmung.json"
json_data_kantone <- fromJSON(link_json_kantone, flatten = TRUE)

cat("Aktuelle Abstimmungsdaten geladen\n")

#Kurznamen Vorlagen (Verwendet im File mit den Textbausteinen)
vorlagen_short <- c("Film","Transplantation","Frontex")

###Kurznamen und Nummern kantonale Vorlagen
kantonal_short <- c("ZH_Klimaschutz","ZH_Wahlrecht16","ZH_Buergerrecht","ZH_Elternzeit","FR_Foncière","GE_Cycle_Orientation","JU_Plaques")

#Nummer in JSON 
kantonal_number <- c(1,1,1,1,4,12,13) 

#Falls mehrere Vorlagen innerhalb eines Kantons, Vorlage auswaehlen
kantonal_add <- c(1,2,3,4,1,1,1)

###Kurznamen und Nummern kantonale Vorlagen Spezialfaelle
kantonal_short_special <- c("NE_Cour_Comptes")

#Nummer in JSON 
kantonal_number_special <- c(11) 

#Falls mehrere Vorlagen innerhalb eines Kantons, Vorlage auswaehlen
kantonal_add_special <- c(2)

###Vorhandene Daten laden
#daten_tierversuche_bfs <- read_excel("Data/daten_tierversuche_bfs.xlsx")
#daten_tabak_bfs <- read_excel("Data/daten_tabak_bfs.xlsx")

#cat("Daten zu historischen Abstimmungen geladen\n")

#Metadaten Gemeinden und Kantone
meta_gmd_kt <- read_csv("Data/MASTERFILE_GDE.csv")

cat("Metadaten zu Gemeinden und Kantonen geladen\n")

#Datawrapper-Codes
datawrapper_codes <- as.data.frame(read_excel("Data/Datawrapper_Codes.xlsx"))

datawrapper_auth("BMcG33cGBCp2FpqF1BSN5lHhKrw2W8Ait4AYbDEjkjVgCiWe07iqoX5pwHXdW36g", overwrite = TRUE)


gitcommit <- function(msg = "commit from Rstudio", dir = getwd()){
  cmd = sprintf("git commit -m\"%s\"",msg)
  system(cmd)
}

gitstatus <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git status"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitadd <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git add --all"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitpush <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git push"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}


