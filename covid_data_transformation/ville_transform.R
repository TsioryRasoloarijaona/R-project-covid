
library(googl)
data_ville <- as.data.frame(ville_covid19_historique)

View(data_ville)

ville <- data.frame(
  nom_ville = c(data_ville$Ville)
)

ville$id_ville <- 1:nrow(ville)

View(ville)






id_folder_destination <- "1LfRoDaciv5aXBRVkOQ8ZHMHuJ_782pby"

local_path = "/home/tsiory/Documents/cours_1è_année_ingenieur/stat_data/data/database/ville1.csv"

write.csv(ville , local_path , row.names = FALSE)

drive_upload(
  media = local_path,
  path = as_id(id_folder_destination),
  name = "ville_list1.csv"
)

