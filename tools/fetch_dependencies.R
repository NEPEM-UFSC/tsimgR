download_dependency <- function(url, filename, dest_dir) {
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  dest_file <- file.path(dest_dir, filename)
  
  # Verificar se arquivo já existe
  if (file.exists(dest_file)) {
    message(sprintf("Using cached %s", filename))
    return(TRUE)
  }
  
  tryCatch({
    download.file(url, dest_file, mode = "wb")
    message(sprintf("Downloaded %s successfully", filename))
    return(TRUE)
  }, error = function(e) {
    warning(sprintf("Failed to download %s: %s", filename, e$message))
    return(FALSE)
  })
}

# Criar diretórios
include_dir <- "inst/include"
stb_dir <- file.path(include_dir, "stb")
gif_dir <- file.path(include_dir, "gif")

dir.create(stb_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(gif_dir, recursive = TRUE, showWarnings = FALSE)

# URLs das dependências
deps <- list(
  list(
    url = "https://raw.githubusercontent.com/nothings/stb/master/stb_image.h",
    filename = "stb_image.h",
    dir = stb_dir
  ),
  list(
    url = "https://raw.githubusercontent.com/nothings/stb/master/stb_image_write.h",
    filename = "stb_image_write.h",
    dir = stb_dir
  ),
  list(
    url = "https://raw.githubusercontent.com/nothings/stb/master/stb_image_resize2.h",
    filename = "stb_image_resize2.h",
    dir = stb_dir
  ),
  list(
    url = "https://raw.githubusercontent.com/charlietangora/gif-h/master/gif.h",
    filename = "gif.h",
    dir = gif_dir
  )
)

# Baixar apenas se necessário
results <- sapply(deps, function(dep) {
  download_dependency(dep$url, dep$filename, dep$dir)
})

if (!all(results)) {
  stop("Failed to download all dependencies")
}
