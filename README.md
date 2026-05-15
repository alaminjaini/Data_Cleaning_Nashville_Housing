# Nashville Housing Data Cleaning (SQL)

Data cleaning project using SQL Server on the Nashville Housing dataset.

## What This Script Does

**1. Standardize Date Format**
- Converts `SaleDate` from DateTime to Date format
- Stores the result in a new column `SaleDateConverted`

**2. Populate Property Address**
- Uses a self-join on `ParcelID` to fill in NULL `PropertyAddress` values from matching records

**3. Split Address Columns**
- Splits `PropertyAddress` into `PropertySplitAddress` and `PropertySplitCity` using `SUBSTRING`
- Splits `OwnerAddress` into `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitState` using `PARSENAME`

**4. Standardize Sold As Vacant Field**
- Converts `Y` / `N` values to `Yes` / `No` using a CASE statement

**5. Remove Duplicates**
- Uses `ROW_NUMBER()` with `PARTITION BY` on `ParcelID`, `PropertyAddress`, `SaleDate`, and `LegalReference` to identify and delete duplicate rows

**6. Remove Unused Columns**
- Drops `OwnerAddress`, `TaxDistrict`, `PropertyAddress`, and `SaleDate` after they have been replaced or are no longer needed

## Tools Used
- SQL Server (T-SQL)
- SSMS (SQL Server Management Studio)

## Dataset
Nashville Housing Data
