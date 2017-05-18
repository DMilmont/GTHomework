


# create the C parameter in continuous space: 2^-5 : 2^5
ps = makeParamSet(
  makeNumericParam("C", lower = -5, upper = 5, trafo = function(x) 2^x)
)
# random search in the space with 100 iterations
ctrl = makeTuneControlRandom(maxit = 100L)
# 3-fold CV
rdesc = makeResampleDesc("CV", iters = 2L)
# run the hyperparameter tuning process
res = tuneParams("classif.ksvm", task = pid.task, control = ctrl, 
                 resampling = rdesc, par.set = ps, show.info = FALSE)
print(res)
## Tune result:
## Op. pars: C=0.347
## mmce.test.mean=0.233
