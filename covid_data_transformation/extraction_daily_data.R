library(pdftools)
library(devtools)
library(tidyverse)

remove_arabic_text <- function(text) {
  gsub("[\u0600-\u06FF]+", "", text)
}

remove_numeric_text <- function(text) {
  gsub("[0-9]", "", text)
}

data_ville <- as_data_frame(ville_covid19_historique)

pdf_1 <- pdf_text("/home/tsiory/Documents/cours_1è_année_ingenieur/stat_data/data/data/data_3.pdf")

dates <- str_extract_all(pdf_1, "\\d{2}/\\d{2}/\\d{4}")

page_3 <- pdf_1[3]


print(lines)

no_arabic <- remove_arabic_text(page_3)

print(no_arabic)

print(strsplit(no_arabic, "\n")[[1]])

lines <- strsplit(page_3, "\n")[[1]]

donnees <- str_split_fixed(no_arabic, "\\s{2,}", n = 4)

print(donnees)

df_chart <- as.data.frame(donnees, stringsAsFactors = FALSE)

colnames(df_chart) <- c("none" , "Region", "Nouveaux_Cas", "Deces")

df_chart$none <- NULL

print(df_chart)


df_chart$Deces <- sapply(df_chart$Deces , remove_arabic_text)

df_chart$Region <- sapply(df_chart$Region , remove_arabic_text)

df_chart$Nouveaux_Cas <- sapply(df_chart$Nouveaux_Cas , remove_arabic_text)

df_chart$Nouveaux_Cas <- as.numeric(df_chart$Nouveaux_Cas)

df_chart$Region <- sapply(df_chart$Region , remove_numeric_text)

df_chart <- na.omit(df_chart)

print(ville)

liste_ville = as.list(ville$nom_ville)

df_chart_clean <- df_chart[grepl("région", df_chart$Region, ignore.case = TRUE), ]

View(df_chart_clean)

new_chart <- df_chart[sapply(df_chart$Region, function(x) x %in% liste_ville), ]

view(df_chart)

dates_converted <- as.Date(dates[[1]][1], format = "%d/%m/%Y")

print(dates_converted)
