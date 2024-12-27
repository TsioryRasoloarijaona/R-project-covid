
  Region_regrouper$Identifiant <- NULL

View(Region_regrouper)
Region_regrouper$moyenne_par_region <- rowMeans(Region_regrouper[, 2:6])

View(Region_regrouper)

local_path <- "/home/tsiory/Documents/cours_1è_année_ingenieur/stat_data/data/analysis_result/moyenne_par_ville.csv"

write.csv(Region_regrouper, local_path, row.names = FALSE)

id_folder_destination <- "1LfRoDaciv5aXBRVkOQ8ZHMHuJ_782pby"

drive_upload(
  media = local_path,
  path = as_id(id_folder_destination),
  name = "moyenne_par_ville.csv"
)


