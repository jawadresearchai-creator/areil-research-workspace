#!/usr/bin/env Rscript

required <- c("ggplot2", "svglite", "ragg")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {
  stop("Missing R packages: ", paste(missing, collapse = ", "))
}

dir.create("artifacts", recursive = TRUE, showWarnings = FALSE)

df <- data.frame(
  x = rep(1:8, 2),
  y = c((1:8)^1.4, (1:8)^1.25 + 1),
  treatment = rep(c("Control", "Treatment"), each = 8)
)

p <- ggplot2::ggplot(
  df,
  ggplot2::aes(x = x, y = y, group = treatment, linetype = treatment, shape = treatment)
) +
  ggplot2::geom_line(linewidth = 0.6) +
  ggplot2::geom_point(size = 2.2) +
  ggplot2::labs(
    x = "Time",
    y = "Response",
    title = "AREIL scientific figure toolchain smoke test"
  ) +
  ggplot2::theme_classic(base_size = 10) +
  ggplot2::theme(
    legend.title = ggplot2::element_blank(),
    plot.title = ggplot2::element_text(size = 10)
  )

ggplot2::ggsave(
  filename = "artifacts/ggplot2_smoke.svg",
  plot = p,
  width = 4.5,
  height = 3.2,
  units = "in",
  device = svglite::svglite
)

ggplot2::ggsave(
  filename = "artifacts/ggplot2_smoke.png",
  plot = p,
  width = 4.5,
  height = 3.2,
  units = "in",
  dpi = 600,
  device = ragg::agg_png
)

stopifnot(
  file.exists("artifacts/ggplot2_smoke.svg"),
  file.exists("artifacts/ggplot2_smoke.png")
)

cat("R/ggplot2 smoke test passed.\n")
cat("ggplot2 version:", as.character(utils::packageVersion("ggplot2")), "\n")
