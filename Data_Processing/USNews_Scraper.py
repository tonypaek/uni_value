
# coding: utf-8

# In[2]:

from bs4 import BeautifulSoup as bs
import urllib2
import re
import ast
import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


# In[63]:

col=['Rank','Score','School','Location','Tuition','Total_Enrollment','Acceptance_Rate','Retention_Rate','Graduation_Rate']
output=pd.DataFrame(columns=col)

def uni_scraper(url,df):
    page=urllib2.urlopen(url)
    soup=bs(page)
    data= soup.table
    body=data.tbody
    
    unis=body.find_all('tr')
    
    # Clean data a bit to have uniformity
    for i,uni in enumerate(unis):
        a=uni.get_text("|",strip=True).encode('ascii','ignore').split('|')
        a=[x for x in a if (x!='Locked') and (x!='#') and (x!='Overall Score:') and (x!='Tie') and (x!='Rank Not Published.')]
        if len(a)>9:
            a=[x for x in a if ( x!='6') and (x!='8') and (x!='4') and (x!='1') and (x!='L') and
               (x!='Program too new or too small for U.S. News to calculate a ranking.')]
        df.loc[len(df)]=a
    return df

for i in range(12)[1:]:
    name_url="http://colleges.usnews.rankingsandreviews.com/best-colleges/rankings/national-universities/data/page+" +             str(i)
    output=uni_scraper(name_url,output)
    
output.to_csv('uni_ranking.csv', index=True)


# In[46]:

a=[1,2,3,4]
a=[x for x in a if (x!=2) and (x!=4)]
print a


# In[140]:




# In[38]:

output=pd.DataFrame()

unis=body.find_all('tr')

for uni in unis:
#    print uni
#    print uni
    print score
    '''
    name= uni.find('a',class_='school-name').string
    total_enrol= uni.find_all('td',class_='column-even table-column-even total_all_students ')[0].string
    accept_rate= uni.find_all('td',class_='column-odd table-column-odd r_c_accept_rate ')[0].string
    ret_rate= uni.find_all('td',class_='column-even table-column-even r_c_avg_pct_retention cluetip')[0].string
    grad_rate= uni.find_all('td',class_='column-odd table-column-odd r_c_avg_pct_grad_6yr cluetip')[0].string
    '''
#    print score
#    print name
#    print total_enrol
#    print accept_rate
#    print ret_rate
#    print grad_rate   
    break
    '''
    a=uni
    
    get_text("|",strip=True).encode('ascii','ignore').split('|')
    del a[-2:]
    del a[0]
    if len(a)==11:
        del a[1]
    del a[1]
    a[1]=a[1][0:2]
    print a
''' 
    
    
'''
tds= uni.find_all('td')
for i in tds:
    print i.get_text("|",strip=True)
'''
'''
print rank
print name
print tuition
print total_enrol
print accep_rate
print ret_rate
print grad_rate
'''



# In[ ]:

def scrape_college(yr): 
    
  name_url="http://colleges.usnews.rankingsandreviews.com/best-colleges/rankings/national-universities/data/page+" +             str(no_page) + '/all/all'
  # Open a page with urllib2
  page=urllib2.urlopen(name_url)

  # Turn it into a soup instance
  soup = bs(page)    

  temp = soup.find(text=re.compile("rankingsTableData"))

  # Start of Table Data
  start=temp.find('[')
  # End of Table Data
  end=temp.rfind(']')+1
  # Concatenate the data
  data= temp[start:end]
  # Put it into a datatype in Python
  dict_data=ast.literal_eval(data)

  # Turn the data into a dataframe
  df=pd.DataFrame(dict_data)  

  # Drop unnecessary columns
  df=df.drop([u'url',u'logo'],1)
 
  # Add a column for the year 
  df['year']=yr
  
  return df

def usage():
  sys.stderr.write("""
  Usage: python fbr_team_scraper [output_file] 
         Scrapes football team recruiting data from
         2002 to 2015, and stores it in the output_file""")

if __name__ == "__main__":
  if len(sys.argv)!=2:
    usage()
    sys.exit(1)

  df=pd.DataFrame()  
  for i in range(14):
    yr=2002+i
    df=df.append(scrape_fr_team(yr))
    print "scraping " + str(yr) + "...."
  print "Writing to" 
  df.to_csv(sys.argv[1])


# In[132]:

col=['Rank','Score','School','Location','Tuition','Total_Enrollment','Acceptance_Rate','Retention_Rate','Graduation_Rate']
output=pd.DataFrame(columns=col)
output.loc[len(output)]=a
print output


# In[7]:

name_url="http://colleges.usnews.rankingsandreviews.com/best-colleges/rankings/national-universities/data/page+1"

page=urllib2.urlopen(name_url)
soup=bs(page)
data= soup.table
header=data.thead
for i in header.find_all('a'):
    print i.string
body=data.tbody

