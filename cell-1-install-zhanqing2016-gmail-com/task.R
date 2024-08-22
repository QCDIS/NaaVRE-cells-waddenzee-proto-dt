setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)

secret_github_auth_token = Sys.getenv('secret_github_auth_token')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description")
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


print("Running the cell")

devtools::install_github("LTER-LIFE/dtR/dtLife",depend=TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtWad", depend=FALSE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtPP", depend=FALSE, auth_token=secret_github_auth_token)

require(dtLife)
require(dtWad)
require(dtPP)



plot_RWSstations <- c("DANTZGT","DOOVBWT","MARSDND","VLIESM")
save(file="/tmp/data/Wad_biogeo_RWS.rda", Wad_biogeo_RWS)
Wad_biogeo_RWS_name <- "Wad_biogeo_RWS"
# capturing outputs
print('Serialization of plot_RWSstations')
file <- file(paste0('/tmp/plot_RWSstations_', id, '.json'))
writeLines(toJSON(plot_RWSstations, auto_unbox=TRUE), file)
close(file)
print('Serialization of Wad_biogeo_RWS_name')
file <- file(paste0('/tmp/Wad_biogeo_RWS_name_', id, '.json'))
writeLines(toJSON(Wad_biogeo_RWS_name, auto_unbox=TRUE), file)
close(file)
