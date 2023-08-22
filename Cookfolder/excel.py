import openpyxl

# List of text file names
text_files = ['text1.txt', 'text2.txt']  # Add more file names as needed

# Create a new Excel workbook
workbook = openpyxl.Workbook()
# Loop through the text files and add their contents to separate sheets
for i, text_file in enumerate(text_files):
    sheet = workbook.create_sheet(title=f'Sheet{i+1}')
    with open(text_file, 'r') as file:
        content = file.read()
        sheet['A1'] = content

# Remove the default sheet created by openpyxl
default_sheet = workbook['Sheet']
workbook.remove(default_sheet)

# Save the workbook
excel_file_name = 'text_contents.xlsx'
workbook.save(excel_file_name)
print(f'Excel file "{excel_file_name}" created successfully.')
