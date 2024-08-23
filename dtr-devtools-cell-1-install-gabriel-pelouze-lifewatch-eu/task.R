setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)

secret_gh_token = Sys.getenv('secret_gh_token')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_gh_user"), action="store", default=NA, type="character", help="my description")
)


opt = parse_args(OptionParser(option_list=option_list))

var_serialization <- function(var){
    if (is.null(var)){
        print("Variable is null")
        exit(1)
    }
    tryCatch(
        {
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        error=function(e) {
            print("Error while deserializing the variable")
            print(var)
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        warning=function(w) {
            print("Warning while deserializing the variable")
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        }
    )
}

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving param_gh_user")
var = opt$param_gh_user
print(var)
var_len = length(var)
print(paste("Variable param_gh_user has length", var_len))

param_gh_user <- gsub("\"", "", opt$param_gh_user)


print("Running the cell")

devtools::install_github("LTER-LIFE/dtR/dtLife", auth_token=secret_gh_token, depend=TRUE, force=TRUE)
devtools::install_github("LTER-LIFE/dtR/dtWad", auth_token=secret_gh_token, depend=FALSE, force=TRUE)
devtools::install_github("LTER-LIFE/dtR/dtPP", auth_token=secret_gh_token, depend=FALSE, force=TRUE)

require(dtLife)
require(dtWad)
require(dtPP)

stations = Wad_biogeo_RWS$station
# capturing outputs
print('Serialization of stations')
file <- file(paste0('/tmp/stations_', id, '.json'))
writeLines(toJSON(stations, auto_unbox=TRUE), file)
close(file)
