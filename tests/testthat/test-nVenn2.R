test_that("nVenn object has the necessary fields", {
  testObject <- nVennDiagram(exampledf, plot = F, verbose = F)
  
  expect_contains(names(testObject), 
                  c('desc', 'setNames', 'opts'))
  expect_equal(length(testObject$setNames), length(names(exampledf)))
  expect_contains(testObject$setNames, names(exampledf))
  expect_contains(getVennSetNames(testObject), names(exampledf))
})

test_that("Object can be modified", {
  testObject <- nVennDiagram(exampledf, plot = F, verbose = F)
  colorVector <- c("red", "grey")
  colorList <- list(SAS="blue", PYTHON="#00ff11")
  mytheme <- list(opacity=0.2, lineWidth=2, fontSize=16, 
                  showRegions=F, 
                  colors=c("red", "green", "blue", "black", "#ffff00"))
  
  expect_no_warning(testObject <- setVennColor(testObject, "SAS", 'black'))
  expect_no_warning(testObject <- setVennPalette(testObject, palette = 2))
  expect_no_warning(testObject <- setVennOpts(testObject, palette = 2))
  expect_no_warning(testObject <- setVennColors(testObject, colorVector))
  expect_no_warning(testObject <- setVennColors(testObject, colorList))
  expect_no_warning(testObject <- setVennSkin(testObject, mytheme))
  expect_warning(testObject <- setVennColor(testObject, "Unexisting", 'black'))
})


test_that("exhaustive time is reasonable", {
  expect_lt(estimateExhaustiveRunTime(exampledf, 4), 100)
})
