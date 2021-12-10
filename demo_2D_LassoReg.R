## Imaging Team 4
## Danielle Pitlor, Pooja Chawla, Rosy Li
## Lasso Regression for Benign Tumor Identification

## Packages
rm(list=ls());
graphics.off()
library(openxlsx)
library(Matrix)
library(glmnet)
library(splitstackshape)

## Identify the target Excel file
filepath <- 'C:\\Users\\pitlo\\Downloads';
setwd(filepath)
filename1 <- '2DData.xlsx';

# Extract data for all patients
xstuff <- read.xlsx(file.path(filepath,filename1),sheet = 'Sheet1', cols = 23:31, rows = 2:63);
ystuff <- read.xlsx(file.path(filepath,filename1),sheet = 'Sheet1', cols = 32, rows = 2:63);

# Extract data separately for tumor and non-tumor images
tumor <- read.xlsx(file.path(filepath,filename1),sheet = 'Sheet1',cols = 2:10, rows = 1:32);
notum <- read.xlsx(file.path(filepath,filename1),sheet = 'Sheet1',cols = 11:19, rows = 1:32);
groups <-  read.xlsx(file.path(filepath,filename1),sheet = 'Sheet1',cols = 20, rows = 1:32);

# Assign names to the columns
col.names <- c('CNR', 'Max', 'Mean', 'SNR', '0 deg', '45 deg', '90 deg', '135 deg', 'Age');
colnames(tumor) <- col.names;
colnames(notum) <- col.names;
colnames(xstuff) <- col.names;
colnames(ystuff) <- 'group';
colnames(groups) <- 'group';

# Reformat data for glmnet program
xstuff <- as.matrix(xstuff);
ystuff <- as.matrix(ystuff);
tumor <- as.matrix(tumor);
notum <- as.matrix(notum);
groups <- as.matrix(groups);

# Apply glmnet to perform regression
g_xstuff <- cv.glmnet(xstuff, ystuff, alpha = 1, family = 'gaussian');
g_tum <- cv.glmnet(tumor, groups, alpha = 1, family = 'gaussian');
g_notum <- cv.glmnet(notum, groups, alpha = 1, family = 'gaussian');

# Plot lambdas to view the mean-squared errors
plot(g_xstuff)
plot(g_tum)
plot(g_notum)

# Find the lambda mins
xlam <- g_xstuff$lambda.min;
tumlam <- g_tum$lambda.min;
notumlam <- g_notum$lambda.min;

# Rerun glmnet applying the best lambda values
best_xstuff <- glmnet(xstuff, ystuff, alpha = 1, lambda = xlam)
best_tum <- glmnet(tumor, groups, alpha = 1, lambda = tumlam);
best_notum <- glmnet(notum, groups, alpha = 1, lambda = notumlam);

# Use the new glmnet to pull the coefficients for each variable for linear eq
coef(best_xstuff)
coef(best_tum)
coef(best_notum)
