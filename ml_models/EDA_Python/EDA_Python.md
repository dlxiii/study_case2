# Exploratory data analysis


```python
%matplotlib inline

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

pd.set_option("display.max_columns", 144)
```

## 1: Synopsis

This exploratory data analysis focus on the dataset from FVCOM simulation, in this dataset, several scnarios are included as below.

* slr_hgt: 4 cases included.

* nbs_case: 2 cases included.

|      Column 	| Description                                                                    	|
|------------:	|--------------------------------------------------------------------------------	|
|       `lat` 	| Lat of points in Tokyo Bay.                                                       |
|       `lon` 	| Lon of points in Tokyo Bay.                                                       |
|   `sigma_z` 	| Sigma Z of points, from 0 to 20, representing sea surface to bottom. 	            |
|   `slr_hgt` 	| SLR hight, from 0 to 2.0 meters, we have 0, 0.2, 1.0, and 2.0 data.            	|
|  `nbs_case` 	| NbS case, we have two case, 1 for reclamation case, 3 for rehabitation case.   	|
| `water_age` 	| The estimated water age by coastal circulation model.                           	|

This EDA is trying to find out the influences of different nbs cases regarding to the slr hight on water age distribution, and changes.

## 2: Data Processing


```python
filename = 'data.csv'
df = pd.read_csv(filename,
                 index_col=False)
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>lat</th>
      <th>lon</th>
      <th>sigma_z</th>
      <th>slr_hgt</th>
      <th>nbs_case</th>
      <th>water_age</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>35.259910</td>
      <td>139.743604</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>42.48</td>
    </tr>
    <tr>
      <th>1</th>
      <td>35.259910</td>
      <td>139.748108</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>42.63</td>
    </tr>
    <tr>
      <th>2</th>
      <td>35.264414</td>
      <td>139.703063</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>43.42</td>
    </tr>
    <tr>
      <th>3</th>
      <td>35.264414</td>
      <td>139.707568</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>43.19</td>
    </tr>
    <tr>
      <th>4</th>
      <td>35.264414</td>
      <td>139.712072</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>42.96</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.describe()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>lat</th>
      <th>lon</th>
      <th>sigma_z</th>
      <th>slr_hgt</th>
      <th>nbs_case</th>
      <th>water_age</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>732438.000000</td>
      <td>732438.000000</td>
      <td>732438.000000</td>
      <td>732438.000000</td>
      <td>732438.000000</td>
      <td>732438.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>35.482416</td>
      <td>139.851687</td>
      <td>10.498646</td>
      <td>0.824938</td>
      <td>2.032259</td>
      <td>46.154173</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.102229</td>
      <td>0.111896</td>
      <td>5.765785</td>
      <td>0.769314</td>
      <td>0.999480</td>
      <td>13.919992</td>
    </tr>
    <tr>
      <th>min</th>
      <td>35.259910</td>
      <td>139.626486</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.120000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>35.399550</td>
      <td>139.761622</td>
      <td>5.000000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>38.410000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>35.485135</td>
      <td>139.847207</td>
      <td>10.000000</td>
      <td>0.300000</td>
      <td>3.000000</td>
      <td>47.460000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>35.566216</td>
      <td>139.941802</td>
      <td>15.000000</td>
      <td>1.000000</td>
      <td>3.000000</td>
      <td>54.160000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>35.696847</td>
      <td>140.112973</td>
      <td>20.000000</td>
      <td>2.000000</td>
      <td>3.000000</td>
      <td>124.480000</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.isnull().sum()
```




    lat          0
    lon          0
    sigma_z      0
    slr_hgt      0
    nbs_case     0
    water_age    0
    dtype: int64



### 2.1 Heatmap of variables


