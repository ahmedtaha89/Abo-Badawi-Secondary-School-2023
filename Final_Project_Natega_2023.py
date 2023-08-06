#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import requests 
from bs4 import BeautifulSoup


# In[2]:


my_list=[]
for seats in range(1459530,1459580):
  response = requests.get(f'https://shbabbek.com/natega/{seats}')
  try:
   if response.status_code == 200:
     my_list.append(response.content)     
    
  except:
    break

print(len(my_list))


# In[3]:


sourse = response.content
response.text


# In[27]:


def extraction(response):
    soup = BeautifulSoup(response, 'lxml')
    container = soup.find('div', class_='col-lg-12 mt-4 p-3 bg-primary mx-auto shadow-lg rounded')
    nested_divs = container.find_all('div', class_='d-inline-flex bg-white shadow-sm py-2 px-4 rounded-pill')

    span_texts = []  # Create an empty list to store the span texts

    for div in nested_divs:
        span_element = div.find('span')  # Find the span element within the div
        if span_element:
            span_text = span_element.text.strip()
            span_texts.append(span_text)  # Append the span text to the list

    # Now the span_texts list contains the text from all the <span> elements
    result = {}
    result["seat_no"]=soup.find_all('span',class_='text-center font-weight-bold text-white')[0].text.strip()
    result["name"]=soup.find_all('div',class_='text-lg fs-3 font-weight-bold text-center mb-1')[0].text.strip()
    result["total_marks"]=soup.find_all('table',class_='table table-striped table-customize shadow')[2].find_all('td')[9].text.strip()
    result["percentage"]=soup.find_all('table',class_='table table-striped table-customize shadow')[2].find_all('td')[11].text.strip()
    result["sc_name"]=soup.find_all('table',class_='table table-striped table-customize shadow')[2].find_all('td')[5].text.strip()
    result["edu_administration"]=soup.find_all('table',class_='table table-striped table-customize shadow')[2].find_all('td')[7].text.strip()
    result["recurring_arrangement"]=soup.find_all('table',class_='table table-striped table-customize shadow')[1].find_all('td')[1].text.strip()
    result["non_recurring_arrangement"]=soup.find_all('table',class_='table table-striped table-customize shadow')[0].find_all('td')[1].text.strip()
    result["expected"]= span_texts
    #check pass or fill
    
    result["passed"]=1 if(soup.find_all('span',class_='text-center font-weight-bold text-white')[1].text=="ناجح") else[0]
    #select division
    result["select_division"]=soup.find_all('div',class_='text-black-50 fs-5 text-center')[0].text.strip().strip()
    #get the result of the fixed subjects
    result["arabic"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[1].text.strip()
    result["english"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[3].text.strip()
    result["third_lang"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[5].text.strip()
        #extracte each division
    result["history"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[9].text.strip()
    result["geograpgy"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[11].text.strip()
    result["philosophy"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[13].text.strip()
    result["psychology"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[15].text.strip()
    result["chemistry"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[17].text.strip()
    result["biology"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[19].text.strip()
    result["geology"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[21].text.strip()
    result["physics"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[25].text.strip()
    result["chemistry"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[17].text.strip()
    result["physics"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[25].text.strip()
    result["pure_math"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[7].text.strip()
    result["applied_math"]=soup.find_all('table',class_='table table-striped table-customize shadow')[3].find_all('td')[23].text.strip()

    return result


# In[28]:


extraction(my_list[15])


# In[29]:


final = pd.DataFrame()
for i in my_list[1:]:
  sourse =i
  result = extraction(sourse)
  final = final.append(result,ignore_index=True)


# In[30]:


final


final.to_csv(r'D:\Projects\natega\new_result.csv', index=False)

