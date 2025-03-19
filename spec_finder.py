import pandas as pd
csv_path = input("Enter the path to the CSV file: ")

# Load the CSV file with error handling
try:
    df = pd.read_csv(csv_path)
except FileNotFoundError:
    print(f"Error: File '{csv_path}' not found.")
    exit()
except pd.errors.EmptyDataError:
    print("Error: The CSV file is empty.")
    exit()
except pd.errors.ParserError:
    print("Error: Invalid CSV file.")
    exit()

# Verify required columns are present
required_columns = ['Benchmark', 'Base Result', '# Chips', 'Processor']
if not all(col in df.columns for col in required_columns):
    print("Error: Missing required columns in the CSV file.")
    exit()

# Convert 'Base Result' to numeric, handling any non-numeric values
df['Base Result'] = pd.to_numeric(df['Base Result'], errors='coerce')

# Prompt for minimum benchmark points
print("Please enter the minimum base points for each benchmark:")
try:
    min_cint2017 = float(input("CINT2017speed: "))
    min_cfp2017 = float(input("CFP2017speed: "))
    min_cint2017rate = float(input("CINT2017rate: "))
    min_cfp2017rate = float(input("CFP2017rate: "))
except ValueError:
    print("Error: Please enter valid numbers for the minimum points.")
    exit()
# Load the CSV file (replace 'your_file.csv' with your actual file name)
#df = pd.read_csv('cpu2017-results-20250319-034719.csv')

# Ensure the 'Base Result' column is numeric, converting non-numeric values to NaN
#df['Base Result'] = pd.to_numeric(df['Base Result'], errors='coerce')

# Define a function to check if a processor meets all four criteria
def check_criteria(group):
    conditions = [
        ((group['Benchmark'] == 'CINT2017') & (group['Base Result'] >= min_cint2017)).any(),
        ((group['Benchmark'] == 'CFP2017') & (group['Base Result'] >= min_cfp2017)).any(),
        ((group['Benchmark'] == 'CINT2017rate') & (group['Base Result'] >= min_cint2017rate)).any(),
        ((group['Benchmark'] == 'CFP2017rate') & (group['Base Result'] >= min_cfp2017rate)).any()
    ]
    if all(conditions):
        # Get the number of chips (assumed consistent across rows for each processor)
        num_chips = group['# Chips'].iloc[0]
        return pd.Series({'Meets Criteria': True, 'Number of chips': num_chips})
    else:
        return pd.Series({'Meets Criteria': False, 'Number of chips': None})

# Group by 'Processor' and apply the criteria check
result = df.groupby('Processor').apply(check_criteria)

# Filter to keep only processors that meet all criteria
qualifying = result[result['Meets Criteria']]

# Print the qualifying processors with their number of chips
print("Processors meeting all criteria with their number of chips:")
for processor, row in qualifying.iterrows():
    print(f"{processor}: {row['Number of chips']} chips")

    # Ask to save the results for future use
save = input("\nDo you want to save the results to a CSV file? (yes/no): ").strip().lower()
if save == 'yes':
    output_file = input("Enter the output file name: ")
    qualifying.reset_index()[['Processor', 'Number of chips']].to_csv(output_file, index=False)
    print(f"Results saved to {output_file}")
else:
    print("Results not saved.")