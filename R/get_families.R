#' Get taxa names from a single web page, or multiple pages, on FNA.
#' 
#' @import XML plyr stringr
#' @param from Source flora, one of 'fna', 'chile', 'china', 'china_moss', 'nepal', 
#' 'missouri', 'ecuador', or 'jepson'
#' @return Taxa names in a vector or data.frame
#' @export
#' @examples \dontrun{
#' get_families("fna")
#' get_families("chile")
#' get_families("china")
#' get_families("china_moss")
#' get_families("nepal")
#' get_families("missouri")
#' get_families("ecuador")
#' get_families("jepson")
#' }
get_families <- function(from = NULL)
{
  # Flora of North America
  fna_families <- 'http://www.efloras.org/browse.aspx?flora_id=1'
  chile_families <- 'http://efloras.org/browse.aspx?flora_id=60'
  china_flora_families_1 <- 'http://www.efloras.org/browse.aspx?flora_id=2&page=1'
  china_flora_families_2 <- 'http://www.efloras.org/browse.aspx?flora_id=2&page=2'
  china_moss_flora <- 'http://www.efloras.org/browse.aspx?flora_id=4'
  nepal_families_1 <- 'http://www.efloras.org/browse.aspx?flora_id=110&page=1'
  nepal_families_2 <- 'http://www.efloras.org/browse.aspx?flora_id=110&page=2'
  missouri_families <- 'http://www.efloras.org/browse.aspx?flora_id=11'
  ecuador_families <- 'http://www.efloras.org/browse.aspx?flora_id=201'
  
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

  foo <- function(x){
    if(length(x)>1){ tmp <- ldply(x, parse_page)  } else { tmp <- parse_page(x) }
    res <- list(names = tmp$name, urls = tmp)
    class(res) <- 'florts'
    res
  }
  
  switch(from,
         fna=foo(fna_families),
         chile=foo(chile_families),
         china_moss=foo(china_moss_flora),
         missouri=foo(missouri_families),
         ecuador=foo(ecuador_families),
         china=foo(list(china_families_1,china_families_2)),
         nepal=foo(list(nepal_families_1,nepal_families_2)),
         jepson=jepsfun(jepsonurl))
}

#' @method print florts
#' @export
#' @rdname get_families
print.florts <- function(x, ...){
  print(x$names)
}