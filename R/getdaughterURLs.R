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
getdaughterURLs <- function(url)
{
  doitt <- function(x) {
    page <- htmlParse(x)
    dat <- lapply(xpathApply(page, '//a[contains(@href,"florataxon.aspx?flora_id=1&")]'), 
                  function(y){ 
                    tt <- strsplit(xmlGetAttr(y, "href"), "=")[[1]]
                    list(strsplit(xmlValue(y), ",")[[1]][[1]], 
                         tt[length(tt)],
                         sprintf("http://www.efloras.org/%s", xmlGetAttr(y, "href")))
                    })
    df <- data.frame(do.call(rbind, dat), stringsAsFactors=FALSE)
    names(df) <- c("name","id","url")
    df
  }
  doitt(url)
}