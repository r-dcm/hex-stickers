library(fs)
library(rsvg)
library(purrr)

# Identify pngs with bad sizing ------------------------------------------------
png <- dir_ls("png-hires", glob = "*.png")
dims <- unname(purrr::map(png, ~ dim(png::readPNG(.x))))
sizes <- data.frame(
  pkg = path_ext_remove(path_file(png)),
  height = dims %>% map_int(1),
  width = dims %>% map_int(2)
)
subset(sizes, height != 2911)

# Identify missing svg or png files --------------------------------------------
png <- dir_ls("png", glob = "*.png")
svg <- dir_ls("svg", glob = "*.svg")

png_name <- path_ext_remove(path_file(png))
svg_name <- path_ext_remove(path_file(svg))
setdiff(png_name, svg_name)
setdiff(svg_name, png_name)

# Convert svg to png -----------------------------------------------------------
if (!dir_exists("png-lowres")) dir_create("png-lowres")
out <- path("png-lowres", path_ext_set(path_file(svg), "png"))
walk2(svg, out, rsvg_png, width = 250, height = 288.6751)

if (!dir_exists("png_hires")) dir_create("png-hires")
out <- path("png-hires", path_ext_set(path_file(svg), "png"))
walk2(svg, out, rsvg_png, width = 2521, height = 2911)
