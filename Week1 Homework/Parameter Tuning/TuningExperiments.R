library('mlr')

#https://www.r-bloggers.com/exploring-and-understanding-hyperparameter-tuning/

ps = makeParamSet(
  makeNumericParam("C", lower = 0.01, upper = 0.1)
)

## ex: random search with 100 iterations
ctrl = makeTuneControlRandom(maxit = 100L)

discrete_ps = makeParamSet(
  makeDiscreteParam("C", values = c(0.5, 1.0, 1.5, 2.0)),
  makeDiscreteParam("sigma", values = c(0.5, 1.0, 1.5, 2.0))
)

print(discrete_ps)

num_ps = makeParamSet(
  makeNumericParam("C", lower = -10, upper = 10, trafo = function(x) 10^x),
  makeNumericParam("sigma", lower = -10, upper = 10, trafo = function(x) 10^x)
)

print(num_ps)

rdesc = makeResampleDesc("CV", iters = 3L)

discrete_ps = makeParamSet(
  makeDiscreteParam("C", values = c(0.5, 1.0, 1.5, 2.0)),
  makeDiscreteParam("sigma", values = c(0.5, 1.0, 1.5, 2.0))
)
ctrl = makeTuneControlGrid()
rdesc = makeResampleDesc("CV", iters = 3L)
res = tuneParams("classif.ksvm", task = iris.task, resampling = rdesc,
                 par.set = discrete_ps, control = ctrl)

iris.task