# ==============================================================================
# Script:      03_interaction_outliers_abalone.R
# Description: Outlier Treatment (IQR Rule), Interaction Terms & ANOVA F-Test
# Dataset:     Abalone (Physical Dimensions, Weight & Rings/Age)
# ==============================================================================

find_data_path <- function(filename) {
  paths <- c(file.path("data", filename), filename, file.path("..", "data", filename))
  for (p in paths) if (file.exists(p)) return(p)
  return(NULL)
}

data_path <- find_data_path("abalone.csv")

if (!is.null(data_path)) {
  cat("[*] Loading dataset from:", data_path, "\n")
  abalone <- read.csv(data_path)
} else {
  cat("[!] abalone.csv not found. Generating synthetic biological dataset...\n")
  set.seed(42)
  n <- 1000
  abalone <- data.frame(
    Diameter = runif(n, 0.15, 0.65),
    Height = runif(n, 0.05, 0.25),
    Whole.weight = runif(n, 0.1, 2.5)
  )
  abalone$Rings <- round(3 + 8 * abalone$Diameter + 12 * abalone$Height +
                         5 * (abalone$Diameter * abalone$Height) + rnorm(n, 0, 1.8))
  # Искусственные выбросы для проверки IQR
  abalone$Height[c(10, 25)] <- c(0.85, 1.10)
}

# 1. Выборка целевых переменных
vars <- c("Rings", "Diameter", "Height", "Whole.weight")
clean_subset <- abalone[, vars]

# 2. Фильтрация выбросов по правилу Тьюки (1.5 * IQR)
iqr_filter <- function(vec) {
  q <- quantile(vec, probs = c(0.25, 0.75), na.rm = TRUE)
  r <- IQR(vec, na.rm = TRUE)
  return(vec >= (q[1] - 1.5 * r) & vec <= (q[2] + 1.5 * r))
}

mask <- iqr_filter(clean_subset$Diameter) &
        iqr_filter(clean_subset$Height) &
        iqr_filter(clean_subset$Whole.weight)

filtered_data <- clean_subset[mask, ]
cat("Samples before IQR filtering: ", nrow(clean_subset), "\n")
cat("Samples after IQR filtering:  ", nrow(filtered_data), "\n")
cat("Outliers purged:              ", nrow(clean_subset) - nrow(filtered_data), "\n\n")

# 3. Базовая аддитивная модель vs Модель взаимодействия
cat("========================================================================\n")
cat("  1. MODEL COMPARISON: BASELINE vs INTERACTION TERM\n")
cat("========================================================================\n")
model_base  <- lm(Rings ~ Diameter + Height + Whole.weight, data = filtered_data)
model_inter <- lm(Rings ~ Diameter * Height + Whole.weight, data = filtered_data)

cat("Adjusted R-squared (Base Model):        ", round(summary(model_base)$adj.r.squared, 4), "\n")
cat("Adjusted R-squared (Interaction Model): ", round(summary(model_inter)$adj.r.squared, 4), "\n\n")

cat("[*] Analysis of Variance (ANOVA F-Test):\n")
print(anova(model_base, model_inter))

# 4. Логарифмическое масштабирование предикторов
cat("\n========================================================================\n")
cat("  2. NON-LINEAR FEATURE SCALING (log(Diameter))\n")
cat("========================================================================\n")
model_log <- lm(Rings ~ log(Diameter) + Height + Whole.weight, data = filtered_data)
cat("Adjusted R-squared (Log Model):         ", round(summary(model_log)$adj.r.squared, 4), "\n")
