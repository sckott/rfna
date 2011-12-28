#' Get taxa names from a single web page, or multiple pages, on FNA.
#' @import XML doMC plyr
#' @param url The URL of the page.
#' @param cores Use parallel processing in plyr functions (default to FALSE).
#' @param no_cores Number of cores to use in the parallel plyr work. 
#' @return Taxa names and taxon IDs in a data.frame.
#' @details If you use parallelization with argument cores=TRUE, make sure to 
#'    install doMC first.
#' @export
#' @examples \dontrun{
#' pg1<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
#' pg2<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=2'
#' pg3<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=3'
#' gettaxanames(pg1)
#' gettaxanames(list(pg1, pg2, pg3))
#' gettaxanames(list(pg1, pg2, pg3), cores=TRUE, no_cores=2)
#' }
gettaxanames <-

function(url = list(), cores = FALSE, no_cores = NA)
{
  doit <- function(x) {
    html_ <- readHTMLTable(x)
    df <- html_[[7]][-c(1:2,length(html_[[7]][,1])-1,length(html_[[7]][,1])),1:2]
    names(df) <- c('TaxonID','Name')
    df
  }
  if(cores == TRUE){  
    require(doMC)
    registerDoMC(no_cores)
    dflist <- laply(url, doit, .progress = 'text', .parallel = TRUE)  
  } else
    { dflist <- laply(url, doit, .progress = 'text', .parallel = FALSE) }
  ldply(dflist, identity)
}