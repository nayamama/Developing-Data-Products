Framingham Heart Study
========================================================
author: Qi Yang
date: Aug 23,2015


Evaluation Risk Factors to Save Lives
=======================================================

Framingham Heart Study is one of the most important epidemiological studies ever conducted, and the underlying analytics that led to our current understanding of cardiovascular disease.

There were 4240 cases studied. By analyzing the data set, we find some physical factors can help us predict the risk of hypertensive effectively.

- *Serum total cholesterol*
- *serum glucose*
- *systolic blood pressure/diastolic blood pressure*

Factor Index comparison
========================================================




**total cholesterol**

```
       0        1 
235.1474 245.3890 
```
**glucose**

```
       0        1 
80.67925 89.00842 
```
***
**systolic blood pressure**

```
       0        1 
130.3373 143.6188 
```
**diastolic blood pressure**

```
       0        1 
82.16643 86.98137 
```

1: Heart disease patient

0: Health people

Training a Prediction Model
========================================================
![plot of chunk unnamed-chunk-6](practice-figure/unnamed-chunk-6-1.png) 
***
This model is learned by logistic regression. 
* The accuracy of this model on test set is 0.8483896. 
* The AUC value on test set is 0.7421095.

Prospect
========================================================

The Framingham Study further reported risk equations linking common risk factors to both coronary heart disease, stroke, and overall fatal and non-fatal cardiovascular disease (CVD). If we can collect all these factors together to train more explicit model, it will help physicians and patients to predict and prevent potential risks.

