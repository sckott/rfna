#' Get URLs to daughter pages from a single web page, or multiple pages, on FNA.
#'
#' @export
#' @import XML plyr RCurl stringr
#' @param url The URL of the page
#' @param from one of fna or jepson
#' @param cores Use parallel processing in plyr functions (default to FALSE).
#' @param no_cores Number of cores to use in the parallel plyr work.
#' @return Taxa names and taxon IDs in a data.frame.
#' @details If you use parallelization with argument cores=TRUE, make sure to
#'    install doMC first.
#' @examples \dontrun{
#' pg1<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
#' pg2<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=2'
#' pg3<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=3'
#' parse_page(pg1)
#' parse_page(list(pg1, pg2, pg3))
#' }
parse_page <- function(url, from='fna', cores, no_cores)
{
  id <- strsplit(str_extract(url, "flora_id=[0-9]+"), "=")[[1]][[2]]
  get_fna <- function(x, id) {
    page <- htmlParse(x)
    dat <- lapply(xpathApply(page, sprintf('//a[contains(@href,"florataxon.aspx?flora_id=%s&")]', id)),
                  function(y){
                    tt <- strsplit(xmlGetAttr(y, "href"), "=")[[1]]
                    data.frame(strsplit(xmlValue(y), ",")[[1]][[1]],
                         tt[length(tt)],
                         sprintf("http://www.efloras.org/%s", xmlGetAttr(y, "href")),
                         stringsAsFactors=FALSE)
                    })
    df <- do.call(rbind.fill, dat)
    names(df) <- c("name","id","url")
    df
  }

#   jepsonurl <- "http://ucjeps.berkeley.edu/IJM_toc.html"
#   get_jepson <- function(x){
#     page <- htmlParse(x)
#     dat <-
#       lapply(
#         xpathApply(page, '//a[contains(@href,"cgi-bin/get_IJM.pl?tid=")]')
#         ,
#                   function(y){
#                     tt <- strsplit(xmlGetAttr(y, "href"), "=")[[1]]
#                     list(strsplit(xmlValue(y), ",")[[1]][[1]],
#                          tt[length(tt)],
#                          sprintf("http://www.efloras.org/%s", xmlGetAttr(y, "href")))
#                   })
#
#
#     doc <- readHTMLTable(x)
#     dd <- doc[[4]]
#     foo <- function(x){
#       bb = data.frame(section = x["Section"], family = x["Family"])
#       cc = x["Genera"]
#       ccc <- str_trim(strsplit(as.character(cc), ",")[[1]], "both")
#       cbind(bb, ccc)
#     }
#     df <- do.call(rbind, apply(dd, 1, foo))
#     row.names(df) <- NULL
#     df
#   }

  switch(from,
    jepson=get_jepson(jepsonurl),
    fna=get_fna(url, id)
  )
}
