#' Get URLs to daughter pages from a single web page, or multiple pages, on FNA.
#' @import XML doMC plyr RCurl stringr
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
#' getdaughterURLs(pg1)
#' getdaughterURLs(list(pg1, pg2, pg3))
#' getdaughterURLs(list(pg1, pg2, pg3), cores=TRUE, no_cores=2)
#' }
getdaughterURLs <-

function(url = list(), cores = FALSE, no_cores = NA, baseurl = 'http://www.efloras.org/')
{
  doitt <- function(x) {
    page <- getURL(x)
    t_ <- str_extract_all(page, "(florataxon\\.aspx\\?flora_id=1&taxon_id=)[0-9]{6}")
    t__ <- llply(t_, function(y) paste(baseurl, y, sep=''))
    t__
  }  
  if(cores == TRUE){  
    require(doMC)
    registerDoMC(no_cores)
    laply(url, doitt, .progress = 'text', .parallel = TRUE)[[1]][[1]]  
  } else
    { laply(url, doitt, .progress = 'text', .parallel = FALSE)[[1]][[1]] }
}