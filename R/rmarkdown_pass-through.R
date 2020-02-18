
make_rmd <- function(p1){
  # browser()
  rmd_lines <- readr::read_lines("skeleton.Rmd")

  chunk_lines <- make_chunks(p1)

  chunk_lines <- c(rmd_lines, chunk_lines)

  return(chunk_lines)
}

make_chunks <- function(p1){
  c("```{r test, include = FALSE}",
         quo_text(p1),
         "```",
         "---",
         "`r chunk_reveal(\"test\", break_type = \"auto\")`")
}

test0 <- make_rmd(p1)