```python
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>lat</th>
      <th>lon</th>
      <th>sigma_z</th>
      <th>slr_hgt</th>
      <th>nbs_case</th>
      <th>water_age</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>35.259910</td>
      <td>139.743604</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>42.48</td>
    </tr>
    <tr>
      <th>1</th>
      <td>35.259910</td>
      <td>139.748108</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>42.63</td>
    </tr>
    <tr>
      <th>2</th>
      <td>35.264414</td>
      <td>139.703063</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>43.42</td>
    </tr>
    <tr>
      <th>3</th>
      <td>35.264414</td>
      <td>139.707568</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>43.19</td>
    </tr>
    <tr>
      <th>4</th>
      <td>35.264414</td>
      <td>139.712072</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>42.96</td>
    </tr>
  </tbody>
</table>
</div>




```python
corr = df.corr()
mask = np.zeros_like(corr)
mask[np.triu_indices_from(mask)] = True
sns.heatmap(corr, cmap='tab10', annot=True);
```


    
![png](output_8_0.png)
    


### 2.2 Histogram of water age


```python
fig, axs = plt.subplots(2, 2, figsize=(10, 5))
axs[0, 0].hist(df[df['slr_hgt']==0.0]['water_age'], color='gray', edgecolor='black', alpha=0.8, range=[0,100])
axs[1, 0].hist(df[df['slr_hgt']==0.3]['water_age'], color='gray', edgecolor='black', alpha=0.8, range=[0,100])
axs[0, 1].hist(df[df['slr_hgt']==1.0]['water_age'], color='gray', edgecolor='black', alpha=0.8, range=[0,100])
axs[1, 1].hist(df[df['slr_hgt']==2.0]['water_age'], color='gray', edgecolor='black', alpha=0.8, range=[0,100])
plt.show()
```


    
![png](output_10_0.png)
    


All water age distributions fall into norm, left panels are 0.0 and 0.3, right panels are 1.0 and 2.0.

The peak values of each is roughly increasing form 40-50 to 50-60 days.


```python
fig, axs = plt.subplots(2, 1, figsize=(10, 5))
axs[0].hist(df[df['nbs_case']==1]['water_age'], color='gray', edgecolor='black', alpha=0.8, range=[0,100])
axs[1].hist(df[df['nbs_case']==3]['water_age'], color='gray', edgecolor='black', alpha=0.8, range=[0,100])
plt.show()
```


    
![png](output_12_0.png)
    


Also, water age in nbs case 3 has peak value between 50-60, while nbs case 1 is 40-50.


```python
def hisPlot(data=df,col_wrap=2,
            legend_title='NbS',legend_lables=['label 1', 'label 2'],
            savename="hist_nbs.png"):
    plt.clf()
    plt.figure(figsize=(12,6))
    g = sns.displot(data=data, x="water_age", kind="hist", hue="nbs_case", stat="density",
                col="slr_hgt",col_wrap=col_wrap,
                bins = 25,element="step",fill=True,
                palette="colorblind", height=4, aspect=1.5)
    sns.color_palette("husl", 9)
    sns.set(font_scale=1.3)
    plt.xlim(0, 100)
    g.set_axis_labels("Water age (day)", "Density")
    g.set_titles("{col_name} meters of SLR")
    g._legend.set_title(legend_title)
    new_labels = legend_lables
    for t, l in zip(g._legend.texts, new_labels): t.set_text(l)
    plt.savefig(savename,dpi=300)
    plt.show()
```


```python
def kdePlot(data=df,col_wrap=2,
            legend_title='NbS',legend_lables=['label 1', 'label 2'],
            savename="kde_nbs.png"):
    plt.clf()
    plt.figure(figsize=(12,6))
    g = sns.displot(data=data, x="water_age", kind="kde", hue="nbs_case",
                    col="slr_hgt",col_wrap=col_wrap,
                    fill=True,
                    palette="colorblind", height=4, aspect=1.5)
    sns.color_palette("husl", 9)
    sns.set(font_scale=1.3)
    plt.xlim(0, 100)
    g.set_axis_labels("Water age (day)", "Density")
    g.set_titles("{col_name} meters of SLR")
    g._legend.set_title(legend_title)
    new_labels = legend_lables
    for t, l in zip(g._legend.texts, new_labels): t.set_text(l)
    plt.savefig(savename,dpi=300)
    plt.show()
