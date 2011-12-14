require(RCurl); require(XML); require(stringr); require(plyr)
setwd('F:/Scott_Nov2011_onPCatLab/Chaff_R_scraping')

#####  Get URLs for Asteraceae genera
# url <- 'http://ucjeps.berkeley.edu/cgi-bin/get_IJM.pl?tid=290'
jephomeurl <- 'http://ucjeps.berkeley.edu/IJM.html'

jephome_table <- readHTMLTable(jephomeurl) # dataframes
composit_genera <- jephome_table[[5]][38,3] # vector
cgenvec <- strsplit(as.character(composit_genera, ','), ",")[[1]]# split into genera
cgenvec2 <- str_trim(cgenvec, 'both')

jephomeout <- getURL(jephomeurl)
# gsub("Acamptopappus", "\\1", jephomeout)
# str_extract(jephomeout, "\\b Acamptopappus")

str_extract_all(jephomeout, "/(cgi-bin)/(get_IJM.pl\\?tid=)[0-9]{3}") # get's all URLs

# str_extract(test, paste("/(cgi-bin)/(get_IJM.pl\\?tid=)[0-9]{3}",  cgenvec2[[1]], sep=''))



#####  Floral of North America Asteraceae 
FNAAsteraceaeIndexurl_pg1 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
FNAAsteraceaeIndexurl_pg2 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=2'
FNAAsteraceaeIndexurl_pg3 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=3'
FNAindexout_pg1 <- getURL(FNAAsteraceaeIndexurl_pg1)
FNAindexout_pg2 <- getURL(FNAAsteraceaeIndexurl_pg2)
FNAindexout_pg3 <- getURL(FNAAsteraceaeIndexurl_pg3)
# df1 <- str_extract_all(FNAindexout_pg1, "(florataxon\\.aspx\\?flora_id=1&taxon_id=)[0-9]{6}")
# df2 <- str_extract_all(FNAindexout_pg2, "(florataxon\\.aspx\\?flora_id=1&taxon_id=)[0-9]{6}")
# df3 <- str_extract_all(FNAindexout_pg3, "(florataxon\\.aspx\\?flora_id=1&taxon_id=)[0-9]{6}")
dfall <- str_extract_all(paste(FNAindexout_pg1, FNAindexout_pg2, FNAindexout_pg3, sep=''),
      "(florataxon\\.aspx\\?flora_id=1&taxon_id=)[0-9]{6}")
# FNAdf_ofurls <- c(df1, df2, df3)
baseurl <- 'http://www.efloras.org/'
FNAdf_ofurls2 <- llply(dfall, function(x) paste(baseurl, x, sep=''))


##### Get taxa names
namespg1 <- readHTMLTable(FNAAsteraceaeIndexurl_pg1)
namespg2 <- readHTMLTable(FNAAsteraceaeIndexurl_pg2)
namespg3 <- readHTMLTable(FNAAsteraceaeIndexurl_pg3)

dfpg1 <- namespg1[[7]][-c(1:2,length(namespg1[[7]][,1])-1,length(namespg1[[7]][,1]), 44:57),1:2]
dfpg2 <- namespg2[[7]][-c(1:2,length(namespg2[[7]][,1])-1,length(namespg2[[7]][,1])),1:2]
dfpg3 <- namespg3[[7]][-c(1:2,length(namespg3[[7]][,1])-1,length(namespg3[[7]][,1])),1:2]
df_allpgs <- rbind(dfpg1, dfpg2, dfpg3)
names(df_allpgs) <- c('TaxonID','Name')
  

