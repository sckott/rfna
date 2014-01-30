#' Get taxa names from a single web page, or multiple pages, on FNA.
#' 
#' @import XML doMC plyr stringr
#' @param scource Source flora
#' @param rank One of 'family', 'genera', or 'species'
#' @param family A taxonomic family
#' @param genus A taxonomic genus
#' @return Taxa names in a vector or data.frame
#' @export
#' @examples \dontrun{
#' gettaxanames(source="fna")
#' 
#' # using Jepson Manual
#' gettaxanames(source="jepson")
#' }
gettaxanames <- function(source = NULL, rank="family")
{
  # Flora of North America
  families <- 'http://www.efloras.org/browse.aspx?flora_id=1'
  pg1 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
  pg2 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=2'
  pg3 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=3'
  fnafun <- function(x) {
    doc <- readHTMLTable(x)
    dd <- doc[[7]]
    df <- dd[-c(1:2, length(dd[,1])-1, length(dd[,1])),1:2]
    names(df) <- c('TaxonID','Name')
    as.character(df$Name)
  }
  
  # Flora of Chile
  pg1 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
  pg2 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=2'
  pg3 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=3'
  fnafun <- function(x) {
    doc <- readHTMLTable(x)
    dd <- doc[[7]]
    df <- dd[-c(1:2, length(dd[,1])-1, length(dd[,1])),1:2]
    names(df) <- c('TaxonID','Name')
    as.character(df$Name)
  }
  
  # Jepson Manual
  jepsonurl <- "http://ucjeps.berkeley.edu/IJM_toc.html"
  jepsfun <- function(x){
    doc <- readHTMLTable(x)
    dd <- doc[[4]]
    foo <- function(x){ 
      bb = data.frame(section = x["Section"], family = x["Family"])
      cc = x["Genera"]
      ccc <- str_trim(strsplit(as.character(cc), ",")[[1]], "both")
      cbind(bb, ccc)
    }
    df <- do.call(rbind, apply(dd, 1, foo))
    row.names(df) <- NULL
    df
  }
  
  switch(source,
         fna=do.call(c, lapply(list(pg1, pg2, pg3), fnafun)),
         jepson=jepsfun(jepsonurl))
}