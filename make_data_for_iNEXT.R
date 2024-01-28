rm(list=ls())
dev.off()
#load in packages
library(tidyverse)
library(iNEXT)
library(reshape2)

#load data. Occurance data frame. Species and unique sample by each row. Useful if sampling system
#hierarchal i.e. classification (e.g. habitat) >site>transect>sample>morphospecies. Greater the resolution the better
db_raw<-read_csv('db.csv')

#select necessary data, filter to specific habitat, make into species x sample id matrix
#here i use close canopy as an example habitat to filter to
#here I use presence-absence data (incidence_raw)
matrix<-filtered_trap_species%>%
  select(habitat,Sample_ID,species)%>%
  filter(habitat=="Close canopy")%>%
  dcast(species~Sample_ID)
#remove na values by making them 0
matrix[is.na(baiting)] <- 0
#make first column row names
row.names(matrix) <- matrix[,1]
#make sure anything greater than 1 is 1
matrix[matrix > 1] <- 1 
#remove first column from matrix
matrix<-matrix%>%select(-species)
#transform data into matrix format
matrix<-as.matrix(matrix)

#repeat above steps for project specific level number

#make data into list format. Make sure individual lists 
#are labelled as you would like to see them on the accumulation graphs
list_data = list(Matrix1 = matrix)
                #Matrix2 = ... etc,)

#generate summary stats using iNEXT function in iNEXT package. Ensure datatype = your data type.
accumulation_stats <-iNEXT(list_data, q = 0, datatype="incidence_raw")

#generate accumulation graphs
ggiNEXT(accumulation_stats, type=1)
