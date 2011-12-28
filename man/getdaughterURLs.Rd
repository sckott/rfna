\name{getdaughterURLs}
\alias{getdaughterURLs}
\title{Get URLs to daughter pages from a single web page, or multiple pages, on FNA.}
\usage{
  getdaughterURLs(url = list(), cores = FALSE,
    no_cores = NA, baseurl = "http://www.efloras.org/")
}
\arguments{
  \item{url}{The URL of the page.}

  \item{cores}{Use parallel processing in plyr functions
  (default to FALSE).}

  \item{no_cores}{Number of cores to use in the parallel
  plyr work.}
}
\value{
  Taxa names and taxon IDs in a data.frame.
}
\description{
  Get URLs to daughter pages from a single web page, or
  multiple pages, on FNA.
}
\details{
  If you use parallelization with argument cores=TRUE, make
  sure to install doMC first.
}
\examples{
\dontrun{
pg1<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=1'
pg2<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=2'
pg3<-'http://www.efloras.org/browse.aspx?flora_id=1&start_taxon_id=10074&page=3'
getdaughterURLs(pg1)
getdaughterURLs(list(pg1, pg2, pg3))
getdaughterURLs(list(pg1, pg2, pg3), cores=TRUE, no_cores=2)
}
}

