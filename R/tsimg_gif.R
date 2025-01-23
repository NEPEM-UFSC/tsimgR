#' Create a GIF from a sequence of images or plots
#'
#' @param image_paths Optional. Character vector of image file paths
#' @param debug Logical. If TRUE, prints debug information
#' @param plot_df Optional. Dataframe containing plot objects
#' @param width Optional. Width in pixels for plot_df images. Default: 800
#' @param height Optional. Height in pixels for plot_df images. Default: 600
#' @param frame_delay Optional. Delay between frames in milliseconds. Default: 100
#' @param reverse Logical. If TRUE, reverses the sequence. Default: FALSE
#' @return A raw vector representing the GIF data
#' @examples
#' data(volcano)
#' plots <- lapply(c(30, 60, 90), function(angle) {
#'   persp(volcano, 
#'         theta = angle,
#'         phi = 30,
#'         col = "lightblue",
#'         shade = 0.5,
#'         main = paste("Rotação:", angle, "graus"))
#' })
#'
#' gif_data <- createGif(
#'   plot_df = data.frame(plot = I(plots)),
#'   width = 480,
#'   height = 480,
#'   frame_delay = 150
#' )
#' 
#' 
#' \dontrun{
#'   displayGif(gif_data)
#' }
#' @export
createGif <- function(image_paths = NULL, debug = FALSE, plot_df = NULL, 
                     width = 800, height = 600, frame_delay = 100, reverse = FALSE) {
    if (is.null(image_paths) && is.null(plot_df)) {
        stop("Either 'image_paths' or 'plot_df' must be provided")
    }
    
    if (!is.null(plot_df)) {
        temp_files <- sapply(1:nrow(plot_df), function(i) {
            temp_filepath <- tempfile(pattern = paste0("plot_", i, "_"), fileext = ".jpg")
            jpeg(filename = temp_filepath, width = width, height = height, units = "px")
            plot(plot_df[[i, 1]])
            dev.off()
            temp_filepath
        })
        image_paths <- c(temp_files, image_paths)
    }
    
    gif_data <- tsimg_gif_rcpp(image_paths, frame_delay, debug, reverse)
    return(gif_data)
}

#' Save GIF data to file
#'
#' @param gif_data Raw vector of GIF data
#' @param file_path Output file path
#' @return Invisible NULL
#' @examples
#' # Criar um GIF de exemplo com plots
#' data(volcano)
#' plots <- lapply(c(30, 60, 90), function(angle) {
#'   persp(volcano, theta = angle, phi = 30,
#'         col = "lightblue", shade = 0.5)
#' })
#' gif_data <- createGif(plot_df = data.frame(plot = I(plots)))
#' 
#' \dontrun{
#'   # Salvar o GIF em arquivo
#'   saveGif(gif_data, "volcano_rotation.gif")
#' }
#' @export
saveGif <- function(gif_data, file_path) {
    writeBin(gif_data, file_path)
    invisible(NULL)
}

#' Display a GIF using system default viewer
#'
#' @param gif_data Raw vector of GIF data or path to a GIF file
#' @param viewer Character. Display method: "default", "browser", "tempfile". Default: "default"
#' @param cleanup Logical. Remove temporary file after viewing. Default: TRUE
#' @return Invisible list with file path and content type
#' @examples
#' data(volcano)
#' plots <- lapply(c(0, 45, 90, 135), function(angle) {
#'   persp(volcano, theta = angle, phi = 30,
#'         col = "lightblue", shade = 0.5)
#' })
#' gif_data <- createGif(plot_df = data.frame(plot = I(plots)))
#' 
#' \dontrun{
#'   displayGif(gif_data)
#'   
#'   displayGif(gif_data, viewer = "browser")
#'   
#'   saveGif(gif_data, "volcano.gif")
#'   displayGif("volcano.gif")
#' }
#' @export
displayGif <- function(gif_data, viewer = "default", cleanup = TRUE) {
    view_gif_file <- function(filepath, viewer_type = viewer) {
        result <- tryCatch({
            switch(viewer_type,
                "browser" = {
                    utils::browseURL(filepath)
                    Sys.sleep(1)
                },
                "tempfile" = {
                    return(filepath)
                },
                "default" = {
                    switch(.Platform$OS.type,
                        "windows" = {
                            shell.exec(filepath)
                            Sys.sleep(1)
                        },
                        "unix" = {
                            os <- tolower(Sys.info()["sysname"])
                            if (os == "darwin") {
                                system2("open", filepath, stderr = FALSE, stdout = FALSE)
                            } else if (os == "linux") {
                                viewers <- c("xdg-open", "gthumb", "eog", "display")
                                viewer_found <- FALSE
                                for (v in viewers) {
                                    if (nzchar(Sys.which(v))) {
                                        system2(v, filepath, stderr = FALSE, stdout = FALSE)
                                        viewer_found <- TRUE
                                        break
                                    }
                                }
                                if (!viewer_found) {
                                    utils::browseURL(filepath)
                                }
                            }
                            Sys.sleep(1)
                        }
                    )
                }
            )
            filepath
        }, error = function(e) {
            warning("Error displaying GIF: ", e$message, "/nFalling back to browser")
            utils::browseURL(filepath)
            Sys.sleep(1)
            filepath
        })
        
        return(result)
    }
    
    if (is.raw(gif_data)) {
        temp_dir <- tempdir()
        if (!dir.exists(temp_dir)) {
            dir.create(temp_dir, recursive = TRUE)
        }
        
        temp_filepath <- tempfile(pattern = "tsimgR_", fileext = ".gif", tmpdir = temp_dir)
        writeBin(gif_data, temp_filepath)
        if (!file.exists(temp_filepath)) {
            stop("Failed to create temporary file")
        }
        
        result_path <- view_gif_file(temp_filepath)
        
    } else if (is.character(gif_data) && length(gif_data) == 1) {
        if (!file.exists(gif_data)) {
            stop("File does not exist: ", gif_data)
        }
        
        if (!grepl("//.gif$", tolower(gif_data), ignore.case = TRUE)) {
            stop("File does not appear to be a GIF: ", gif_data)
        }
        
        con <- file(gif_data, "rb")
        header <- rawToChar(readBin(con, "raw", 6))
        close(con)
        
        if (!grepl("^GIF8[79]a", header)) {
            stop("File is not a valid GIF: ", gif_data)
        }
        
        result_path <- view_gif_file(gif_data)
        temp_filepath <- NULL
        
    } else {
        stop("Input must be either a raw vector or a path to a GIF file")
    }
    
    # Create result object with cleanup function
    result <- list(
        src = result_path,
        contentType = "image/gif",
        cleanup = cleanup,
        remove = function() {
            if (!is.null(temp_filepath) && file.exists(temp_filepath)) {
                unlink(temp_filepath)
            }
        }
    )
    
    if (cleanup && !is.null(temp_filepath)) {
        reg.finalizer(environment(), function(e) {
            if (file.exists(temp_filepath)) {
                unlink(temp_filepath)
            }
        })
    }
    
    invisible(result)
}