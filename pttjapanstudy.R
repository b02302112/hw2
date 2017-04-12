rm(list=ls(all.names=TRUE))
library(XML)
library(RCurl)
library(httr)

urlPath <- "https://www.ptt.cc/bbs/JapanStudy/index1182.html"
temp    <- getURL(urlPath, encoding = "big5")
xmldoc  <- htmlParse(temp)
title   <- xpathSApply(xmldoc, "//div[@class=\"title\"]", xmlValue)
title   <- gsub("\n", "", title)
title   <- gsub("\t", "", title)
title   #共出現20個標題，但其中四個是已被刪除，手動刪除
emptyId1 <- which(title =="(本文已被刪除) [popopin]")
title   <- title[-emptyId1]
emptyId2 <- which(title =="(本文已被刪除) [soft17723]")
title   <- title[-emptyId2]
emptyId3 <- which(title =="(本文已被刪除) [Tapqou]")
title   <- title[-emptyId3]
emptyId4 <- which(title =="(已被askaleroux刪除) <lalaya123> 禁面議")
title   <- title[-emptyId4]
title 

path    <- xpathSApply(xmldoc, "//div[@class='title']/a//@href")
#被刪除的文章沒有path

author  <- xpathSApply(xmldoc, "//div[@class='author']", xmlValue)
author  #觀察出現“-”之空白作者，整理一下
empty   <- author == "-"
author  <- author[!empty]

date    <- xpathSApply(xmldoc, "//div[@class='date']", xmlValue)
date
date    <- date[-emptyId1]
date    <- date[-emptyId2]
date    <- date[-emptyId3]
date    <- date[-emptyId4]

response <- xpathSApply(xmldoc, "//div[@class='nrec']", xmlValue)
response
response <-response[-emptyId1]
response <-response[-emptyId2]
response <-response[-emptyId3]
response <-response[-emptyId4]

alldata <- data.frame(title, author, path, date, response)

write.table(alldata,"pttjapanstudy.csv") 

library(knitr)
data = read.table("pttjapanstudy.csv")
kable(data)