#####  For each individual page
#' Search individual page of FNA, by specifying the URL
#' Get the date when article was last updated by inputting the doi for the article.
#' @import RCurl stringr
#' @param page URL to search on
#' @param search regular expression search string (quoted)
#' @param url the PLoS API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass 
#'  the returned value in here (avoids unnecessary footprint)
#' @return Date when article data was last updated.
#' @export
#' @examples \dontrun{
#' url <- 'http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=100070'
#' searchonepg(url, )
#' }
searchonepg <- 
function (page, search
          ) {
#   url <- 'http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=100070'
  out <- readHTMLTable(page)
  line_number <- grep("Receptacles", out[[1]][[1]])
  text <- out[[1]][[1]][line_number]
  ## Assumes Ray florets is the thing that follows after Receptacles
  tt <- gsub(".* Receptacles (.*)\\. Ray florets .*", "\\1", text)
  str_extract(tt, "[e]?(paleate)")
}


#####  All pages of Floral of North America Asteraceae genera
getchaffdat <- function(x){
  out <- readHTMLTable(x)
  line_number <- grep("Receptacles", out[[1]][[1]])
  text <- out[[1]][[1]][line_number]
  temp <- gsub(".* Receptacles (.*)\\. Ray florets .*", "\\1", text)
  str_extract(temp, "[e]?(paleate)")
}

todatwithcheck <- function(x){
  if(length(as.data.frame(x)[,1]) == 0){data.frame("no data")} else 
    {as.data.frame(x)}
}

chaffdat <- llply(FNAdf_ofurls2[[1]], getchaffdat, .progress = "text")
# chaffdat2 <- llply(chaffdat, function(x) str_extract(x, "[e]?(paleate)"))
chaffdat_df <- ldply(chaffdat2, todatwithcheck)
alldat <- cbind(df_allpgs, chaffdat_df)
setwd('F:/Scott_Nov2011_onPCatLab/Chaff_R_scraping')
write.csv(alldat[,-4], 'chaffdat_FloraNorthAmer_Asteraceae_genus.csv', 
          row.names = F)



#####  All pages of Floral of North America Asteraceae species
FNAAsteraceaeIndexurl_pg1 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
FNAAsteraceaeIndexurl_pg2 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=2'
FNAAsteraceaeIndexurl_pg3 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=3'
FNAindexout_pg1 <- getURL(FNAAsteraceaeIndexurl_pg1)
FNAindexout_pg2 <- getURL(FNAAsteraceaeIndexurl_pg2)
FNAindexout_pg3 <- getURL(FNAAsteraceaeIndexurl_pg3)
dfallspp <- str_extract_all(paste(FNAindexout_pg1, FNAindexout_pg2, FNAindexout_pg3, sep=''),
      "(browse\\.aspx\\?flora_id=1&start_taxon_id=)[0-9]{6}")
baseurl <- 'http://www.efloras.org/'
dfallspp2 <- llply(dfallspp, function(x) paste(baseurl, x, sep=''))

funky <- function(x){
  temp <- getURL(x)
  tempurls <- str_extract_all(temp, 
    "(florataxon\\.aspx\\?flora_id=1&taxon_id=)[0-9]{9}")[[1]]
  baseurl <- 'http://www.efloras.org/'
  laply(tempurls, function(x) paste(baseurl, x, sep=''))
}
# funky(dfallspp2[[1]][1])

dfallspp2_html <- llply(dfallspp2[[1]], funky, .progress = 'text')

funky2 <- function(x){
  out <- readHTMLTable(x)
  line_number <- grep("Paleae", out[[1]][[1]], value=F)
  if(any(line_number) == FALSE) {"no palea info provided"} else 
    {
      text <- out[[1]][[1]][line_number]
      str_extract(text, "Paleae (.*)\\.  ")
    }
}

bysppdata <- llply(dfallspp2_html, function(x) llply(x, funky2), .progress = 'text')
bysppdata2 <- ldply(bysppdata, function(x) ldply(x, identity), .progress = 'text')

names <- llply(dfallspp2[[1]], readHTMLTable, .progress = 'text')
nameslist <- ldply(names, function(x) x[[7]][-c(1:2),-c(3:5)], .progress = 'text')
# namesdf <- cbind(nameslist, bysppdata)
# names(namesdf) <- c('TaxonID','Name','')

write.csv(bysppdata2, "bysppdata2.csv")         
write.csv(nameslist, "nameslist.csv")