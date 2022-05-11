library(readxl)
organspender_korrelation <- read_excel("Data/organe_korrelation.xlsx")

(cor(organspender_korrelation$Organspender,organspender_korrelation$Transplantation))^2


