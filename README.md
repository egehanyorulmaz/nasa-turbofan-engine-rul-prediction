# NASA Turbofan Jet Engine Data Set

## Introduction

This project aims to predict the remaining useful life (RUL) of turbofan jet engines using the NASA Turbofan Jet Engine Data Set from Kaggle. The dataset includes run-to-failure simulated data from turbofan jet engines. The engine degradation simulation was carried out using C-MAPSS, and four different sets were simulated under different combinations of operational conditions and fault modes.

The objective of this project is to predict the number of remaining operational cycles before failure in the test set. The data sets consist of multiple multivariate time series, each from a different engine, and each engine starts with different degrees of initial wear and manufacturing variation. The data is contaminated with sensor noise, and the engine develops a fault at some point during the time series.

## Data

The data is provided as a zip-compressed text file with 26 columns of numbers, separated by spaces. Each row is a snapshot of data taken during a single operational cycle, and each column is a different variable. The columns correspond to unit number, time in cycles, operational settings 1, 2, and 3, and 22 sensor measurements.

The data set is divided into four subsets: FD001, FD002, FD003, and FD004. Each subset consists of training and test data. FD001 has 100 training trajectories and 100 test trajectories, FD002 has 260 training trajectories and 259 test trajectories, FD003 has 100 training trajectories and 100 test trajectories, and FD004 has 248 training trajectories and 249 test trajectories. The conditions and fault modes vary for each subset.

## Files

- `EDA-and-Modeling + Weibull Curve.ipynb`: This Jupyter notebook contains the exploratory data analysis and modeling code for the project. It includes survival analysis methods and a generalized linear model with a binomial link function. It utilizes the methods in survial analysis like Partial Effects on Survival, WeibullAFTFitter and KaplanMeier curve. 

- `LNM Group Assignment 1.R`: This R script contains additional code for the project.

- `src/EDA-and-Modeling.ipynb`: This notebook contains the application of Random Forest Regressor to predict the Remaining Useful Life (RUL) dependent variable.

- `LogisticRegression.ipynb`: This Jupyter notebook contains additional code for the project, including a Hosmer-Lemeshow test, time-series feature generation, application of generalized linear model with binomial link function and confusion matrix.

## Conclusion

This project utilizes survival analysis methods and a generalized linear model to predict the remaining useful life of turbofan jet engines. The NASA Turbofan Jet Engine Data Set from Kaggle is used to train and test the model. The code is available in Jupyter notebooks and an R script.