```


```python
hisPlot(data=df,col_wrap=2,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="hist_nbs.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_16_2.png)
    



```python
hisPlot(data=df[df.sigma_z == 1],col_wrap=2,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="hist_nbs_01.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_17_2.png)
    



```python
hisPlot(data=df[df.sigma_z == 8],col_wrap=2,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="hist_nbs_08.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_18_2.png)
    



```python
hisPlot(data=df[df.sigma_z == 16],col_wrap=2,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="hist_nbs_16.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_19_2.png)
    



```python
kdePlot(data=df,col_wrap=2,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="kde_nbs.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_20_2.png)
    



```python
kdePlot(data=df[df.sigma_z == 1],col_wrap=2,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="kde_nbs_01.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_21_2.png)
    



```python
kdePlot(data=df[df.sigma_z == 8],col_wrap=2,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="kde_nbs_08.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_22_2.png)
    



```python
kdePlot(data=df[df.sigma_z == 16],col_wrap=2,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="kde_nbs_16.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_23_2.png)
    


**Review of Histogram**

We plotted histogram of water age of each SLR and NbS case, through all water layers, and the surface, middle, bottom layers.

Here are some findings:

*  Considering the all layers of water, highist frequency group of label 1 and label 2 are 45-50 days and 50-55 days. And Label 1 is a little bit skewed left, Lable 2 is symmetric distributed.

* But for the different layers of water, distribution of water age varies.

1. 考虑不同NbS的情况，Lable 2 的峰值普遍较 Label 1 大，并且随着水深增大，差距增大。例如，表层和中层。

2. 继续深入不同水深，随着水深增加，水龄的分布更加集中（这个现象需要找到对应的英文名词）。

3. 但是，底层水龄出现了特殊的现象。底层的 Label 2 出现了uniform 或者mutimodal分布，这说明 Label 2 底层水龄分布较为均匀。


### 2.3 Jointplot of water age


```python
df_jp = df.rename(columns={"lat": "Lat.", 
                   "lon": "Lon.", 
                   "sigma_z": "Layer", 
                   "slr_hgt": "SLR", 
                   "nbs_case": "NbS", 
                   "water_age": "Water age"}, errors="raise")
df_jp.NbS.replace([1, 3], ['ERA', 'IRA'], inplace=True)
```


```python
g = sns.jointplot(data=df_jp[(df_jp.Layer==1) & (df_jp.SLR==0)], x="Lon.", y="Water age")
```


    
![png](output_27_0.png)
    



```python
g = sns.jointplot(data=df_jp[(df_jp.Layer==1) & (df_jp.SLR==0)], y="Lat.", x="Water age")
```


    
![png](output_28_0.png)
    



```python
g = sns.jointplot(data=df_jp[(df_jp.Layer==16) & (df_jp.SLR==0)], x="Lon.", y="Water age")
```


    
![png](output_29_0.png)
    



```python
g = sns.jointplot(data=df_jp[(df_jp.Layer==16) & (df_jp.SLR==0)], y="Lat.", x="Water age")
```


    
![png](output_30_0.png)
    



```python
def jointPlot(data=df,xx="lon",yy="water_age",savename="joint_nbs",
              label1="Lon.",label2="Water age (day)"):
    plt.clf()
    g = sns.jointplot(data=df, 
                      x="lon", y="water_age",kind="kde",hue="nbs_case",
                      shade=True,alpha=.5,
                      palette="colorblind")
    sns.set(font_scale=1.3)
    g.set_axis_labels(label1,label2)
    plt.savefig(savename,dpi=300)
    plt.show()
```


```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 16)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Lat.", x="Water age",kind="kde",hue="NbS",
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Water age (day)", "Lat.")
plt.savefig("joint_nbs_lat_16",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_32_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 16)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Water age", x="Lon.",kind="kde",hue="NbS",
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Lon.", "Water age (day)")
plt.savefig("joint_nbs_lon_16",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_33_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 8)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Lat.", x="Water age",kind="kde",hue="NbS",
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Water age (day)", "Lat.")
plt.savefig("joint_nbs_lat_08",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_34_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 8)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Water age", x="Lon.",kind="kde",hue="NbS",
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Lon.", "Water age (day)")
plt.savefig("joint_nbs_lon_08",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_35_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 1)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Lat.", x="Water age",kind="kde",hue="NbS",
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Water age (day)", "Lat.")
plt.savefig("joint_nbs_lat_01",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_36_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 1)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Water age", x="Lon.",kind="kde",hue="NbS",
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Lon.", "Water age (day)")
plt.savefig("joint_nbs_lon_01",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_37_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 16)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Lat.", x="Water age",kind="kde",hue="SLR",
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Water age (day)", "Lat.")
# plt.savefig("joint_nbs_lat_16",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_38_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 16)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Water age", x="Lon.",kind="kde",hue="SLR",
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Lon.", "Water age (day)")
# plt.savefig("joint_nbs_lon_16",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_39_2.png)
    


**A summary about jointplot analysis**

试图从空间分布上找到一些规律，在对底层分析的结果中发现，随着经纬度的增加，橙色案例的水龄逐渐增大，这个区域被认为是海湾的东北部。

这个发现是符合常理的。

另一方面，海平面上升的不同情景，从空间上看貌似没有很多的影响。

### 2.4 Boxplot


```python
# mean values of each figure
# Vertical averaged water age value
[[df[(df.nbs_case==1) & (df.slr_hgt==0)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==0.3)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0.3)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==1.0)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==1.0)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==2.0)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==2.0)].water_age.mean()]]
```




    [[41.294421549155814, 49.319637071602024],
     [41.21155987946244, 49.82838149249277],
     [41.6182754300426, 51.44426928489077],
     [41.4720921097193, 51.85613171206544]]




```python
# mean values of each figure
# Bottom water age value
[[df[(df.nbs_case==1) & (df.slr_hgt==0) & (df.sigma_z==16)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0) & (df.sigma_z==16)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==0.3) & (df.sigma_z==16)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0.3) & (df.sigma_z==16)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==1.0) & (df.sigma_z==16)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==1.0) & (df.sigma_z==16)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==2.0) & (df.sigma_z==16)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==2.0) & (df.sigma_z==16)].water_age.mean()]]
```




    [[46.87221169036328, 57.470973338976],
     [47.033692168810624, 58.21415996614482],
     [47.798882366222614, 60.40987092678787],
     [47.77093785310728, 61.15884395511349]]




```python
# mean values of each figure
# Surface water age value
[[df[(df.nbs_case==1) & (df.slr_hgt==0) & (df.sigma_z==1)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0) & (df.sigma_z==1)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==0.3) & (df.sigma_z==1)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0.3) & (df.sigma_z==1)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==1.0) & (df.sigma_z==1)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==1.0) & (df.sigma_z==1)].water_age.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==2.0) & (df.sigma_z==1)].water_age.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==2.0) & (df.sigma_z==1)].water_age.mean()]]
```




    [[31.52176709546384, 34.30898857384671],
     [31.014475287745473, 34.34591197630131],
     [30.702351613631258, 34.69542742276775],
     [30.087666440984112, 33.985376639864505]]




```python
plt.clf()
plt.figure(figsize=(12,6))
g = sns.boxplot(data=df_jp, y="NbS", x="Water age", hue="SLR",
                palette="colorblind",
                dodge=True,
                showmeans=True,
                meanprops={"marker":"o",
                           "markerfacecolor":"white",
                           "markeredgecolor":"black",
                           "markersize":"10"})
g.legend(loc='center right',ncol=1,title="SLR")
sns.set(font_scale=1.3)
plt.xlabel("Water age (day)")
plt.ylabel("NbS")
#plt.title("SLR Bias in Water age")
plt.savefig("box_slr_bias.png",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    
![png](output_45_1.png)
    



```python
plt.clf()
plt.figure(figsize=(12,6))
g = sns.boxplot(data=df_jp, x="SLR", y="Water age", hue="NbS",
                palette="colorblind",
                dodge=True,
                showmeans=True,
                meanprops={"marker":"o",
                           "markerfacecolor":"white",
                           "markeredgecolor":"black",
                           "markersize":"10"})
sns.set(font_scale=1.3)
plt.xlabel("SLR")
plt.ylabel("Water age (day)")
#plt.title("SLR Bias in Water age")
plt.savefig("box_nbs_bias.png",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    
![png](output_46_1.png)
    



```python
plt.clf()
plt.figure(figsize=(12,6))
g = sns.boxplot(data=df_jp[df_jp.Layer==16], y="NbS", x="Water age", hue="SLR",
                palette="colorblind",
                dodge=True,
                showmeans=True,
                meanprops={"marker":"o",
                           "markerfacecolor":"white",
                           "markeredgecolor":"black",
                           "markersize":"10"})
g.legend(loc='center right',ncol=1,title="SLR")
sns.set(font_scale=1.3)
plt.xlabel("Water age (day)")
plt.ylabel("NbS")
#plt.title("SLR Bias in Water age")
plt.savefig("box_slr_bias_16.png",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    
![png](output_47_1.png)
    



```python
plt.clf()
plt.figure(figsize=(12,6))
g = sns.boxplot(data=df_jp[df_jp.Layer==16], x="SLR", y="Water age", hue="NbS",
                palette="colorblind",
                dodge=True,
                showmeans=True,
                meanprops={"marker":"o",
                           "markerfacecolor":"white",
                           "markeredgecolor":"black",
                           "markersize":"10"})
sns.set(font_scale=1.3)
plt.xlabel("SLR")
plt.ylabel("Water age (day)")
#plt.title("SLR Bias in Water age")
plt.savefig("box_nbs_bias_16.png",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    
![png](output_48_1.png)
    


**A summary about boxplot analysis**

试图从bias上寻找SLR和NbS对水龄的影响。

SLR Bias 似乎没有太大的影响，NbS Bias 能看出显著的区别。

即使是底层水龄，ERA没有什么影响和变化，IRA增加略微较大。说明IRA相比ERA对SLR较为敏感。

现在产生的问题是：水年龄增量在那些方面比较明显？这个风险会突出表现在哪里？

## 3 Furthre Data Analysis

所以，在这一部分，主要分析水龄的增加量。

Baseline设置为SLR=0的case，不再对比分析NbS之间的差异分析。

* slr_hgt: 3 cases included.

* nbs_case: 2 cases included.

|      Column 	| Description                                                                    	|
|------------:	|--------------------------------------------------------------------------------	|
|       `lat` 	| Lat of points in Tokyo Bay.                                                       |
|       `lon` 	| Lon of points in Tokyo Bay.                                                       |
|   `sigma_z` 	| Sigma Z of points, from 0 to 20, representing sea surface to bottom. 	            |
|   `slr_hgt` 	| SLR hight, from 0.3 to 2.0 meters, we have 0.3, 1.0, and 2.0 data.            	|
|  `nbs_case` 	| NbS case, we have two case, 1 for reclamation case, 3 for rehabitation case.   	|
| `water_age_change` 	| The estimated water age change from baseline water age.                           	|



```python
data = {'lat': [], 
        'lon': [], 
        'sigma_z': [], 
        'slr_hgt': [], 
        'nbs_case': [], 
        'water_age_change': []} 
for ss in [3,10,20]:
    for nbs in [1,3]:
        for ll in [var for var in range(1,21)]:
            filepath = '../csv_files2_inner/c{0:02d}{1:02d}_m00_{2:02d}.csv'.format(ss,nbs,ll)
            # print(filepath)
            df = pd.read_csv(filepath,names=['lon','lat','water_age_change'],
                             header=None,index_col=False)
            df['water_age_change'] = pd.to_numeric(df['water_age_change'],errors='coerce')
            data['lat'] += df['lat'].values.tolist()
            data['lon'] += df['lon'].values.tolist()
            data['water_age_change'] += df['water_age_change'].values.tolist()
            data['sigma_z'] += [ll]*df.shape[0]
            data['slr_hgt'] += [ss/10]*df.shape[0]
            data['nbs_case'] += [nbs]*df.shape[0]
data = pd.DataFrame.from_dict(data)
data.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>lat</th>
      <th>lon</th>
      <th>sigma_z</th>
      <th>slr_hgt</th>
      <th>nbs_case</th>
      <th>water_age_change</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>35.259910</td>
      <td>139.743604</td>
      <td>1</td>
      <td>0.3</td>
      <td>1</td>
      <td>-0.63</td>
    </tr>
    <tr>
      <th>1</th>
      <td>35.259910</td>
      <td>139.748108</td>
      <td>1</td>
      <td>0.3</td>
      <td>1</td>
      <td>-0.64</td>
    </tr>
    <tr>
      <th>2</th>
      <td>35.264414</td>
      <td>139.703063</td>
      <td>1</td>
      <td>0.3</td>
      <td>1</td>
      <td>-0.67</td>
    </tr>
    <tr>
      <th>3</th>
      <td>35.264414</td>
      <td>139.707568</td>
      <td>1</td>
      <td>0.3</td>
      <td>1</td>
      <td>-0.66</td>
    </tr>
    <tr>
      <th>4</th>
      <td>35.264414</td>
      <td>139.712072</td>
      <td>1</td>
      <td>0.3</td>
      <td>1</td>
      <td>-0.65</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.isnull().sum()
```




    lat                     0
    lon                     0
    sigma_z                 0
    slr_hgt                 0
    nbs_case                0
    water_age_change    17700
    dtype: int64




```python
data.dropna(subset = ["water_age_change"], inplace=True)
data.drop(data[data['water_age_change'] < -15].index, inplace = True)
data.drop(data[data['water_age_change'] > 35].index, inplace = True)
```


```python
data.describe()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>lat</th>
      <th>lon</th>
      <th>sigma_z</th>
      <th>slr_hgt</th>
      <th>nbs_case</th>
      <th>water_age_change</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>550242.000000</td>
      <td>550242.000000</td>
      <td>550242.000000</td>
      <td>550242.000000</td>
      <td>550242.000000</td>
      <td>550242.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>35.482729</td>
      <td>139.851501</td>
      <td>10.495931</td>
      <td>1.100072</td>
      <td>2.032328</td>
      <td>0.980131</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.102417</td>
      <td>0.111839</td>
      <td>5.765660</td>
      <td>0.697950</td>
      <td>0.999478</td>
      <td>1.984822</td>
    </tr>
    <tr>
      <th>min</th>
      <td>35.259910</td>
      <td>139.626486</td>
      <td>1.000000</td>
      <td>0.300000</td>
      <td>1.000000</td>
      <td>-14.790000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>35.399550</td>
      <td>139.761622</td>
      <td>5.000000</td>
      <td>0.300000</td>
      <td>1.000000</td>
      <td>-0.160000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>35.485135</td>
      <td>139.847207</td>
      <td>10.000000</td>
      <td>1.000000</td>
      <td>3.000000</td>
      <td>0.520000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>35.570721</td>
      <td>139.941802</td>
      <td>15.000000</td>
      <td>2.000000</td>
      <td>3.000000</td>
      <td>1.440000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>35.696847</td>
      <td>140.112973</td>
      <td>20.000000</td>
      <td>2.000000</td>
      <td>3.000000</td>
      <td>34.880000</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.to_csv('data2.csv',index=False)
```


```python
df = data.copy()
```


```python
sns.pairplot(df)
```




    <seaborn.axisgrid.PairGrid at 0x7fca2b43a3d0>




    
![png](output_57_1.png)
    



```python
corr = df.corr()
mask = np.zeros_like(corr)
mask[np.triu_indices_from(mask)] = True
sns.heatmap(corr, cmap='tab10', annot=True);
```


    
![png](output_58_0.png)
    



```python
fig, axs = plt.subplots(2, 2, figsize=(10, 5))
axs[0, 0].hist(df[df['slr_hgt']==0.0]['water_age_change'], color='gray', edgecolor='black', alpha=0.8, range=[-5,10])
axs[1, 0].hist(df[df['slr_hgt']==0.3]['water_age_change'], color='gray', edgecolor='black', alpha=0.8, range=[-5,10])
axs[0, 1].hist(df[df['slr_hgt']==1.0]['water_age_change'], color='gray', edgecolor='black', alpha=0.8, range=[-5,10])
axs[1, 1].hist(df[df['slr_hgt']==2.0]['water_age_change'], color='gray', edgecolor='black', alpha=0.8, range=[-5,10])
plt.show()
```


    
![png](output_59_0.png)
    



```python
fig, axs = plt.subplots(2, 1, figsize=(10, 5))
axs[0].hist(df[df['nbs_case']==1]['water_age_change'], color='gray', edgecolor='black', alpha=0.8, range=[-3,8])
axs[1].hist(df[df['nbs_case']==3]['water_age_change'], color='gray', edgecolor='black', alpha=0.8, range=[-3,8])
plt.show()
```


    
![png](output_60_0.png)
    



```python
def hisPlot(data=df,col_wrap=2,
            legend_title='NbS',legend_lables=['label 1', 'label 2'],
            savename="hist_nbs.png"):
    plt.clf()
    plt.figure(figsize=(12,6))
    g = sns.displot(data=data, x="water_age_change", kind="hist", hue="nbs_case", stat="density",
                col="slr_hgt",col_wrap=col_wrap,
                bins = 200,element="step",fill=True,
                palette="colorblind", height=4, aspect=1.5)
    sns.color_palette("husl", 9)
    sns.set(font_scale=1.3)
    plt.xlim(-5, 10)
    g.set_axis_labels("Water age change (day)", "Density")
    g.set_titles("{col_name} meters of SLR")
    g._legend.set_title(legend_title)
    new_labels = legend_lables
    for t, l in zip(g._legend.texts, new_labels): t.set_text(l)
    plt.savefig(savename,dpi=300)
    plt.show()
    
def kdePlot(data=df,col_wrap=2,
            legend_title='NbS',legend_lables=['label 1', 'label 2'],
            savename="kde_nbs.png"):
    plt.clf()
    plt.figure(figsize=(12,6))
    g = sns.displot(data=data, x="water_age_change", kind="kde", hue="nbs_case",
                    col="slr_hgt",col_wrap=col_wrap,
                    fill=True,
                    palette="colorblind", height=4, aspect=1.5)
    sns.color_palette("husl", 9)
    sns.set(font_scale=1.3)
    plt.xlim(-5, 10)
    g.set_axis_labels("Water age change (day)", "Density")
    g.set_titles("{col_name} meters of SLR")
    g._legend.set_title(legend_title)
    new_labels = legend_lables
    for t, l in zip(g._legend.texts, new_labels): t.set_text(l)
    plt.savefig(savename,dpi=300)
    plt.show()
```


```python
hisPlot(data=df,col_wrap=3,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="change_hist_nbs.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_62_2.png)
    



```python
hisPlot(data=df[df.sigma_z == 1],col_wrap=3,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="change_hist_nbs_01.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_63_2.png)
    



```python
hisPlot(data=df[df.sigma_z == 8],col_wrap=3,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="change_hist_nbs_08.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_64_2.png)
    



```python
hisPlot(data=df[df.sigma_z == 16],col_wrap=3,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="change_hist_nbs_16.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_65_2.png)
    



```python
kdePlot(data=df,col_wrap=3,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="change_kde_nbs.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_66_2.png)
    



```python
kdePlot(data=df[df.sigma_z == 1],col_wrap=3,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="change_kde_nbs_01.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_67_2.png)
    



```python
kdePlot(data=df[df.sigma_z == 8],col_wrap=3,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="change_kde_nbs_08.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_68_2.png)
    



```python
kdePlot(data=df[df.sigma_z == 16],col_wrap=3,
        legend_title='NbS',legend_lables=['ERA', 'IRA'],
        savename="change_kde_nbs_16.png")
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 864x432 with 0 Axes>



    
![png](output_69_2.png)
    



```python
df_jp = df.rename(columns={"lat": "Lat.", 
                   "lon": "Lon.", 
                   "sigma_z": "Layer", 
                   "slr_hgt": "SLR", 
                   "nbs_case": "NbS", 
                   "water_age_change": "Water age change"}, errors="raise")
df_jp.NbS.replace([1, 3], ['ERA', 'IRA'], inplace=True)
```


```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 16)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Lat.", x="Water age change",kind="kde",hue="NbS",
                  xlim = (-5,15),
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Water age change(day)", "Lat.")
plt.savefig("change_joint_nbs_lat_16",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_71_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 16)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Water age change", x="Lon.",kind="kde",hue="NbS",
                  ylim = (-5,15),
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Lon.", "Water age change (day)")
plt.savefig("change_joint_nbs_lon_16",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_72_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 8)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Lat.", x="Water age change",kind="kde",hue="NbS",
                  xlim = (-5,10),
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Water age change(day)", "Lat.")
plt.savefig("change_joint_nbs_lat_08",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_73_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 8)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Water age change", x="Lon.",kind="kde",hue="NbS",
                  ylim = (-5,10),
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Lon.", "Water age change (day)")
plt.savefig("change_joint_nbs_lon_08",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_74_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 1)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Lat.", x="Water age change",kind="kde",hue="NbS",
                  xlim = (-5,5),
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Water age change(day)", "Lat.")
plt.savefig("change_joint_nbs_lat_01",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_75_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 1)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Water age change", x="Lon.",kind="kde",hue="NbS",
                  ylim = (-5,5),
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Lon.", "Water age change (day)")
plt.savefig("change_joint_nbs_lon_01",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_76_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 16)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Lat.", x="Water age change",kind="kde",hue="SLR",
                  xlim = (-5,15),
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Water age change (day)", "Lat.")
# plt.savefig("joint_nbs_lat_16",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_77_2.png)
    



```python
plt.clf()
plt.figure(figsize=(6,6))
g = sns.jointplot(data=df_jp[((df_jp.Layer == 16)) & 
                          ((df_jp.NbS=="ERA") | (df_jp.NbS=="IRA"))], 
                  y="Water age change", x="Lon.",kind="kde",hue="SLR",
                  ylim = (-5,15),
                  shade=True,alpha=.5,
                  palette="colorblind")
sns.set(font_scale=1.3)
g.set_axis_labels("Lon.", "Water age change (day)")
# plt.savefig("joint_nbs_lon_16",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    <Figure size 432x432 with 0 Axes>



    
![png](output_78_2.png)
    



```python
# mean values of each figure
# Vertical averaged water age value
[[df[(df.nbs_case==1) & (df.slr_hgt==0.3)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0.3)].water_age_change.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==1.0)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==1.0)].water_age_change.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==2.0)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==2.0)].water_age_change.mean()]]
```




    [[-0.07257252535714175, 0.5781493479086685],
     [0.36815042738903403, 2.198906891588653],
     [0.14510958518602568, 2.508573629829751]]




```python
# mean values of each figure
# Bottom water age value
[[df[(df.nbs_case==1) & (df.slr_hgt==0.3) & (df.sigma_z==16)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0.3) & (df.sigma_z==16)].water_age_change.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==1.0) & (df.sigma_z==16)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==1.0) & (df.sigma_z==16)].water_age_change.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==2.0) & (df.sigma_z==16)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==2.0) & (df.sigma_z==16)].water_age_change.mean()]]
```




    [[0.24800225479143176, 0.8161579058475819],
     [1.0149920724801869, 3.0174549692731465],
     [0.8616805774870275, 3.601195606252644]]




```python
# mean values of each figure
# Surface water age value
[[df[(df.nbs_case==1) & (df.slr_hgt==0.3) & (df.sigma_z==1)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==0.3) & (df.sigma_z==1)].water_age_change.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==1.0) & (df.sigma_z==1)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==1.0) & (df.sigma_z==1)].water_age_change.mean()],
 [df[(df.nbs_case==1) & (df.slr_hgt==2.0) & (df.sigma_z==1)].water_age_change.mean(),
  df[(df.nbs_case==3) & (df.slr_hgt==2.0) & (df.sigma_z==1)].water_age_change.mean()]]
```




    [[-0.5013816381638199, 0.08844481958219029],
     [-0.7262054979720608, 0.4576654683865532],
     [-1.4301350135013517, -0.3239776324119016]]




```python
plt.clf()
plt.figure(figsize=(12,6))
g = sns.boxplot(data=df_jp, y="NbS", x="Water age change", hue="SLR",
                palette="colorblind",
                dodge=True,
                showmeans=True,
                meanprops={"marker":"o",
                           "markerfacecolor":"white",
                           "markeredgecolor":"black",
                           "markersize":"10"})
g.legend(loc='center right',ncol=1,title="SLR")
sns.set(font_scale=1.3)
plt.xlabel("Water age change (day)")
plt.ylabel("NbS")
#plt.title("SLR Bias in Water age")
plt.savefig("change_box_slr_bias.png",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    
![png](output_82_1.png)
    



```python
plt.clf()
plt.figure(figsize=(12,6))
g = sns.boxplot(data=df_jp, x="SLR", y="Water age change", hue="NbS",
                palette="colorblind",
                dodge=True,
                showmeans=True,
                meanprops={"marker":"o",
                           "markerfacecolor":"white",
                           "markeredgecolor":"black",
                           "markersize":"10"})
sns.set(font_scale=1.3)
plt.xlabel("SLR")
plt.ylabel("Water age change (day)")
#plt.title("SLR Bias in Water age")
plt.savefig("change_box_nbs_bias.png",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    
![png](output_83_1.png)
    



```python
plt.clf()
plt.figure(figsize=(12,6))
g = sns.boxplot(data=df_jp[df_jp.Layer==16], y="NbS", x="Water age change", hue="SLR",
                palette="colorblind",
                dodge=True,
                showmeans=True,
                meanprops={"marker":"o",
                           "markerfacecolor":"white",
                           "markeredgecolor":"black",
                           "markersize":"10"})
g.legend(loc='center right',ncol=1,title="SLR")
sns.set(font_scale=1.3)
plt.xlabel("Water age change (day)")
plt.ylabel("NbS")
#plt.title("SLR Bias in Water age")
plt.savefig("change_box_slr_bias_16.png",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    
![png](output_84_1.png)
    



```python
plt.clf()
plt.figure(figsize=(12,6))
g = sns.boxplot(data=df_jp[df_jp.Layer==16], x="SLR", y="Water age change", hue="NbS",
                palette="colorblind",
                dodge=True,
                showmeans=True,
                meanprops={"marker":"o",
                           "markerfacecolor":"white",
                           "markeredgecolor":"black",
                           "markersize":"10"})
sns.set(font_scale=1.3)
plt.xlabel("SLR")
plt.ylabel("Water age change (day)")
#plt.title("SLR Bias in Water age")
plt.savefig("change_box_nbs_bias_16.png",dpi=300)
plt.show()
```


    <Figure size 432x288 with 0 Axes>



    
![png](output_85_1.png)
    



```python

```
