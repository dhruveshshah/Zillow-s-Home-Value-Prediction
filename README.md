# Zillow's-Home-Value-Prediction
Here is a first exploratory analysis of the competition dataset. We are provided with a list of real estate properties in three counties (Los Angeles, Orange and Ventura, California) data in 2016.

Zillow provides a “Zestimate”, which is an estimated property value.

Our task in this competition is to predict the the difference between the actual price and the estimate of the price (Zestimate). So, in fact we are predicting, where Zillow’s Zestimate will be good, and where it will be bad.

So, far so good. However, we don’t have to predict a single value, but instead for 6 different time points (from October 2016 to December 2017) (see sample submission)

The dataset consists of information about 2.9 million properties and is grouped into 2 files: 1) properties_2016.csv (containing information about the properties themselves) 2) train_2016.csv (containing information about the transcations)
