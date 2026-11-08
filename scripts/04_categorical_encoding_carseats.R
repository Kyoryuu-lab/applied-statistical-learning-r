# ==============================================================================
# Script:      04_categorical_encoding_carseats.R
# Description: Qualitative Predictors, Contrast Dummy Encoding & Sales OLS
# Dataset:     Carseats (Retail Sales, Competitor Pricing, Shelve Quality)
# ==============================================================================

find_data_path <- function(filename) {
  paths <- c(file.path("data", filename), filename, file.path("..", "data", filename))
  for (p in paths) if (file.exists(p)) return(p)
  return(NULL)
}

data_path <- find_data_path("Carseats.csv")

if (!is.null(data_path)) {
  cat("[*] Loading dataset from:", data_path, "\n")
  carseats <- read.csv(data_path)
} else {
  cat("[!] Carseats.csv not found. Generating synthetic retail dataset...\n")
  set.seed(99)
  n <- 400
  carseats <- data.frame(
    Price = round(runif(n, 50, 190)),
    Advertising = round(runif(n, 0, 25)),
    Age = round(runif(n, 25, 80)),
    ShelveLoc = sample(c("Bad", "Medium", "Good"), n, replace = TRUE, prob = c(0.25, 0.55, 0.20)),
    Urban = sample(c("Yes", "No"), n, replace = TRUE),
    US = sample(c("Yes", "No"), n, replace = TRUE)
  )
  shelve_effect <- ifelse(carseats$ShelveLoc == "Good", 4.8,
                          ifelse(carseats$ShelveLoc == "Medium", 2.0, 0))
  carseats$Sales <- round(7.5 - 0.05 * carseats$Price + 0.12 * carseats$Advertising +
                          shelve_effect + rnorm(n, 0, 1.2), 2)
}

# 1. Анализ типов колонок и качественных уровней
cat("========================================================================\n")
cat("  1. CATEGORICAL COLUMNS & FACTOR CONVERSIONS\n")
cat("========================================================================\n")
for (col in colnames(carseats)) {
  if (is.character(carseats[[col]])) {
    cat(sprintf("Categorical feature '%s' with levels: [%s]\n",
                col, paste(unique(carseats[[col]]), collapse = ", ")))
    carseats[[col]] <- as.factor(carseats[[col]])
  }
}

# 2. Исследование матрицы контрастов (Dummy Variable Coding)
cat("\n========================================================================\n")
cat("  2. CONTRAST ENCODING MATRIX FOR 'ShelveLoc'\n")
cat("========================================================================\n")
print(contrasts(carseats$ShelveLoc))
cat("(Baseline category is 'Bad' -> Good and Medium are modeled as dummy offsets)\n\n")

# 3. Множественная линейная регрессия
cat("========================================================================\n")
cat("  3. MULTIPLE LINEAR REGRESSION ON UNIT SALES\n")
cat("========================================================================\n")
sales_model <- lm(Sales ~ ., data = carseats)
print(summary(sales_model))
