cor_test <- function(cor_1, cor_2, n_1, n_2){
  fisher_trans_1 <- 0.5 * log((1 + cor_1)/(1 - cor_1))
  fisher_trans_2 <- 0.5 * log((1 + cor_2)/(1 - cor_2))
  var_diff       <- sqrt(1/(n_1 - 3) + 1/(n_2 - 3))
  zstat          <- (fisher_trans_1 - fisher_trans_2) / var_diff
  1 - (2 * pnorm(-abs(zstat)))
}

# univariate correlation tests
cor_test_1 <- function(df_input){
  # every combination of variables
  c_nms <- colnames(df_input)
  c_cmbs <- expand.grid(col_1 =  c_nms, col_2 =  c_nms) %>%
    dplyr::filter(as.numeric(col_1) > as.numeric(col_2), !col_1 == col_2) %>%
    dplyr::mutate_all(as.character) %>% dplyr::mutate(pair = paste(col_1, col_2, sep = " & "))
  # loop over rows and calculate correlation, p.value and cint
  out_cors <- vector("list", length = nrow(c_cmbs))
  for(i in 1:nrow(c_cmbs)){
    c_df <- df_input %>% dplyr::select_(c_cmbs$col_1[i], c_cmbs$col_2[i])
    c_test <- cor.test(c_df[, 1, drop = T], c_df[, 2, drop = T])
    out_cors[[i]] <- tibble::tibble(correlation = c_test$estimate, p_value = c_test$p.value,
                            lower = c_test$conf.int[1],  upper = c_test$conf.int[2]) 
  }
  # combine into a single tibble
  cor_out <- dplyr::bind_cols(c_cmbs, dplyr::bind_rows(out_cors)) %>% 
    dplyr::arrange(dplyr::desc(abs(correlation))) %>% tibble::as_tibble()
    
  # return tibble of correlations
  return(cor_out)
}