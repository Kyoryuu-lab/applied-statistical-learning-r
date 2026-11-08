# ==============================================================================
# Script:      02_logistic_classification_default.R
# Description: Binomial Logistic Regression (GLM) & Classification Error Rate
# Dataset:     Default (Credit Card Default Status, Balance, Income)
# ==============================================================================

find_data_path <- function(filename) {
  paths <- c(file.path("data", filename), filename, file.path("..", "data", filename))
  for (p in paths) if (file.exists(p)) return(p)
  return(NULL)
}

data_path <- find_data_path("Default.csv")

if (!is.null(data_path)) {
  cat("[*] Loading dataset from:", data_path, "\n")
  default_data <- read.csv(data_path)
} else {
  cat("[!] Default.csv not found. Generating synthetic credit dataset...\n")
  set.seed(123)
  n <- 10000
  default_data <- data.frame(
    balance = pmax(0, rnorm(n, mean = 1000, sd = 450)),
    income = pmax(5000, rnorm(n, mean = 33000, sd = 12000))
  )
  z <- -10.5 + 0.0055 * default_data$balance + 0.00002 * default_data$income
  prob <- 1 / (1 + exp(-z))
  default_data$default <- ifelse(runif(n) < prob, "Yes", "No")
}

# 1. Бинарное кодирование целевой переменной (Yes -> 1, No -> 0)
default_data$default_numeric <- ifelse(default_data$default == "Yes", 1, 0)

cat("========================================================================\n")
cat("  1. FITTING LOGISTIC GLM ON FULL DATASET\n")
cat("========================================================================\n")
glm_full <- glm(default_numeric ~ balance + income, data = default_data, family = "binomial")
print(summary(glm_full))

# 2. Оценка качества на отложенной выборке (70% Train / 30% Test)
cat("\n========================================================================\n")
cat("  2. TRAIN / TEST SPLIT EVALUATION (70 / 30)\n")
cat("========================================================================\n")
set.seed(123)
n_total <- nrow(default_data)
train_indices <- sample(1:n_total, size = floor(0.70 * n_total))
train_set <- default_data[train_indices, ]
test_set  <- default_data[-train_indices, ]

glm_split <- glm(default_numeric ~ balance + income, data = train_set, family = "binomial")
test_probs <- predict(glm_split, newdata = test_set, type = "response")
test_preds <- ifelse(test_probs > 0.5, 1, 0)

error_rate <- mean(test_preds != test_set$default_numeric)
accuracy   <- 1 - error_rate

cat("Test Set Size:            ", nrow(test_set), "observations\n")
cat("Misclassification Error:  ", round(error_rate * 100, 2), "%\n")
cat("Classification Accuracy:  ", round(accuracy * 100, 2), "%\n\n")

# 3. Валидация стабильности на трёх независимых случайных разбиениях
cat("--- Stability Check across 3 Random Partitions ---\n")
error_runs <- numeric(3)
for (i in 1:3) {
  idx <- sample(1:n_total, size = floor(0.70 * n_total))
  m <- glm(default_numeric ~ balance + income, data = default_data[idx, ], family = "binomial")
  p <- predict(m, newdata = default_data[-idx, ], type = "response")
  error_runs[i] <- mean(ifelse(p > 0.5, 1, 0) != default_data[-idx, ]$default_numeric)
  cat(sprintf("Run %d Error Rate: %.3f %%\n", i, error_runs[i] * 100))
}
cat("Mean Validation Error:   ", round(mean(error_runs) * 100, 2), "%\n")
