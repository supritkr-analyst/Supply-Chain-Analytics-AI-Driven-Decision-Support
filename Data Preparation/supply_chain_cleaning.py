import pandas as pd

df = pd.read_csv('C:\\Users\\ASUS\\Desktop\\3\\SupplyChain_Analytics_10000.csv')

# Check number of rows and columns
print("Dataset Shape:")
print(df.shape)

# View first 5 rows
print("\nFirst 5 Rows:")
print(df.head())

# Check column names
print("\nColumn Names:")
print(df.columns.tolist())


# Rename columns
df = df.rename(columns={
    'OrderD': 'Order_ID',
    'Orderate': 'Order_Date',
    'Shipmentate': 'Shipment_Date',
    'Deliveryate': 'Delivery_Date',
    'CustomerD': 'Customer_ID',
    'Customeregion': 'Customer_Region',
    'Customerountry': 'Customer_Country',
    'ProductD': 'Product_ID',
    'Productame': 'Product_Name',
    'Productategory': 'Product_Category',
    'SupplierD': 'Supplier_ID',
    'Supplierame': 'Supplier_Name',
    'Supplieregion': 'Supplier_Region',
    'WarehouseD': 'Warehouse_ID',
    'Warehouseocation': 'Warehouse_Location',
    'Transportationode': 'Transportation_Mode',
    'Orderuantity': 'Order_Quantity',
    'Unitrice': 'Unit_Price',
    'Totalost': 'Total_Cost',
    'Shippingost': 'Shipping_Cost',
    'Deliveryimeays': 'Delivery_Time_Days',
    'Inventoryevel': 'Inventory_Level',
    'Ordertatus': 'Order_Status',
    'Profit': 'Profit'
})

# Check the new column names
print("Updated Column Names:")
print(df.columns.tolist())

# Check missing values
print("Missing Values:")
print(df.isnull().sum())

# Check duplicate rows
print("Duplicate Rows:")
print(df.duplicated().sum())



# Convert numeric columns
numeric_columns = [
    'Order_Quantity',
    'Unit_Price',
    'Total_Cost',
    'Shipping_Cost',
    'Delivery_Time_Days',
    'Inventory_Level',
    'Profit'
]

for column in numeric_columns:
    df[column] = df[column].astype(str).str.replace(',', '', regex=False)
    df[column] = pd.to_numeric(df[column], errors='coerce')

# Check data types
print("Updated Data Types:")
print(df.dtypes)




# Convert date columns
df['Order_Date'] = pd.to_datetime(df['Order_Date'])
df['Shipment_Date'] = pd.to_datetime(df['Shipment_Date'])
df['Delivery_Date'] = pd.to_datetime(df['Delivery_Date'])

# Check date data types
print("Date Data Types:")
print(df[['Order_Date', 'Shipment_Date', 'Delivery_Date']].dtypes)




# Remove unnecessary spaces from text columns
text_columns = df.select_dtypes(include='object').columns

for column in text_columns:
    df[column] = df[column].str.strip()

# Standardize Order Status
df['Order_Status'] = df['Order_Status'].str.title()

print("Text data cleaned.")






# Check negative quantity
print("Negative Quantity:")
print((df['Order_Quantity'] < 0).sum())

# Check negative cost
print("Negative Total Cost:")
print((df['Total_Cost'] < 0).sum())

# Check negative delivery days
print("Negative Delivery Days:")
print((df['Delivery_Time_Days'] < 0).sum())

# Check invalid dates
print("Invalid Dates:")
print(df[['Order_Date', 'Shipment_Date', 'Delivery_Date']].isnull().sum())




print("\nFINAL VALIDATION")

print("Rows and Columns:")
print(df.shape)

print("\nColumn Names:")
print(df.columns.tolist())

print("\nMissing Values:")
print(df.isnull().sum().sum())

print("\nDuplicate Rows:")
print(df.duplicated().sum())

print("\nData Types:")
print(df.dtypes)





# Save cleaned dataset
output_file = r"C:\Users\ASUS\Desktop\3\SupplyChain_Cleaned.csv"

df.to_csv(output_file, index=False)

print("\nCleaned dataset saved successfully!")
print(output_file)