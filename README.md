# 📊 PAN Number Validation – Summary Report

## Project Overview

This SQL-based project provides a systematic approach to validating Indian PAN numbers. It combines data cleaning, pattern checks, and custom PL/pgSQL functions to ensure PAN records meet official formatting rules and avoid common errors.
The output includes both record-level validation status and aggregate summary metrics for deeper data insights.

## Key Performance Indicators (KPIs)

The validation workflow highlights the following critical metrics:

- **Total Processed Records**: All PAN numbers analyzed from the dataset.

- **Valid PAN Count**: PAN numbers that meet format, repetition, and sequence rules.

- **Invalid PAN Count**: PAN numbers failing any validation rule.

- **Missing/Incomplete PAN Count**: PAN numbers that are blank, NULL, or improperly formatted.

## Features

- **Data Cleaning**:

    - Removal of duplicates, blank entries, and NULL values.
    - Trimming of leading/trailing spaces.
    - Standardization to uppercase format.
    - Validation Rules Applied:
    - PAN format check: `^[A-Z]{5}[0-9]{4}[A-Z]$`
    - No adjacent identical letters in the first 5 characters.
    - First 5 characters must not form an alphabetic sequence.

- **Custom Functions**:

  - `fn_check_adjacent_repetition()` → Detects consecutive identical characters.

  - `fn_check_sequence()` → Detects alphabetic sequences.

- **View Creation**:

  - `vw_valid_invalid_pans` → Categorizes each PAN as Valid or Invalid.

- **Summary Report Query**:

  - Shows counts for total records, valid PANs, invalid PANs, and missing/incomplete PANs.

## Key Data Insights and Conclusions

- **High Compliance Rate**: A majority of PANs pass validation, indicating good data quality.
- **Common Failure Reasons**: Most invalid PANs fail due to adjacent letter repetition or sequential letters.
- **Data Entry Issues**: Some PANs are invalid due to trailing spaces or lowercase entries, highlighting the need for frontend validation.
- **Rule Effectiveness**: Regex pattern filtering alone catches a large portion of invalid entries, but business rules add a valuable extra layer.
