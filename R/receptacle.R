#' Get state (paleate or epaleate) of receptacle.
#'
#' @export
#' @import stringr XML plyr RCurl
#' @param url The URL of the page you want to search.
#' @return paleate, epaleate, or 'not found'.
#' @examples \dontrun{
#' url <- 'http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=102552'
#' receptacle(url)
#' url <- 'http://www.efloras.org/florataxon.aspx?flora_id=1&taxon_id=250066099'
#' receptacle(url)
#' pg1<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
#' urls <- getdaughterURLs(pg1)
#' ldply(urls[1:5], receptacle, .progress='text')
#' }
receptacle <- function(url)
{
  out <- suppressWarnings(readHTMLTable(url))
  if(identical( grep("Receptacles", out[[1]][[1]]), integer(0)) == TRUE){
    result <- 'not found'} else
  {
    line_number <- grep("Receptacles", out[[1]][[1]])
    text <- out[[1]][[1]][line_number]
    temp <- gsub(".* Receptacles (.*)\\. Ray florets .*", "\\1", text)
    result <- str_extract(temp, "[e]?(paleate)")
  }
  all <- str_split(xmlToList(htmlTreeParse(getURL(url), asText=TRUE)$children$html)$head$title, " ")[[1]]
  name <- paste(all[!all %in% str_split(" in Flora of North America @ efloras.org", " ")[[1]] ], collapse=' ')
  c(name, result)
}
