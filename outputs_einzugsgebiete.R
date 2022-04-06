###Output generieren für Datawrapper Zentralschweiz

output_dw_zentralschweiz <- results[results$Kanton_Short == "LU" |
                                      results$Kanton_Short == "SZ" |
                                      results$Kanton_Short == "OW" |
                                      results$Kanton_Short == "NW" |
                                      results$Kanton_Short == "ZG" |
                                      results$Kanton_Short == "UR" |
                                      results$Gemeinde_Nr < 15,]


output_dw_zentralschweiz <- get_output_gemeinden(output_dw_zentralschweiz)

write.csv(output_dw_zentralschweiz,paste0("Output/",vorlagen_short[i],"_dw_zentralschweiz.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

###Output generieren für Datawrapper Appenzell

output_dw_appenzell <- results[results$Kanton_Short == "AI" |
                                 results$Kanton_Short == "AR",]

output_dw_appenzell <- get_output_gemeinden(output_dw_appenzell)

write.csv(output_dw_appenzell,paste0("Output/",vorlagen_short[i],"_dw_appenzell.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")


###Output generieren für Datawrapper Radiotop

output_dw_radiotop <- results[results$Kanton_Short == "ZH" |
                                results$Kanton_Short == "SH" |
                                results$Kanton_Short == "TG" |
                                results$Kanton_Short == "SG" |
                                results$Kanton_Short == "AI" |
                                results$Kanton_Short == "AR",]

output_dw_radiotop <- get_output_gemeinden(output_dw_radiotop)

write.csv(output_dw_radiotop,paste0("Output/",vorlagen_short[i],"_dw_radiotop.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

###Output generieren für Datawrapper FM1-Today

output_dw_FM1_today <- results[results$Kanton_Short == "SG" |
                                results$Kanton_Short == "TG" |
                                results$Kanton_Short == "GR" |
                                results$Kanton_Short == "AI" |
                                results$Kanton_Short == "AR",]

output_dw_FM1_today <- get_output_gemeinden(output_dw_FM1_today)

write.csv(output_dw_FM1_today,paste0("Output/",vorlagen_short[i],"_dw_FM1_today.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

###Output generieren für Datawrapper Basel

output_dw_basel <- results[results$Kanton_Short == "BS" |
                                 results$Kanton_Short == "BL",]

output_dw_basel <- get_output_gemeinden(output_dw_basel)

write.csv(output_dw_basel,paste0("Output/",vorlagen_short[i],"_dw_basel.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

###Output generieren für Datawrapper Central

output_dw_central <- results[results$Kanton_Short == "AG" |
                                      results$Kanton_Short == "GL" |
                                      results$Kanton_Short == "LU" |
                                      results$Kanton_Short == "NW" |
                                      results$Kanton_Short == "OW" |
                                      results$Kanton_Short == "SG" |
                                      results$Kanton_Short == "SZ" |
                                      results$Kanton_Short == "UR" |
                                      results$Kanton_Short == "ZG" |
                                      results$Kanton_Short == "ZH",]


output_dw_central <- get_output_gemeinden(output_dw_central)

write.csv(output_dw_central,paste0("Output/",vorlagen_short[i],"_dw_central.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

