% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/markerEnrichment.R
\name{markerEnrichment}
\alias{markerEnrichment}
\title{Find enriched markers per identified cluster and calculate cluster abundances across these for samples and metadata variables.}
\usage{
markerEnrichment(
  indata,
  meta = NULL,
  assay = "scaled",
  sampleAbundances = TRUE,
  sampleID = "sample",
  studyvarID = NULL,
  clusterAssign = metadata(indata)[["Cluster"]],
  funcSummarise = function(x) mean(x, na.rm = TRUE),
  method = "Z",
  prob = 0.1,
  limits = c(-1.96, 1.96),
  verbose = TRUE
)
}
\arguments{
\item{indata}{A data-frame or matrix, or \code{SingleCellExperiment} object. If a
data-frame or matrix, this should relate to expression data (cells as
columns; genes as rows). If a \code{SingleCellExperiment} object, data will be
extracted from an assay component named by \code{assay}.}

\item{meta}{If 'indata' is a non-\code{SingleCellExperiment} object, \code{meta} must be
activated and relate to a data-frame of metadata that aligns with the columns
of \code{indata}, and that also contains a column name specified by \code{studyvarID}.}

\item{assay}{Name of the assay slot in \code{indata} from which data will be
taken, assuming \code{indata} is a \code{SingleCellExperiment} object.}

\item{sampleAbundances}{Logical, indicating whether or not to calculate
cluster abundances across study samples.}

\item{sampleID}{If \code{sampleAbundances == TRUE}, a column name from the
provided metadata representing over which sample cluster abundances
will be calculated.}

\item{studyvarID}{A column name from the provided metadata representing a
condition or trait over which cluster abundances will be calculated.}

\item{clusterAssign}{A vector of cell-to-cluster assignments. This can be
 from any source but must align with your cells / variables. There is no
 check to ensure this when 'indata' is not a \code{SingleCellExperiment}
object.}

\item{funcSummarise}{A mathematical function used to summarise expression
per marker per cluster.}

\item{method}{Type of summarisation to apply to the data for final marker
selection. Possible values include \code{Z} or \code{quantile}. If
\code{Z}, \code{limits} relate to lower and upper Z-score cut-offs for
low|high markers. The defaults of -1.96 and +1.96 are equivalents of
p<0.05 on a two-tailed distribution. If \code{quantile}, \code{prob}
will be used to define the \code{n}th lower and 1 - \code{n}th upper
quantiles, which will be used for selecting low|high markers.}

\item{prob}{See details for \code{method}.}

\item{limits}{See details for \code{method}.}

\item{verbose}{Boolean (TRUE / FALSE) to print messages to console or not.}
}
\value{
A \code{data.frame} object.
}
\description{
Find enriched markers per identified cluster and calculate cluster abundances across these for samples and metadata variables.
}
\details{
Find enriched markers per identified cluster and calculate cluster abundances across these for samples and metadata variables. \code{markerEnrichment} first collapses your input data's expression profiles from the level of cells to the level of clusters based on a mathematical function specified by \code{funcSummarise}. It then either selects, per cluster, low|high markers via quantiles, or transforms this collapsed data to global Z-scores and selects low|high markers based on Z-score cut-offs.
}
\examples{
# create random data that follows a negative binomial
mat <- jitter(matrix(
  MASS::rnegbin(rexp(1000, rate=.1), theta = 4.5),
  ncol = 20))
colnames(mat) <- paste0('CD', 1:ncol(mat))
rownames(mat) <- paste0('cell', 1:nrow(mat))

u <- umap::umap(mat)$layout
colnames(u) <- c('UMAP1','UMAP2')
rownames(u) <- rownames(mat)
clus <- clusKNN(u)

metadata <- data.frame(
  group = c(rep('PB1', 25), rep('PB2', 25)),
  row.names = rownames(u))

markerEnrichment(t(mat), meta = metadata,
  sampleAbundances = FALSE,
  studyvarID = 'group', clusterAssign = clus)

}
\author{
Kevin Blighe <kevin@clinicalbioinformatics.co.uk>
}
