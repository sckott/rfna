#' Get generic names for a family.
#'
#' @export
#' @import XML plyr stringr
#' @param from Source flora, one of 'fna', 'chile', 'china', 'china_moss', 'nepal',
#' 'missouri', 'ecuador', or 'jepson'
#' @param family A plant family name.
#' @param fuzzy If TRUE, does fuzzy search using \code{\link{agrep}}. If FALSE, uses
#' \code{\link{grep}}.
#' @param ... Further args passed on to \code{\link{agrep}} or \code{\link{grep}}
#' @return Taxa names in a vector or data.frame
#' @examples \dontrun{
#' out <- get_genera(from='fna', family='Asteraceae')
#' out$names
#' head(out$urls)
#'
#' # Search for trait data
#' receptacle(out$urls$url[3])
#' }
get_genera <- function(from = NULL, family = NULL, fuzzy = FALSE, ...)
{
  out <- get_families(from=from)
  if(fuzzy){
    fam <- agrep(family, out$names, ...)
    if(length(fam) > 1){
      # user prompt
      matches <- agrep(family, out$names, value=TRUE, ...)
      matchesdf <- data.frame(matches)

      # prompt
      message("\n\n")
      print(matchesdf)
      message("\nMore than one match was found for taxon '", family, "'!\n
            Enter rownumber of taxon (other inputs will return 'NA'):\n") # prompt
      take <- scan(n = 1, quiet = TRUE, what = 'raw')

      if(length(take) == 0)
        stop("Please select one taxon, or change your search string")
      if(take %in% seq_len(nrow(matchesdf))){
        take <- as.numeric(take)
        fam <- as.character(matchesdf$matches[take])
        message("Input accepted, took taxon '", as.character(matchesdf$matches[take]), "'.\n")
      } else {
        stop("No match found")
      }
    }
  } else {
    fam <- grep(family, out$names, value=TRUE, ...)
    if(identical(fam, character(0)))
      stop("No match found")
  }

  urlget <- out$urls[ out$urls$name %in% fam, "url" ]
  urlget <- sub("taxon_id", "start_taxon_id", urlget)
  urlget <- sub("florataxon", "browse", urlget)

  page <- htmlParse(urlget)
  id <- strsplit(str_extract(urlget, "flora_id=[0-9]+"), "=")[[1]][[2]]
  id2 <- strsplit(str_extract(urlget, "start_taxon_id=[0-9]+"), "=")[[1]][[2]]
  pages <- xpathApply(page, sprintf("//a[contains(@href, 'browse.aspx?flora_id=%s&start_taxon_id=%s&page=')]", id, id2))
  if(!length(pages)==0){
    nums <- c(1,as.numeric(unique(str_trim(sapply(pages, xmlValue), "both"))))
    urlget <- paste(urlget, "&page=", nums, sep="")
  }

  foo <- function(x){
    if(length(x)>1){ tmp <- ldply(x, parse_page)  } else { tmp <- parse_page(x) }
    res <- list(names = tmp$name, urls = tmp)
    class(res) <- 'florts'
    attr(res, "rank") <- "genus"
    res
  }

  foo(urlget)
}
