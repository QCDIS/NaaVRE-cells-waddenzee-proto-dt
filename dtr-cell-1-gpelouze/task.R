setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("git2r", quietly = TRUE)) {
	install.packages("git2r", repos="http://cran.us.r-project.org")
}
library(git2r)

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

install.packages("git2r")

require(git2r)

conf_git_repo_url = "https://github.com/LTER-LIFE/dtR"
conf_git_clone_dir = "/tmp/data/dtR"

git2r::clone(
    conf_git_repo_url,
    local_path=conf_git_clone_dir,
    credentials=git2r::cred_user_pass(username=param_gh_user, password=secret_gh_token))

install.packages(paste0(conf_git_clone_dir, "/dtLife"), repos=NULL, type="source", depend=TRUE)
install.packages(paste0(conf_git_clone_dir, "/dtWad"), repos=NULL, type="source", depend=TRUE)
install.packages(paste0(conf_git_clone_dir, "/dtPP"), repos=NULL, type="source", depend=TRUE)

require(dtLife)
require(dtWad)
require(dtPP)

stations = Wad_biogeo_RWS$station
# capturing outputs
print('Serialization of stations')
file <- file(paste0('/tmp/stations_', id, '.json'))
writeLines(toJSON(stations, auto_unbox=TRUE), file)
close(file)
