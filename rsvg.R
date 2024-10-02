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
png_hires <- dir_ls("png-hires", glob = "*.png")
png_lowres <- dir_ls("png-lowres", glob = "*.png")
svg <- dir_ls("svg", glob = "*.svg")

png_hires_name <- path_ext_remove(path_file(png_hires))
png_lowres_name <- path_ext_remove(path_file(png_lowres))
svg_name <- path_ext_remove(path_file(svg))
setdiff(png_hires_name, svg_name)
setdiff(png_lowres_name, svg_name)
(missing_hi <- setdiff(svg_name, png_hires_name))
(missing_low <- setdiff(svg_name, png_lowres_name))

# Convert svg to png -----------------------------------------------------------
if (!dir_exists("png-lowres")) dir_create("png-lowres")
if (length(missing_low) > 0) {
  out <- path("png-lowres", path_ext_set(path_file(missing_low), "png"))
  walk2(path("svg", path_ext_set(path_file(missing_low), "svg")), out,
        rsvg_png, width = 250, height = 288.6751)
}

if (!dir_exists("png_hires")) dir_create("png-hires")
if (length(missing_hi) > 0) {
  out <- path("png-hires", path_ext_set(path_file(missing_hi), "png"))
  walk2(path("svg", path_ext_set(path_file(missing_hi), "svg")), out,
        rsvg_png, width = 2521, height = 2911)
}
