If you're a member of the r-dcm developer team, you can add new stickers to this repo by creating a pull request.
The pull request should contain two files:

* A `.svg` in the `SVG` directory (with fonts converted to outlines).
* A `.png` in the `PNG` directory (with dimensions 2521 x 2911).

If you only have the `.svg`, you can use the following code to generate the `.png`:

```R
library(rsvg)
pkg <- "foofy"
rsvg_png(paste0("SVG/", pkg, ".svg"), paste0("png-hires/", pkg, ".png"), width = 2521, height = 2911)
```

### Specs

* Point down hexagon
* 2" high (point to point); 1.74" wide (side to side)
* Default font: [Ubuntu](https://fonts.google.com/specimen/Ubuntu?query=ubuntu)
