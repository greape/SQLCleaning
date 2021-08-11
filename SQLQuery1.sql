/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [Sql Project].[dbo].[NashvilleHouse] 
  
  SELECT SaleDate, CONVERT(date,SaleDate)
  FROM [Sql Project].[dbo].[NashvilleHouse]   
  order by 1

  update NashvilleHouse
  set SaleDate = CONVERT(date,saledate)

  ALTER TABLE NashvilleHouse
  add NewSaleDate Date;

  update NashvilleHouse
  set NewSaleDate = CONVERT(date,saledate)

  SELECT a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
  FROM [Sql Project]..NashvilleHouse a
  join [Sql Project]..NashvilleHouse b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
 

update a 
set a.PropertyAddress =  isnull(a.PropertyAddress,b.PropertyAddress)
FROM [Sql Project]..NashvilleHouse a
  join [Sql Project]..NashvilleHouse b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address
FROM [Sql Project]..NashvilleHouse

ALTER TABLE NashvilleHouse
  add NewPropertyAddress nvarchar(255);

  update NashvilleHouse
  set NewPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

  ALTER TABLE NashvilleHouse
  add PropertyCity nvarchar(255);

  update NashvilleHouse
  set PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

 select 
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
 ,PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)
 ,PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
FROM [Sql Project]..NashvilleHouse

ALTER TABLE NashvilleHouse
  add NewOwnerAddress nvarchar(255);
  update NashvilleHouse
  set NewOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHouse
  add OwnerCity nvarchar(255);
  update NashvilleHouse
  set OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

  ALTER TABLE NashvilleHouse
  add OwnerState nvarchar(255);
  update NashvilleHouse
  set OwnerState =PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

  select  SoldAsVacant ,
  Case
		WHEN SoldAsVacant = 'N' THEN 'No'
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		ELSE SoldAsVacant
  END AS SoldAsVacant
  from [Sql Project]..NashvilleHouse
  
  UPDATE NashvilleHouse
  SET SoldAsVacant =   Case
		WHEN SoldAsVacant = 'N' THEN 'No'
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		ELSE SoldAsVacant
		END

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
  FROM [Sql Project].[dbo].[NashvilleHouse]
  )
 SELECT *
  From RowNumCTE
  where row_num>1
 
  ALTER TABLE [Sql Project].[dbo].[NashvilleHouse]
  DROP COLUMN PropertyAddress,SaleDate,OwnerAddress