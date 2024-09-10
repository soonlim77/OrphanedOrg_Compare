param (
    [string]$InputCsvFileName
)

# Check if the input file exists
if (-Not (Test-Path $InputCsvFileName)) {
    Write-Host "The file $InputCsvFileName does not exist."
    exit
}

# Read the CSV file
$csvContent = Import-Csv -Path $InputCsvFileName

# Sort the CSV content by the first column
$sortedContent = $csvContent | Sort-Object -Property $csvContent[0].PSObject.Properties.Name

# Create the output file name
$outputFileName = [System.IO.Path]::GetFileNameWithoutExtension($InputCsvFileName) + "_Sorted" + [System.IO.Path]::GetExtension($InputCsvFileName)

# Export the sorted content to the new CSV file
$sortedContent | Export-Csv -Path $outputFileName -NoTypeInformation

Write-Host "Sorted CSV file has been created: $outputFileName"
