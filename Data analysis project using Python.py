#!/usr/bin/env python
# coding: utf-8

# In[1]:


pip install kaggle


# In[4]:


import kaggle


# In[5]:


get_ipython().system('kaggle datasets download ankitbansal06/retail-orders -f orders.csv')


# In[63]:


import zipfile 
zip_ref =zipfile.ZipFile('orders.csv.zip')
zip_ref.extractall()
zip_ref.close()


# In[64]:


import pandas as pd


# In[65]:


df=pd.read_csv("orders.csv")


# In[66]:


df.head()


# In[67]:


df['Ship Mode'].unique()


# In[68]:


df=pd.read_csv("orders.csv",na_values=['Not Available','unknown'])


# In[69]:


df['Ship Mode'].unique()


# In[70]:


df.columns=df.columns.str.lower() #this will change all the columns name to lower case


# In[71]:


df.columns


# In[72]:


df.columns=df.columns.str.replace(' ','_') #here we have replaced the space between two words in the column name 


# In[40]:





# In[73]:


df.head()


# In[74]:


df['discount']=df['list_price']*df['discount_percent']*0.01


# In[46]:


df.head()


# In[75]:


#finding the sale price
df['sale_price']=df['list_price']-df['discount']


# In[76]:


df['profit']=df['sale_price']-df['cost_price']


# In[77]:


df['order_date']=pd.to_datetime(df['order_date'],format="%Y-%m-%d") #here we changed the dataype of order_date to datetime format, because earlier it was in object format and we cannot perfom operation on that column.


# In[54]:


df.dtypes


# In[78]:


#dropping the unnecessary columns
df.drop(columns=['list_price','discount_percent','cost_price'],inplace=True)


# In[79]:


df.head()


# In[92]:


#loading the data into sql server
import sqlalchemy as sal
engine = sal.create_engine(r'mssql+pyodbc://DESKTOP-7HCQJ62\SQLEXPRESS/master?driver=ODBC+Driver+17+for+SQL+Server')
conn=engine.connect()


# In[94]:


#load the data into sql server
df.to_sql('df_orders',con=conn,index=False,if_exists='append')


# In[ ]:




