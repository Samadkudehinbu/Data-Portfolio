#!/usr/bin/env python
# coding: utf-8

# # Netflix Dataset Analysis Project 
# 
# #### By Abdulsamad Kudehinbu

# ##### This Netflix Dataset has information about TV Shows and Movies available on Netflix till 2021.

# ##### This dataset is collected from Fixable which is a third-party Netflix search engine, and available on Kaggle website for free.

# ### Importing the dataset

# In[24]:


import pandas as pd
data = pd.read_csv(r"C:\Users\830 G7 New Version\Documents\Data Analysis\DA Career Portfolio\Python\DSL\Netflix Dataset\netflix_data.csv")


# In[25]:


data


# ### Basic information about the dataset

# In[26]:


data.head()


# In[27]:


data.shape


# In[28]:


data.size


# In[29]:


data.columns


# In[30]:


data.dtypes


# In[31]:


data.info()


# ### Removing duplicates

# In[32]:


data.head()


# In[33]:


data.shape


# In[34]:


data[data.duplicated()]


# In[35]:


data.drop_duplicates(inplace = True)


# ### Amount of Null Values

# In[36]:


data.head()


# In[37]:


data.isnull()


# In[38]:


data.isnull().sum()


# #### Seaborn Library import

# In[39]:


import seaborn as sns
import matplotlib.pyplot as plt


# In[40]:


sns.heatmap(data.isnull())


# In[ ]:





# ### Top 10 Countries in Netflix Content

# In[41]:


country_counts = data['Country'].value_counts().head(10)


# In[42]:


country_counts


# In[43]:


country_counts = data['Country'].value_counts().head(10)
country_counts.plot(kind='bar')
plt.xlabel('Country')
plt.ylabel('Number of Titles')
plt.title('Top 10 Countries in Netflix Content')
plt.show()


# In[ ]:





# ### Q1. For 'House of Cards', what is the show-id and who is the director of the show?

# In[44]:


data.head()


# In[45]:


data[data['Title'].isin(['House of Cards'])]


# In[46]:


data[data['Title'].str.contains('House of Cards')]


# In[ ]:





# ### Q2. In which year was the highest number of TV Shows and Movies releases? Show with a Bar Graph.

# In[47]:


data.dtypes


# In[48]:


data['Date_N'] = pd.to_datetime(data['Release_Date'], format = 'mixed')


# In[49]:


data.dtypes


# In[50]:


data['Date_N'].dt.year.value_counts()


# #### Bar Graph

# In[51]:


data['Date_N'].dt.year.value_counts().plot(kind='bar')


# In[ ]:





# ### Q3. How many Movies and TV Shows are in the dataset? Show with a Bar Graph.

# In[52]:


data.head(2)


# In[53]:


data.groupby('Category')['Category'].count()


# #### Countplot

# In[54]:


sns.countplot(data['Category'])


# In[ ]:





# ### Q4. Show all the movies that were released in the year 2020.

# In[55]:


data.head(2)


# In[56]:


data['Year'] = data['Date_N'].dt.year


# In[57]:


data.head(2)


# In[58]:


data[(data['Category'] == 'Movie') & (data['Year'] == 2020)]


# In[ ]:





# ### Q5. Show only the Titles of all TV shows that were released in India only.

# In[70]:


data.head(2)


# In[59]:


data[(data['Category'] == 'TV Show') & (data['Country'] == 'India')]['Title']


# In[60]:


data[(data['Category'] == 'TV Show') & (data['Country'] == 'India')]


# ### Q6. Show Top 10 directors who directed the highest number of TV Shows and Movies.

# In[76]:


data.head(2)


# In[16]:


top_directots = data['Director'].value_counts().head(10)
top_directots


# In[17]:


top_directors = data['Director'].value_counts().head(10)
top_directors.plot(kind='bar')
plt.xlabel('Director')
plt.ylabel('Number of Titles')
plt.title('Top 10 Directors on Netflix')
plt.show()


# ### Q7. Show all the records, where "Category is Movie and Type is is Comedies" or "Country is United Kingdom"

# In[79]:


data.head(2)


# In[82]:


data[((data['Category'] == 'Movie') & (data['Type'] == 'Comedies')) | (data['Country'] == 'United Kingdom')]


# In[ ]:





# ### Q8. In how many movies and shows was Tom Cruise cast?

# In[83]:


data.head(2)


# In[89]:


data_new = data.dropna()


# In[90]:


data_new.head(2)


# In[96]:


data_new[data_new['Cast'].str.contains('Tom Cruise')]['Cast'].count()


# In[ ]:





# ### Q9. What are the different ratings defined by Netflix?

# In[97]:


data.head(2)


# In[98]:


data['Rating'].nunique()


# In[99]:


data['Rating'].unique()


# In[ ]:





# ### Q9.1. How many movies got the "TV-14" rating in Canada?

# In[101]:


data.head(1)


# In[105]:


data[(data['Rating'] == 'TV-14') & (data['Country'] == 'Canada')]


# In[106]:


data[(data['Rating'] == 'TV-14') & (data['Country'] == 'Canada')]['Rating'].count()


# In[ ]:





# ### Q9.2. How many TV Shows got the 'R' rating, after the year 2018?

# In[108]:


data.head(1)


# In[114]:


data[(data['Category'] == 'TV Show') & (data['Rating'] == 'R') & (data['Year'] > 2018)]['Show_Id'].count()


# 

# ### Q10. What is the maximum duration of a Movie on Netflix?

# In[116]:


data.head(2)


# In[117]:


data['Duration'].unique()


# In[118]:


data['Duration'].dtypes


# In[134]:


data[['Minutes', 'Unit']] = data['Duration'].str.split(' ', expand = True)


# In[139]:


data.head(2)


# In[140]:


data['Minutes'] = data['Minutes'].astype(int) 


# In[141]:


data['Minutes'].max()


# In[ ]:





# ### Q11. Which individual country has the highest number of TV Shows?

# In[143]:


data.head(1)


# In[145]:


data_tvshow = data[data['Category'] == 'TV Show']


# In[147]:


data_tvshow.head(2)


# In[150]:


data_tvshow['Country'].value_counts().head(1)


# 

# ### Q12. How can we sort the dataset by Year?

# In[151]:


data.head(2)


# In[154]:


data.sort_values(by = 'Year').head()


# In[155]:


data.sort_values(by = 'Year', ascending = False).head()


# 

# ### Q13. Find All the instances where: 
# 
# ### Category is "Movies" and Type is "Dramas"
# 
# ####          or
# 
# ### Category is "TV Show" and Type is "Kids TV"

# In[156]:


data.head(2)


# In[165]:


data[((data['Category'] == 'Movie') & (data['Type'] == 'Dramas')) | ((data['Category'] == 'TV Show') & (data['Type'] == "Kids' TV"))]


# In[6]:


import matplotlib.pyplot as plt


# In[7]:


country_counts = data['Country'].value_counts().head(10)
country_counts.plot(kind='bar')
plt.xlabel('Country')
plt.ylabel('Number of Titles')
plt.title('Top 10 Countries in Netflix Content')
plt.show()


# In[ ]:





# In[ ]:





# 
