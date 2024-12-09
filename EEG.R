
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)

# Load your dataset
file_path <- "~/Downloads/Cadetsall.xlsx"
cadetsall <- read_excel(file_path)

# Rename the misspelled column
cadetsall <- cadetsall %>%
  rename(Parietal = Pareital)

# Remove extreme outliers, calculate z-scores, and normalize to -1 and 1
cadetsall <- cadetsall %>%
  mutate(across(c(Frontal, Temporal, Parietal, Occipital),
                ~ scale(.)[, 1], # Calculate z-scores
                .names = "z_{.col}")) %>%
  mutate(across(starts_with("z_"),
                ~ ifelse(abs(.) > 3, NA, .), # Remove general outliers
                .names = "{.col}")) %>%
  mutate(across(starts_with("z_"),
                ~ . / max(abs(.), na.rm = TRUE), # Normalize to -1 and 1
                .names = "scaled_{.col}"))

# Remove the highest Occipital value for Specialized cadets
cadetsall <- cadetsall %>%
  mutate(scaled_z_Occipital = ifelse(
    cohort_n == "Specialized" & scaled_z_Occipital == max(scaled_z_Occipital[cohort_n == "Specialized"], na.rm = TRUE),
    NA,
    scaled_z_Occipital
  ))

# Prepare data for ANOVA and pairwise t-tests
anova_data <- cadetsall %>%
  pivot_longer(cols = starts_with("scaled_z_"),
               names_to = "Variable",
               values_to = "Z_Score")

# Conduct ANOVA and pairwise t-tests with Bonferroni correction
results <- anova_data %>%
  group_by(Variable) %>%
  summarise(
    ANOVA = list(aov(Z_Score ~ cohort_n, data = cur_data())),
    Pairwise_Bonferroni = list({
      pairwise <- pairwise.t.test(cur_data()$Z_Score, cur_data()$cohort_n,
                                  p.adjust.method = "bonferroni", na.rm = TRUE)
      pairwise
    })
  )

# Print ANOVA and pairwise Bonferroni results
for (i in 1:nrow(results)) {
  cat("\n--- ANOVA Results for", results$Variable[i], "---\n")
  print(summary(results$ANOVA[[i]]))
  
  cat("\n--- Pairwise Bonferroni Results for", results$Variable[i], "---\n")
  print(results$Pairwise_Bonferroni[[i]])
}

