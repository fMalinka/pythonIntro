#TIDYVERSE and dplyr

#################################   dplyr    ###################################

#dplyr package in R - package for data manipulation and exploration
# - can work with data stored in databases
#five basic functions
# filter - subset rows on conditions
# select - subset columns
# arrange - sort results
# mutate - create new columns by using information from other columns
# summarise - calculate information about groups

#dplyr stores data in special object (structure) called tbl [tibble] - special df with some features
#to convert df to tbl use tbl_df function (deprecated, now use as_tibble!!!!) (it is not obligatory, but recommended)

data(iris)
library(dplyr)
iris_tbl <- tbl_df(iris)
iris_tbl <- as_tibble(iris)
iris_tbl
#and back
iris_tbl_df <- as.data.frame(iris_tbl)
iris_tbl_df

#to show a structure of tbl use glimpse (simmilar to str)
str(iris_tbl)
glimpse(iris_tbl)

###--------------------------------------------------
###########working with variables (features, columns)
#functions: select, transmute

select(iris_tbl, Species, Petal.Length, Petal.Width)
select(iris, Species, Petal.Length, Petal.Width) #this returns df, not tbl
iris[,c("Species", "Petal.Length", "Petal.Width")]

library(rbenchmark)
#runtime
benchmark(select(iris_tbl, Species, Petal.Length, Petal.Width), iris[,c("Species", "Petal.Length", "Petal.Width")], replications = 1000)

#using minus means that the feature will be dropped
select(iris_tbl, -Petal.Length, -Petal.Width) 

#to subset variables that fall in between them, we use ":"
select(iris_tbl, Petal.Length:Species)

#to select and rename simultaneously use "rename"
#rename(iris_tbl, Petal_Length = Petal.Length, Petal_Width = Petal.Width)

#add some columns that are given by expressions
iris_tbl <- mutate(iris_tbl, 
       Sepal.Area = Sepal.Width * Sepal.Length,
       Petal.Area = Petal.Width * Petal.Length,
       Area.Ratio = Petal.Area / Petal.Area)
#to keep ouly mentioned variables, use transmute function
transmute(iris_tbl,
          Sepal.Area = Sepal.Width * Sepal.Length,
          Petal.Area = Petal.Width * Petal.Length,
          Area.Ratio = Petal.Area / Petal.Area)
#and add the Species column
transmute(iris_tbl,
          Species,
          Sepal.Area = Sepal.Width * Sepal.Length,
          Petal.Area = Petal.Width * Petal.Length,
          Area.Ratio = Petal.Area / Petal.Area)


###----------------------------------------
###########working with observations (rows)
#functions: filter, arrange
#filter(df, expression, expression, ...) expressions are in conjunction!
#expression must "return" logical vector!!

filter(iris_tbl, Sepal.Length > 5, Sepal.Width > 4)
#or alternatively
filter(iris_tbl, Sepal.Length > 5 & Sepal.Width > 4)
#obviously, for OR use pipe sign
filter(iris_tbl, Sepal.Length > 5 | Sepal.Width > 4)


#reorder the rows according to Sepal.Length (in case of equal value, sort by Petal.Length)
arrange(iris_tbl, Sepal.Length, Petal.Length)
#in descent order use desc
arrange(iris_tbl, desc(Sepal.Length), Petal.Length)

#HELPER functions! more is located at cheat sheat https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
#helper functions for select
#contains
select(iris_tbl, contains("."))
#starts_with, ends_with
select(iris_tbl, starts_with("sepal"))
select(iris_tbl, starts_with("sepal"), ignore.case = FALSE)
select(iris_tbl, ends_with("Length"))
#matches using RE
select(iris_tbl, matches("etal\\..+", perl=TRUE))

#helper function for filter
filter(iris_tbl, between(Sepal.Length, 5,6)) # sepal length is between 5 and 6


###----------------------------------------
## GROUPING AND SUMMARISING data
#summarise and group_by

### SUMMARISE
#each expression must generate only a single value!!
summarise(iris_tbl, meanSepalW = mean(Sepal.Width), meanPetalW = mean(Petal.Width))
#my own function?
incrementor <- function(val)
{
  return(mean(val)+1)
}
summarise(iris_tbl, inc = incrementor(Sepal.Width))
#it works with user-defined functions but they must return only a single value!!!
#other helper functions are in the cheat sheat

#group by - in contrast to summarise, its apply a function to a subset of data
iris_tbl_group <- group_by(iris_tbl, Sepal.Length)
summarise(iris_tbl_group, mean(Sepal.Length))
summarise(iris_tbl_group, n())
#sometimes it is necessary to ungroup
ungroup(iris_tbl_group)


#https://dzchilds.github.io/eda-for-bio/grouping-and-summarising-data.html


###----------------------------------------
#PIPELINEs
#pipe operator %>%
iris_tbl %>%
  filter(Sepal.Length > 4) %>%
  select(-Petal.Width) %>%
  group_by(Sepal.Length) %>%
  summarise(n())

#######
 #wide and long data format.....   https://datacarpentry.org/r-socialsci/03-dplyr-tidyr/index.html


#################################   tidyverse    ###############################
#it is a collection of R packages designed for data science
library(tidyverse)
#dplyr <- grammar of data manupilation (the most common manipulation challenges)
#ggplot2 - for a visialization
#forcats - a package solving "common" problems with factors (changing the order of levels)
#tibble - a modern reimiging of the data.frame ("new format of df")
#readr - a package for fast read rectangular data (csv,....)
        # read_csv function - 10-100 faster? than data.frame
#stringr - a package for string manipulations
#tidyr - helps to create "tidy" data (in the proper "required" format) - long and wide format, splitting cells, expanding tables, handling missing values
#purrr - funtions and vectors....? [todo]


####### tidyr
#https://r4ds.had.co.nz/tidy-data.html
#split cells
#unite, separate, separate_rows - split or combine cells into individual, isolated values
#separate
#table3 %>% 
#  separate(rate, into = c("cases", "population"), sep = "/")  - separate column rate onto two columns (case and population) using "\" separator
#unite - a reverse operation to separate
#table5 %>% 
#  unite(new, century, year, sep = "/") - unite two columns (centrury and year) into new with "/" separator

#Missing values
#drop_na  - drop rows containing NAs in columns
#fill - fill NAs in columns
#replace_na - specify a value to replace NA in selected columns


#### JOINs - probably better to use SQL cmds