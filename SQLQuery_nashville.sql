 select *
from NashvilleHousing

--standartize date format

select SaleDateConverted, convert (Date,SaleDate)
from NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted1 DATE;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

--populate property adress data

select *
from NashvilleHousing
--WHERE PropertyAddress is null
Order by ParcelID

select a.ParcelID , a.PropertyAddress,b.ParcelID,b.PropertyAddress ,isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b 
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null 


 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b 
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null 

 --Breaking out Address into Individual Colums (adress,city,state)
 Select 
 SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
 SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , Len(PropertyAddress)) as Address
 from NashvilleHousing 

 ALTER TABLE NashvilleHousing
ADD PropertySplitAdress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAdress   = SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

 ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity  = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , Len(PropertyAddress)) 

Select * 
From NashvilleHousing


Select OwnerAddress	
From NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 


--Change Y and N to Yes and No in "Sold as vacant" field

Select Distinct(SoldAsVacant) , COUNT(SoldAsVacant)
From NashvilleHousing
Group By (SoldAsVacant)
Order by 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'YES'	
     When SoldAsVacant = 'N' THEN 'NO'
	 Else SoldAsVacant
	 END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'	
     When SoldAsVacant = 'N' THEN 'NO'
	 Else SoldAsVacant
	 END


-- Remove Duplicates


WITH RowNumCTE AS (
Select *, 
 ROW_NUMBER () OVER(
 PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY
			     UniqueID  
				 ) row_num

 From NashvilleHousing
 )

 Select * 
 From RowNumCTE
 Where row_num > 1 
 Order by PropertyAddress



 -- Delete Unused Colums

 Select *
 From NashvilleHousing


 ALTER TABLE NashvilleHousing
 DROP COLUMN OwnerAddress , TaxDistrict,PropertyAddress
      
	  
 ALTER TABLE NashvilleHousing
 DROP COLUMN SaleDate