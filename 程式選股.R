# 主題: 一顆蘋果救台灣? 
# 畫出蘋果與台積電的K線圖以供分析使用
# 參考: https://www.quantmod.com/
#    

# -----------------------------------------------------
# Q1: 下載AAPL股價資料
# Ans:

library(quantmod)
getSymbols("AAPL")
#View(AAPL)
#getSymbols("2330.TW")
#TSMC<-get("2330.TW")
#chartSeries(TSMC, theme="white")

# -----------------------------------------------------
# Q2: 劃出AAPL最近90天的K線圖，需有K線(上漲:紅色，下跌:綠色，背景: 白色)與成交量，
# 而且須有SAR指標 (佔10分)
# Ans:
library(quantmod)
getSymbols("AAPL")
#View(AAPL)
#getSymbols("2330.TW")
#TSMC<-get("2330.TW")
#chartSeries(TSMC, theme="white")
AAPL <- getSymbols(Symbols = "AAPL", from = "2021-08-30", auto.assign = FALSE) # create a AAPL xts object in global environment
AAPLchar<-chartSeries(AAPL,theme="white",up.col='red',dn.col='green')
addSAR()

# -----------------------------------------------------
# Q3: 撰寫function(命名為getIDs)的程式碼，可讀取台灣的股價資料，
#         並將該資料轉換成xts，以供下一題使用
# Ans:
library(quantmod)
library(xts)
library(openxlsx)
getIDs<-function(stkID){
  sPath<-"C:/1101/"
  sFile<-paste(sPath,stkID,'.xlsx',sep = '')
  a<-read.xlsx(sFile,1,colNames = FALSE)
  dates<-as.Date(a$X1-2,origin='1900-01-01')
  PV<-a[,4:8]
  colnames(PV)<-c('Open','High',"Low","Close","Volume")
  TSMC<-as.xts(PV,order.by = dates)
  TSMCchar<-chartSeries(TSMC,subset = 'last 90',theme='white'
              ,up.col = 'red',dn.col = 'green')
  addSAR()
}
# -----------------------------------------------------
# Q4: 以getIDs讀取2330台積電的股價資料，可供下一題使用
#  
# Ans:
library(quantmod)
library(xts)
library(openxlsx)
getIDs<-function(stkID){
  sPath<-"C:/1101/"
  sFile<-paste(sPath,stkID,'.xlsx',sep = '')
  a<-read.xlsx(sFile,1,colNames = FALSE)
  dates<-as.Date(a$X1-2,origin='1900-01-01')
  PV<-a[,4:8]
  colnames(PV)<-c('Open','High',"Low","Close","Volume")
  TSMC<-as.xts(PV,order.by = dates)
  TSMCchar<-chartSeries(TSMC,subset = 'last 90',theme='white'
                        ,up.col = 'red',dn.col = 'green')
  addSAR()
}
# -----------------------------------------------------
# Q5: 劃出台積電的K線圖，需有K線(上漲:紅色，下跌:綠色，背景: 白色)與成交量，
# 而且須有SAR指標
# Ans:
library(quantmod)
library(xts)
library(openxlsx)
getIDs<-function(stkID){
  sPath<-"C:/1101/"
  sFile<-paste(sPath,stkID,'.xlsx',sep = '')
  a<-read.xlsx(sFile,1,colNames = FALSE)
  dates<-as.Date(a$X1-2,origin='1900-01-01')
  PV<-a[,4:8]
  colnames(PV)<-c('Open','High',"Low","Close","Volume")
  TSMC<-as.xts(PV,order.by = dates)
  TSMCchar<-chartSeries(TSMC,subset = 'last 90',theme='white'
                        ,up.col = 'red',dn.col = 'green')
  addSAR()
}

# -----------------------------------------------------
# Q6: 以K線型態選進場點，型態Hammer為例
# Ans:


#示範第一支以2330股票為範例，選擇Hammer型態，
#錘形圖形態出現在下降趨勢的底部，通常暗示後市可能出現（看漲）反轉。
library(candlesticks)
stk <- getIDs(2330)
CSPHammer(stk)

#示範第二支股票2233
stk <- getIDs(2233)
CSPHammer(stk)

#示範第三支股票2231
stk <- getIDs(2231)
CSPHammer(stk)

# -----------------------------------------------------
# Q7: 以技術指標選進場點，做技術回測，當20ma大於60ma時做多；當20ma小於60ma時做空
# Ans:


library(quantmod)
getSymbols("AAPL")
AAPL
chartSeries(AAPL["2021-01::2022-01"],theme="white",
            up.col = 'red',dn.col = 'green')

ma_20<-runMean(AAPL[,4],n=20)#20日均線   
ma_60<-runMean(AAPL[,4],n=60)#60日均線
addTA(ma_20,on=1,col="blue")#畫出20日均線  
addTA(ma_60,on=1,col="red")#畫出60日均線  

position<-Lag(ifelse(ma_20>ma_60, 1,0))
return<-ROC(Cl(AAPL))*position
return<-return['2021-01-01/2022-01-11']
return<-exp(cumsum(return))
plot(return)#最終畫出獲利