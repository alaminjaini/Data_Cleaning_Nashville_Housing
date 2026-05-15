--Nashville Housing Data Cleaning

Select *
From dbo.NashvilleHousing

--Standardize Date Format

Select SaleDate, CONVERT(Date,Saledate)
From dbo.NashvilleHousing

Alter Table NashvilleHousing
Drop Column if exists SaleDateConverted;

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date,Saledate)

--Populate Property Address data

Select *
From dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Verify no nulls remain
Select *
From dbo.NashvilleHousing
Where PropertyAddress is null

--Breaking out address into individual columns (Address,City,State)

Select PropertyAddress
From dbo.NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as City

From dbo.NashvilleHousing

Alter Table NashvilleHousing 
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

Select OwnerAddress
From NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'),3),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)

Select *
From dbo.NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), COUNT(SoldasVacant)
From dbo.NashvilleHousing
Group by SoldAsVacant
Order by SoldAsVacant

Select SoldAsVacant,
 Case When SoldAsVacant = 'Y' then 'Yes'
	  When SoldAsVacant = 'N' then  'No'
	  Else SoldAsVacant
	  End
From dbo.NashvilleHousing

Update dbo.NashvilleHousing
Set SoldAsVacant  =  
Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then  'No'
	 Else SoldAsVacant
	 End

--Remove duplicates

With RowNumCTE as(
Select *,
	Row_Number()Over(
	Partition By ParcelID,
				 PropertyAddress,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					)row_num

From dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


With RowNumCTE as(
Select *,
	Row_Number()Over(
	Partition By ParcelID,
				 PropertyAddress,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					)row_num

From dbo.NashvilleHousing
)
Delete
From RowNumCTE
Where row_num > 1

--Remove Unused Column

Select *
From dbo.NashvilleHousing

Alter table dbo.NashvilleHousing
Drop Column OwnerAddress,TaxDistrict, PropertyAddress

Alter table dbo.NashvilleHousing
Drop Column SaleDate