
# coding: utf-8

# In[1]:

from bs4 import BeautifulSoup as bs
import urllib2
import re
import ast
import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


# In[16]:

df=pd.read_csv('uni_ranking.csv')

for i,x in enumerate(df['School']):
    sep=['University of California','University of Michigan','University of North Carolina',
         'University of Minnesota','University of Colorado','University of Nebraska',
         'University of Maryland','University of Missouri','Indiana University-Purdue University']         
    at=['University of Illinois']
    rem=['Ohio State University','Pennsylvania State University','Brigham Young University']
    
    for a in sep:
        if x.startswith(a):
            df['School'][i]=a + ' - ' + x[len(a):]
            print df['School'][i]
            continue
    for a in at:
        if x.startswith(a):
            df['School'][i]=a + ' at ' + x[len(a):]
            print df['School'][i]
            continue
            
    for a in rem:
        if x.startswith(a):
            df['School'][i]=a
            continue

df.to_csv('uni_ranking_clean.csv', index=True)


# In[15]:

df=pd.read_csv('uni_value_clean.csv')
for i, x in enumerate(df['Name']):
    df['Name'][i]=unicode(x,errors='ignore').strip()
df.to_csv('uni_value_very_clean.csv', index=True)


# In[5]:

df=pd.read_csv('uni_major.csv')
for i, x in enumerate(df['Name']):
    df['Name'][i]=unicode(x,errors='ignore').strip()
df.to_csv('uni_major_clean.csv', index=True)


# In[6]:

df=pd.read_csv('uni_career.csv')
for i, x in enumerate(df['Name']):
    df['Name'][i]=unicode(x,errors='ignore').strip()
df.to_csv('uni_career_clean.csv', index=True)

