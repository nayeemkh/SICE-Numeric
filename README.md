# SICE-Numeric Algorithm
Input: x: instances with missing numeric data in a dataset;
y: instances with no missing data in the same dataset.;
m: number of imputation defined by user
Output: x’: updated x with imputed missing data
1 for each missing value in x do
2 Use MICE to find the the missing value ;
3 end
4 Repeat for n times;
5 miceResult [i] <- imputed data for ith missing value;
6 for each row in miceResult do
7 SICEresult <- Mean(miceResult[i,1:m]);
8 x’<- x updated with SICEresult
9 end
