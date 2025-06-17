library(tidyverse)
library(ggdist)
library(here)
library(ggview)

# functions --------------------------------------------------------------------
## https://stackoverflow.com/questions/79669676/extract-the-coordinates-of-a-rendered-dot-plot/
extract_dot_locations <- function(p) {
  p2 <- p |> ggplot2::ggplot_build() |> ggplot2::ggplot_gtable()

  pg <- p2$grobs[[6]]$children[[3]]$children[[1]]

  xvals <- numeric()
  yvals <- numeric()
  pg$make_points_grob <- function (x, y, pch, col, fill, fontfamily,
                                   fontsize, lwd, lty,  ...) {
    xvals <<- x
    yvals <<- y
    grid::pointsGrob(x = x, y = y, pch = pch,
                     gp = grid::gpar(col = col,
                                     fill = fill, fontfamily = fontfamily, fontsize = fontsize,
                                     lwd = lwd, lty = lty))
  }

  p2$grobs[[6]]$children[[3]]$children[[1]] <- pg
  grid::grid.newpage()
  grid::grid.draw(p2)
  data.frame(x = xvals, y = yvals)
}

# create plot ------------------------------------------------------------------
set.seed(3267826)
# tibble(x = rchisq(500, df = 10)) |>
#   ggplot(aes(x = x)) +
#   geom_dots(layout = "hex", shape = "\u2B22", dotsize = 1.5,
#             color = "#8ecae6") -> p

tibble(x = rbeta(600, 5, 25)) |>
  ggplot(aes(x = x)) +
  geom_dots(layout = "hex") -> p

point_data <- extract_dot_locations(p)

point_data |>
  ggplot(aes(x = x, y = y)) +
  ggstar::geom_star(starshape = 6, size = 7, color = "#83cae6",
                    fill = "#8ecae6") +
  theme_void() -> new_p

new_p +
  canvas(width = 20, height = 8, units = "in", dpi = 320, bg = "white")



ggsave("dcmstan-dist.svg", plot = new_p, path = here("R", "img"),
       width = 20, height = 8, units = "in", dpi = 320)
