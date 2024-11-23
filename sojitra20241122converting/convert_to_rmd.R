# USAGE: `Rscript convert_to_rmd.R  --ipynb_fpath="test/example.ipynb"`
# Output files will be saved to the same directory as the the ipynb.

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("rmarkdown"))
suppressPackageStartupMessages(library("knitr"))


parser <- ArgumentParser()
parser$add_argument(
    "-ipynb_fpath", "--ipynb_fpath", type="character",
    help="Python notebook to convert"
)
args <- parser$parse_args()

convert_ipynb_to_r <- function(input, output = xfun::with_ext(input, "R"),
                               keep_rmd = FALSE, ...) {
        ## Check if file extension is matches Jupyter notebook.
        if (tolower(xfun::file_ext(input)) != "ipynb") {
            return( "Error: Invalid file format" )
        }

        ## Conversion process: 
        ## .ipynb to .Rmd
        rmarkdown::convert_ipynb(input)
        ## .Rmd to .R
        knitr::purl(xfun::with_ext(input, "Rmd"), output = output)

        ## Keep or remove intermediary .Rmd
        if (keep_rmd == FALSE) {
            file.remove(xfun::with_ext(input, "Rmd"))
       }
}

if( file.access(args$ipynb_fpath) == -1) {
    stop(sprintf("Specified file ( %s ) does not exist", file))
} else {
    convert_ipynb_to_r(args$ipynb_fpath, keep_rmd=TRUE)
}
