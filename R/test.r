#' Run admbsecr tests
#'
#' Runs tests for admbsecr.
#'
#' This function was written to allow users to test their admbsecr
#' installation. Users cannot use the \link[testthat]{test_package}
#' function from the testthat package as the tests are not
#' installed. This is because tests fail on the R-forge servers due to
#' the AD model builder executable.
#'
#' @param quick Logical, if \code{TRUE}, only a quick check is carried
#' out that tests whether or not the AD Model Builder executable is
#' running correctly.
#'
#' @export
test.admbsecr <- function(quick = FALSE){
    dir <- ifelse(quick, "quick", "full")
    if (quick){
        simple.capt <- example$capt["bincapt"]
        fit <- try(admbsecr(capt = simple.capt, traps = example$traps,
                            mask = example$mask, fix = list(g0 = 1)),
                   silent = TRUE)
        if (class(fit)[1] == "try-error"){
            message("ADMB executable test: FAIL\n")
        } else {
            relative.error <- coef(fit, "D")/2267.7395 - 1
            if (abs(relative.error) < 1e-4){
                message("ADMB executable check: PASS\n")
            } else {
                message("ADMB executable check: INCONCLUSIVE\n Executable has run successfully but results may not be correct.\n")
            }
        }
    } else {
        dir <- paste(system.file(package = "admbsecr"), "tests", sep = "/")
        test_dir(dir)
    }
}

