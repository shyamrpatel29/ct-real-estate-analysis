import pandas as pd

# Load the original CSV file
df = pd.read_csv('real5yr_trans.csv')

# Initialize an empty list to collect the new rows
new_rows = []

# Iterate over the rows in the original DataFrame
for _, row in df.iterrows():
    town = row['town']
    # Add the first set (year and change)
    new_rows.append({'Town': town, 'Year': row['year'], 'Transactions': row['transactions']})
    # Add other sets (prev_year and change2, prev2_year and change3, etc.)
    new_rows.append({'Town': town, 'Year': row['prev_year'], 'Transactions': row['prev_transactions']})
    new_rows.append({'Town': town, 'Year': row['prev2_year'], 'Transactions': row['prev2_transactions']})
    new_rows.append({'Town': town, 'Year': row['prev3_year'], 'Transactions': row['prev3_transactions']})
    new_rows.append({'Town': town, 'Year': row['prev4_year'], 'Transactions': row['prev4_transactions']})

# Convert the list of dictionaries to a new DataFrame
new_data = pd.DataFrame(new_rows)

# Save the transformed data to a new CSV file
new_data.to_csv('transformed_transactions.csv', index=False)

print("CSV file transformed successfully!")



