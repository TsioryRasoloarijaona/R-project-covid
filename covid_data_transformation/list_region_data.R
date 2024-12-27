library(googledrive)

Region_regrouper$`Population 2020` <- NULL
Region_regrouper$`Population 2021`<- NULL
Region_regrouper$`Population 2022` <- NULL
Region_regrouper$`Population 2023` <- NULL
Region_regrouper$`Population 2024` <- NULL

local_path <- "/home/tsiory/Documents/cours_1è_année_ingenieur/stat_data/data/database/list_region.csv"

write.csv(Region_regrouper, local_path, row.names = FALSE)

id_folder_destination <- "1LfRoDaciv5aXBRVkOQ8ZHMHuJ_782pby"

drive_upload(
  media = local_path,
  path = as_id(id_folder_destination),
  name = "list_region.csv"
)


View(Region_regrouper)
