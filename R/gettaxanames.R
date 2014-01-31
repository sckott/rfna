#' Get taxa names from a single web page, or multiple pages, on FNA.
#' 
#' @import XML plyr stringr
#' @param from Source flora, one of 'fna', 'chilie', or 'jepson'
#' @return Taxa names in a vector or data.frame
#' @export
#' @examples \dontrun{
#' get_families("fna")
#' 
#' # using Jepson Manual
#' get_families("jepson")
#' }
get_families <- function(from = NULL)
{
  # Flora of North America
  fna_families <- 'http://www.efloras.org/browse.aspx?flora_id=1'
#   fna_genera1 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
#   fna_genera2 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=2'
#   fna_genera3 <- 'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=3'
  fnafun <- function(x) {
    doc <- readHTMLTable(x)
    dd <- doc[[7]]
    df <- dd[-c(1:2, length(dd[,1])-1, length(dd[,1])),1:2]
    names(df) <- c('TaxonID','Name')
    as.character(df$Name)
  }
  
  # Flora of Chile
  chile_families <- 'http://efloras.org/browse.aspx?flora_id=60'
#   chile_genera <- 'http://efloras.org/browse.aspx?flora_id=60'
  chilefun <- function(x) {
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
  
  switch(from,
         fna=fnafun(fna_families),
         chile=chilefun(chile_families),
         jepson=jepsfun(jepsonurl))
}