library(ggvis)

# Make data set with categorical x
mtc <- mtcars
mtc$cyl <- factor(mtc$cyl)
mtc$cyl <- '4'
mtc %>% ggvis(~cyl, ~mpg) %>% layer_boxplots()