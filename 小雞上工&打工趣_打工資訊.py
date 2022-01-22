# -*- coding: utf-8 -*-
"""
Created on Sat Jan  9 20:11:36 2021

@author: 010
"""

import requests
from bs4 import BeautifulSoup
import matplotlib.pyplot as plt_Worknow
import matplotlib.pyplot as plt_Chick

URL_worknow="https://worknowapp.com/regions/%E8%8B%97%E6%A0%97"
URL_chick="https://www.chickpt.com.tw/?area=Miaoli"
URL_yahoo="https://finance.yahoo.com/quote/2330.TW/sustainability?p=2330.TW&.tsrc=fin-srch&guccounter=1"
Request_worknow=requests.get(URL_worknow)
Request_chick=requests.get(URL_chick)
Request_yahoo=requests.get(URL_yahoo)
print(Request_yahoo)
Soup_worknow=BeautifulSoup(Request_worknow.text,"lxml")
Soup_chick=BeautifulSoup(Request_chick.text,"lxml")
#下為打工趣之程式碼

attr={"class":"wage"}
wage_tags=Soup_worknow.find_all("span",attrs=attr)
wages=[]
for tag in wage_tags:
    wage_str=tag.get_text().strip()
    index_wage=wage_str.find(",")
    if index_wage>=0:
        wage_str=wage_str.replace(',','')
        #刪除,字元，讓薪資正常顯示不跳格
    wages.append(int(wage_str))

jobItem_tags=Soup_worknow.find_all("a")
Jobs=[]
company=[]
count=0
for tag in jobItem_tags:
    jobItem_str=tag.get_text().strip()
    temp_bool=count%2
    if 36<count<75:    
       if temp_bool==1:Jobs.append(jobItem_str)
       if temp_bool==0:company.append(jobItem_str)
    count+=1

workNowList="worknowList.csv"
worknowlist=open(workNowList,"w",newline='',encoding='utf-8-sig')
#寫入檔案。
for i in range(len(wages)):
    worknowlist.write(str(Jobs[i])+","+str(company[i])+","+str(wages[i])+"\n")
worknowlist.close()

#下為小雞上工之程式碼

attr={"class":"salary"}
salary_tags=Soup_chick.find_all("span",attrs=attr)
salarys=[]
for tag in salary_tags:
    salary_str=tag.get_text().strip()
    index_salary=salary_str.find("$")
    if index_salary>=0:
        salary_str=salary_str[index_salary+1:index_salary+4]
    salarys.append(int(salary_str))

attr={"class":"job-info-title ellipsis-job-name ellipsis"}
jobTitle_tags=Soup_chick.find_all("h2",attrs=attr)
C_jobs=[]
for tag in jobTitle_tags:
    jobTitle_str=tag.get_text().strip()
    C_jobs.append(jobTitle_str)

attr={"class":"mobile-job-company ellipsis-mobile-job-company ellipsis display-control show-mobile"}
jobCompany_tags=Soup_chick.find_all("p",attrs=attr)
Companys=[]
for tag in jobCompany_tags:
    jobCompany_str=tag.get_text().strip()
    Companys.append(jobCompany_str)

chickList="chickList.csv"
Chicklist=open(chickList,"w",newline='',encoding='utf-8-sig')
#寫入檔案。
for i in range(len(salarys)):
    Chicklist.write(str(C_jobs[i])+","+str(Companys[i])+","+str(salarys[i])+"\n")
Chicklist.close()

workNowAVR=sum(wages)/len(wages)
chickAVR=sum(salarys)/len(salarys)
print("打工趣平均薪資為："+str((workNowAVR)))
print("小雞上工平均薪資為："+str(chickAVR))

bins = [155, 160, 165, 170, 175, 180, 185, 190, 195, 200, 210]
plt_Worknow.hist(wages, bins, histtype = "bar")
plt_Chick.hist(salarys, bins, histtype = "bar")
plt_Worknow.xlabel("Wage")
plt_Worknow.ylabel("Jobs")
plt_Chick.xlabel("Salary")
plt_Chick.ylabel("Jobs")