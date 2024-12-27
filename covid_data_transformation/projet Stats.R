install.packages("FactoMineR")
install.packages("ggplot2")
install.packages("tidyr")
install.packages("missMDA")
install.packages("readr")
install.packages("dplyr")
install.packages("RSQLite")

library(missMDA)
library(readr)
library(RSQLite)
library(dplyr)
library(ggplot2)
library(FactoMineR)
library(tidyr)

donnees <- read_csv("final_tab_cleaned.csv")

conn <- dbConnect(RSQLite::SQLite(), "final_data_base_ok.db")
dbWriteTable(conn, "final_tab_cleaned", donnees)

dbDisconnect(conn)

head(donnees)

str(donnees)

summary(donnees)

is.na(donnees)


donnees$Region <- as.factor(donnees$Region)

donnees$Deces<-as.double(donnees$Deces)

donnees$Date <- as.Date(donnees$date)

donnees$Nouveaux_Cas[is.na(donnees$Nouveaux_Cas)] <- mean(donnees$Nouveaux_Cas, na.rm = TRUE)
donnees$Deces[is.na(donnees$Deces)] <- mean(donnees$Deces, na.rm = TRUE)

summary(donnees)
str(donnees)

# Filtrer les données où Nouveaux_Cas > 100
donnees_filtrees <- donnees[donnees$Nouveaux_Cas > 100, ]
# Filtrer les données où Région == "Région1"
donnees_filtrees <- donnees[donnees$Region == "Région1", ]
# Trier les données par Nouveaux_Cas croissant
donnees_triees <- donnees[order(donnees$Nouveaux_Cas), ]
# Trier les données par Nouveaux_Cas décroissant
donnees_triees <- donnees[order(-donnees$Nouveaux_Cas), ]
# Regrouper les données par Région et calculer la somme des Nouveaux_Cas
donnees_agregees <- aggregate(Nouveaux_Cas ~ Region, data = donnees, sum)
# Regrouper les données par Région et calculer la moyenne des Nouveaux_Cas
donnees_agregees <- aggregate(Nouveaux_Cas ~ Region, data = donnees, mean)
windows(width = 8, height = 6)

hist(donnees$Nouveaux_Cas, 
     main = "Histogramme des nouveaux cas", 
     xlab = "Nouveaux cas", 
     col = "lightblue", 
     border = "black")

plot(donnees$Nouveaux_Cas, donnees$Deces, 
     main = "Nuage de points", 
     xlab = "Nouveaux cas", 
     ylab = "Décès", 
     pch = 19, 
     col = "blue")

barplot(donnees$Nouveaux_Cas, 
        main = "Graphique à barres", 
        xlab = "Régions", 
        ylab = "Nouveaux cas", 
        col = "lightgreen", 
        border = "black")


write.csv(donnees, "donnees_nettoyees.csv")



donnees_acp <- donnees[, c("Nouveaux_Cas", "Deces")]

cor_mat <- cor(donnees_acp)

acp <- PCA(donnees_acp, graph = FALSE)

plot(acp, choix = "ind")

plot(acp, choix = "var")

summary(acp)

acp$eig

acp$eig / sum(acp$eig) * 100

acp$var$coord

cor(donnees_acp)

plot(acp, choix = "var")

plot(acp, choix = "ind")

variables_correlees <- acp$var$coord[,1:2] 
correlation <- cor(donnees_acp)
pdf("graphique.pdf", width = 8, height = 6)
plot(acp, choix = "var")
dev.off()



#heatmap(correlation)
plot(acp, choix = "var")
plot(acp, choix="ind")

dim(donnees_acp)
dim(acp$ind$coord) 
ncol(donnees_acp)
nrow(acp$ind$coord)

# Calculer les statistiques descriptives pour plusieurs variables
statistiques <- donnees %>%
  summarise(
    Moyenne_Nouveaux_Cas = mean(Nouveaux_Cas, na.rm = TRUE),
    Médiane_Nouveaux_Cas = median(Nouveaux_Cas, na.rm = TRUE),
    Écart_type_Nouveaux_Cas = sd(Nouveaux_Cas, na.rm = TRUE),
    Variance_Nouveaux_Cas = var(Nouveaux_Cas, na.rm = TRUE),
    Moyenne_Décès = mean(Deces, na.rm = TRUE),
    Médiane_Décès = median(Deces, na.rm = TRUE),
    Écart_type_Décès = sd(Deces, na.rm = TRUE),
    Variance_Décès = var(Deces, na.rm = TRUE)
  )

# Afficher les résultats
print(statistiques)

hist(donnees$Nouveaux_Cas)
hist(donnees$Deces)


boxplot(donnees$Nouveaux_Cas)
boxplot(donnees$Deces)

cor(donnees$Nouveaux_Cas, donnees$Deces)

plot(donnees$Nouveaux_Cas, donnees$Deces)

modele <- lm(Deces ~ Nouveaux_Cas, data = donnees)

summary(modele)

#t.test(Nouveaux_Cas ~ Region, data = donnees)


# Afficher la matrice de corrélation
print(correlation)

cor(donnees_acp, acp$ind$coord[, 1:ncol(donnees_acp)])


# Réessayer la fonction heatmap
heatmap(cor(donnees_acp))


heatmap(correlation, main = "Matrice de corrélation")

# Identification des variables fortement corrélées
variables_correlees <- correlation[correlation > 0.7]
print(variables_correlees)






