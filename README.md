rfna
====

[![Build Status](https://travis-ci.org/ropensci/floras.svg?branch=master)](https://travis-ci.org/ropensci/floras) [![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)


This set of functions scrapes web content, and allows searches of the content, on the eFloras website, including Flora of North America, etc.

The website: <http://www.efloras.org>

## Installation

Install `rfna`


```r
devtools::install_github("ropensci/rfna")
```


```r
library('rfna')
```

## Usage

Get families


```r
res <- get_families("fna")
res$names[1:10]
```

```
##  [1] "Achatocarpaceae"  "Acoraceae"        "Agavaceae"       
##  [4] "Aizoaceae"        "Alismataceae"     "Aloaceae"        
##  [7] "Amaranthaceae"    "Amblystegiaceae"  "Andreaeaceae"    
## [10] "Andreaeobryaceae"
```

Get genera


```r
res <- get_genera(from='fna', family='Asteraceae')
res$names[1:10]
```

```
##  [1] "Asteraceae"     "Acamptopappus"  "Acanthospermum" "Achillea"      
##  [5] "Achyrachaena"   "Acmella"        "Acourtia"       "Acroptilon"    
##  [9] "Adenocaulon"    "Adenophyllum"
```

Parse a page


```r
pg1<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
head(parse_page(pg1))
```

```
##             name     id
## 1     Asteraceae  10074
## 2  Acamptopappus 100070
## 3 Acanthospermum 100132
## 4       Achillea 100191
## 5   Achyrachaena 100226
## 6        Acmella 100279
##                                                                 url
## 1  http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=10074
## 2 http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=100070
## 3 http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=100132
## 4 http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=100191
## 5 http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=100226
## 6 http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=100279
```

Get state (paleate or epaleate) of receptacle.


```r
url <- 'http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=102552'
receptacle(url)
```

```
## [1] "Argyranthemum" "epaleate"      "epaleate"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rfna/issues).
* License: MIT
* This package is part of the [rOpenSci](https://ropensci.org/packages) project.
* Get citation information for `rfna` in R doing `citation(package = 'rfna')`

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
