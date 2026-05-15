test_that("nVenn object has the necessary fields", {
  testObject <- nVennDiagram(exampledf, plot = F, verbose = F)
  expect_contains(names(testObject), 
                  c('desc', 'setNames', 'opts'))
  expect_equal(length(testObject$setNames), length(names(exampledf)))
  expect_contains(testObject$setNames, names(exampledf))
  expect_contains(getVennSetNames(testObject), names(exampledf))
  expect_setequal(getVennRegion(testObject, c('SAS', 'PYTHON')), c('A003'))
})


test_that("exhaustive time is reasonable", {
  expect_lt(estimateExhaustiveRunTime(exampledf, 4), 100)
})
