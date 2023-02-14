#install.packages('ResourceSelection')
library(ResourceSelection)
library(DescTools) # for BrierScore metric to measure predictive power or models
library(caret)

setwd('~/UChicago/MSCA 31010 - Linear and Non-Linear Models')
data <- read_csv('Amazon.csv')
colnames(data) <- c('isSelected','BestA','BestB','SelectA','SelectB','BestR',
                    'BestU','SelectR','SelectU','price','otherSupplierRank',
                    'bestDelta','nextDelta','dropRatio','MappedDropRatio')

#data$isSelected <- as.factor(data$isSelected)
data$BestA <- as.factor(data$BestA)
data$BestB <- as.factor(data$BestB)
data$SelectA <- as.factor(data$SelectA)
data$SelectB <- as.factor(data$SelectB)
data$BestR <- as.factor(data$BestR)
data$BestU <- as.factor(data$BestU)
data$SelectR <- as.factor(data$SelectR)
data$SelectU <- as.factor(data$SelectU)
data$MappedDropRatio <- as.factor(data$MappedDropRatio)

model <- glm(formula= isSelected ~., data=data, family=binomial(link="logit"))
summary(model)
BrierScore(model)
hoslem.test(data$isSelected, fitted(model)) # fit is not good

1-logLik(model)/logLik(model)
#'log Lik.' 0.9581627 (df=2)
#1-logLik(mod2)/logLik(nullmod2)
#'log Lik.' 0.1187091 (df=2)

# model selection for best model
fwd1 <- step(glm(formula= isSelected ~1, data=data, family=binomial(link="logit")),scope=formula(model),direction='forward')
bkwd1 <- step(model,direction='backward')

model_selected <- glm(formula=isSelected~price+nextDelta+bestDelta+otherSupplierRank,
                      data=data, family=binomial(link="logit"))
summary(model_selected)
BrierScore(model_selected)
hoslem.test(data$isSelected, fitted(model_selected))

osr_OddRatio = exp(model_selected$coefficients[5]) 
osr_OddRatio

#model_selected$coefficients[5]
# Choose x (otherSupplierRank) and extract model coefficients

x = 1
intercept = model_selected$coefficients[1]
slope = model_selected$coefficients[5]

# Compute estimated probability
est_prob = exp(intercept + slope * x)/(1 + exp(intercept + slope * x))
est_prob

x2 = 2

est_prob2 = exp(intercept + slope * x2)/(1 + exp(intercept + slope * x2))
est_prob2


# Compute incremental change in estimated probability given x
ic_prob = slope * est_prob * (1 - est_prob)
ic_prob

# predictions
sample_size = floor(0.7*nrow(data))
picked = sample(seq_len(nrow(data)),size = sample_size)
train=data[picked,]
test=data[-picked,]

train_model <- glm(formula=isSelected~price+nextDelta+bestDelta+otherSupplierRank,
                      data=train, family=binomial(link="logit"))

test$prediction <- predict(train_model, newdata=test, type="response")
test$prediction_0_1 <- ifelse(test$prediction<0.5,0,1)
test$prediction_0_1 <- as.factor(test$prediction_0_1)
test$isSelected <- as.factor(test$isSelected)
example <- confusionMatrix(data=test$prediction_0_1, reference = test$isSelected,
                           positive="1")
print(example)
test$isSelected_num <- as.numeric(test$isSelected)
BrierScore(test$isSelected_num,test$prediction) # prediction validation

# plotting individual predictors vs. probability of isSelected=1

# price model
pmodel <- glm(formula=isSelected~price, data=data, family=binomial(link="logit"))
summary(pmodel)
range(data$price)
xprice <- seq(-0.1,1.5,0.01)
yprice <- predict(pmodel, list(price=xprice),type="response")
plot(data$price, data$isSelected, xlab = "price", ylab = "isSelected")
lines(xprice, yprice)

# nextDelta model
NDmodel <- glm(formula=isSelected~nextDelta, data=data, family=binomial(link="logit"))
summary(NDmodel)
range(data$nextDelta)
xnd <- seq(-0.8,0.1,0.01)
ynd <- predict(NDmodel, list(nextDelta=xnd),type="response")
plot(data$nextDelta, data$isSelected, xlab = "nextDelta", ylab = "isSelected")
lines(xnd, ynd)

# bestDelta model
BDmodel <- glm(formula=isSelected~bestDelta, data=data, family=binomial(link="logit"))
summary(BDmodel)
range(data$bestDelta)
xbd <- seq(-0.1, 1, 0.01)
ybd <- predict(BDmodel, list(bestDelta=xbd),type="response")
plot(data$bestDelta, data$isSelected, xlab = "bestDelta", ylab = "isSelected")
lines(xbd, ybd)
view(ybd)

# otherSupplierRank model
OSRmodel <- glm(formula=isSelected~otherSupplierRank, data=data, family=binomial(link="logit"))
summary(OSRmodel)
range(data$otherSupplierRank)
xosr <- seq(0, 20, 0.01)
yosr <- predict(OSRmodel, list(otherSupplierRank=xosr),type="response")
plot(data$otherSupplierRank, data$isSelected, xlab = "otherSupplierRank", ylab = "isSelected")
lines(xosr, yosr)

# model without price
model_selected2 <- glm(formula=isSelected~nextDelta+bestDelta+otherSupplierRank,
                      data=data, family=binomial(link="logit"))
summary(model_selected2)
BrierScore(model_selected2)

# model with only bestDelta and otherSupplierRank
model_selected3 <- glm(formula=isSelected~bestDelta+otherSupplierRank,
                       data=data, family=binomial(link="logit"))
summary(model_selected3) # AIC is worse
BrierScore(model_selected3) # predictions get worse

