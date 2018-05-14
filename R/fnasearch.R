#' Search web pages for terms.
#'
#' @export
#' @import stringr plyr
#' @param url The URL of the page.
#' @param terms Terms to search for (if >1, supply in a list).
#' @return Search results.
#' @examples \dontrun{
#' url <- 'http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=102552'
#' fnasearch(url, terms='Receptacle')
#' }
fnasearch <- function(url, terms = list())
{
  out <- suppressWarnings(readHTMLTable(url))
  line_number <- grepl(terms, out[[1]][[1]])
  out[[1]][[1]][line_number]
}
