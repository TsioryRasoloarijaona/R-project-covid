library(pdftools)
library(tidyverse)


remove_arabic_text <- function(text) {
  gsub("[\u0600-\u06FF]+", "", text)
}

remove_numeric_text <- function(text) {
  gsub("[0-9]", "", text)
}


extract_transform <- function(fichier) {
  
  pdf_1 <- pdf_text(fichier)
  
  dates <- str_extract_all(pdf_1, "\\d{2}/\\d{2}/\\d{4}")
  
  if (length(dates[[1]]) == 0) {
    warning(paste("Aucune date trouvée dans le fichier", fichier))
    return(NULL)
  }
  
  dates_converted <- as.Date(dates[[1]][1], format = "%d/%m/%Y")
  
 if (length(pdf_1) < 4) {
    warning(paste("Le fichier", fichier, "n'a pas assez de pages."))
    return(NULL)
  }
  
  page_3 <- pdf_1[4]
  

  page_3_data <- remove_arabic_text(page_3)
  
 
  lines <- strsplit(page_3_data, "\n")[[1]]
  

  donnees <- str_split_fixed(lines, "\\s{2,}", n = 5)
  
  df_chart <- as.data.frame(donnees, stringsAsFactors = FALSE)
  
  if (nrow(df_chart) == 0) {
    warning(paste("Le fichier", fichier, "a généré un DataFrame vide après traitement des lignes."))
    return(NULL)
  }
  
  colnames(df_chart) <- c("none", "Region", "Nouveaux_Cas", "Deces" , "date")
  
  df_chart$none <- NULL
  
  df_chart$date <- dates_converted 
  
  df_chart$Nouveaux_Cas <- as.numeric(df_chart$Nouveaux_Cas)
  
  df_chart$Region <- sapply(df_chart$Region, remove_numeric_text)
  
  df_chart <- na.omit(df_chart)
  
  df_chart_clean <- df_chart[grepl("région", df_chart$Region, ignore.case = TRUE), ]
  
  return(df_chart_clean)
}


repertoire <- "/home/tsiory/Documents/cours_1è_année_ingenieur/stat_data/data/data"


fichiers <- list.files(path = repertoire, full.names = TRUE, pattern = "\\.pdf$")

resultats <- lapply(fichiers, extract_transform)

df_final <- bind_rows(resultats, .id = "Fichier")

df_final$Fichier <- NULL

df_final <- unique(df_final)

df_final$Region <- gsub("région", "", df_final$Region, ignore.case = TRUE)

View(df_final)

write.csv(df_final_3, "/home/tsiory/Documents/cours_1è_année_ingenieur/stat_data/data/database/resultats_final_page4.csv", row.names = FALSE)



