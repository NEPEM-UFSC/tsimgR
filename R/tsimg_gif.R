#' Create a GIF from a sequence of images or plots
#'
#' This function generates a GIF from a sequence of image files or plot objects.
#'
#' @param image_paths Optional. A character vector containing the file paths of the images to include in the GIF. If not provided, `plot_df` must be supplied.
#' @param debug Logical. If TRUE, prints debug information during the GIF creation process. Default is FALSE.
#' @param plot_df Optional. A dataframe containing plot objects to be included in the GIF. Each row should contain a plot object. If not provided, `image_paths` must be supplied.
#' @param width Optional. The width of the output image in pixels if `plot_df` is provided. Default is 800.
#' @param height Optional. The height of the output image in pixels if `plot_df` is provided. Default is 600.
#' @return A raw vector representing the GIF data.
#' @examples
#' # Create a GIF from a sequence of image files
#' createGif(c("image1.png", "image2.png"))
#'
#' # Create a GIF from a dataframe of plots
#' library(ggplot2)
#' plot_df <- data.frame(plot = I(list(
#'   ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point(),
#'   ggplot(mtcars, aes(x = hp, y = mpg)) + geom_point()
#' )))
#' createGif(plot_df = plot_df)
#' @export
createGif <- function(image_paths = NULL, debug = FALSE, plot_df = NULL, width = 800, height = 600) {
  if (is.null(image_paths) && is.null(plot_df)) {
    stop("Either 'image_paths' or 'plot_df' must be provided.")
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
  
  gif_data <- .Call('_tsimgR_tsimg_gif_rcpp', image_paths, debug)
  return(gif_data)
}

#' Save the raw vector into a proper .gif file
#'
#' @param gif_data A raw vector representing the GIF data.
#' @param file_path The file path where the GIF should be saved with its name
#' @return NULL
#' @examples
#' # saveGif(gif_data, "output.gif")
#' @export
saveGif <- function(gif_data, file_path) {
  writeBin(gif_data, file_path)
}


#' Display a GIF
#'
#' This function takes a raw vector representing GIF data, writes it to a temporary file,
#' and returns a list containing the path to the temporary GIF file and the content type.
#'
#' @param gif_data A raw vector representing the GIF data. This should be the binary content of a GIF image.
#' @return A list containing:
#' \describe{
#'   \item{src}{A character string representing the path to the temporary GIF file.}
#'   \item{contentType}{A character string representing the content type, which is "image/gif".}
#' }
#' @examples
#' # Example usage:
#' # Assuming `gif_binary_data` is a raw vector containing GIF data
#' # result <- displayGif(gif_binary_data)
#' # print(result$src)
#' @export
#TODO - Implement this function
displayGif <- function(gif_data) {
  temp_filepath <- tempfile(fileext = ".gif")
  writeBin(gif_data, temp_filepath)
  list(src = temp_filepath, contentType = "image/gif")
}