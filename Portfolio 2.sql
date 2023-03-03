

-- Cleaning Data in SQL Queries If Update doesn't work in first time you can use ALTER and then update

Select *
From [Portfolio Project].dbo.NashvillHousing


Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio Project].dbo.NashvillHousing

Update NashvillHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvillHousing
Add SaleDateConverted Date;

Update NashvillHousing 
SET SaleDateConverted = CONVERT(Date,SaleDate)

------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------

--Breaking Out Address Individual Columns (Address , city , state) For this we are going to use Substring and character index

Select PropertyAddress
From [Portfolio Project].dbo.NashvillHousing
--Where PropertyAddress is null
--Order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From [Portfolio Project].dbo.NashvillHousing

ALTER TABLE NashvillHousing
Add PropertySplitAddress nvarchar(255);

Update NashvillHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvillHousing
Add PropertySplitCity  nvarchar(255);

Update NashvillHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select *

From [Portfolio Project].dbo.NashvillHousing

------------------------------------------------------------------------------------------------------------------
--Owner address Spliting in Different way ParseName and replace

Select OwnerAddress

From [Portfolio Project].dbo.NashvillHousing

Select 
PARSENAME(REPLACE (OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE (OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE (OwnerAddress, ',','.'),1)
From [Portfolio Project].dbo.NashvillHousing

ALTER TABLE NashvillHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvillHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress, ',','.'),3)

ALTER TABLE NashvillHousing
Add OwnerSplitCity  nvarchar(255);

Update NashvillHousing 
SET OwnerSplitCity = PARSENAME(REPLACE (OwnerAddress, ',','.'),2)

ALTER TABLE NashvillHousing
Add OwnerSplitState nvarchar(255);

Update NashvillHousing 
SET OwnerSplitState = PARSENAME(REPLACE (OwnerAddress, ',','.'),1)


Select *

From [Portfolio Project].dbo.NashvillHousing
-------------------------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant), COUNT(SoldASVacant)
From [Portfolio Project].dbo.NashvillHousing
Group by SoldASVacant
Order by 2


Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'YES'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
From [Portfolio Project].dbo.NashvillHousing

Update NashvillHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

-----------------------------------------------------------------------------------------------------------------
--Remove Duplicates
WITH RowNumCTE AS(
Select *,
ROW_NUMBER () OVER (
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY 
UniqueID
) row_num

From [Portfolio Project].dbo.NashvillHousing
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num >1
order by PropertyAddress



Select *
From [Portfolio Project].dbo.NashvillHousing

-----------------------------------------------------------------------------------------------------------------------------
--Delete Unused columns

Select *
From [Portfolio Project].dbo.NashvillHousing


ALTER TABLE [Portfolio Project].dbo.NashvillHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE [Portfolio Project].dbo.NashvillHousing
DROP COLUMN SaleDate