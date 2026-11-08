# ==============================================================================
# Script:      01_linear_regression_auto.R
# Description: OLS Linear Regression, Residual Diagnostics & Transformations
# Dataset:     Auto (Miles Per Gallon, Horsepower, Weight, etc.)
# ==============================================================================

# 1. Загрузка данных (поиск в data/ или локально)
find_data_path <- function(filename) {
  paths <- c(file.path("data", filename), filename, file.path("..", "data", filename))
  for (p in paths) if (file.exists(p)) return(p)
  return(NULL)
}

data_path <- find_data_path("Auto.csv")

if (!is.null(data_path)) {
  cat("[*] Loading dataset from:", data_path, "\n")
  auto_data <- read.csv(data_path)
} else {
  cat("[!] Auto.csv not found. Using synthetic data for demonstration...\n")
  set.seed(42)
  n <- 392
  auto_data <- data.frame(
    horsepower = round(runif(n, 46, 230)),
    weight = round(runif(n, 1600, 5100)),
    acceleration = runif(n, 8, 25),
    cylinders = sample(c(4, 6, 8), n, replace = TRUE)
  )
  auto_data$mpg <- round(45 - 0.15 * auto_data$horsepower - 0.005 * auto_data$weight + rnorm(n, 0, 3), 1)
}

# 2. Предобработка типов данных
auto_data$horsepower <- suppressWarnings(as.numeric(as.character(auto_data$horsepower)))
auto_data <- na.omit(auto_data)

cat("========================================================================\n")
cat("  1. UNIVARIATE OLS REGRESSION (mpg ~ horsepower)\n")
cat("========================================================================\n")
model_simple <- lm(mpg ~ horsepower, data = auto_data)
print(summary(model_simple))

# 3. Точечный прогноз для тестового значения horsepower
test_hp <- 94
pred_val <- predict(model_simple, newdata = data.frame(horsepower = test_hp))
cat("\nPredicted MPG for horsepower =", test_hp, ":", round(pred_val, 2), "\n\n")

# 4. Диагностика нелинейности и стабилизация дисперсии
cat("========================================================================\n")
cat("  2. NON-LINEAR TRANSFORMATIONS (sqrt(mpg))\n")
cat("========================================================================\n")
auto_data$sqrt_mpg <- sqrt(auto_data$mpg)
model_trans <- lm(sqrt_mpg ~ horsepower, data = auto_data)

cat("R-squared (Base Model):       ", round(summary(model_simple)$r.squared, 4), "\n")
cat("R-squared (Sqrt Transformed): ", round(summary(model_trans)$r.squared, 4), "\n\n")

# 5. Сохранение графиков диагностики остатков
png("auto_regression_diagnostics.png", width = 800, height = 800)
par(mfrow = c(2, 2))
plot(model_simple, main = "Diagnostics: Base OLS")
dev.off()
cat("[+] 4-Panel Diagnostic plots saved to 'auto_regression_diagnostics.png'\n")
