param (
    [string]$InputCsvFile1,
    [string]$InputCsvFile2
)

# Check if the input files exist
if (-Not (Test-Path $InputCsvFile1)) {
    Write-Host "The file $InputCsvFile1 does not exist."
    exit
}
if (-Not (Test-Path $InputCsvFile2)) {
    Write-Host "The file $InputCsvFile2 does not exist."
    exit
}

# Read the CSV files
$csvContent1 = Import-Csv -Path $InputCsvFile1
$csvContent2 = Import-Csv -Path $InputCsvFile2

# Convert CSV content to string arrays for comparison
$csvLines1 = $csvContent1 | ConvertTo-Csv -NoTypeInformation
$csvLines2 = $csvContent2 | ConvertTo-Csv -NoTypeInformation

# Find differences
$diff1 = Compare-Object -ReferenceObject $csvLines1 -DifferenceObject $csvLines2 -IncludeEqual -PassThru | Where-Object { $_.SideIndicator -eq "<=" }
$diff2 = Compare-Object -ReferenceObject $csvLines2 -DifferenceObject $csvLines1 -IncludeEqual -PassThru | Where-Object { $_.SideIndicator -eq "=>" }

# Get current date and time for the output file name
$currentDateTime = Get-Date -Format "yyyy-MM-dd-HH-mm"
$outputFileName = "CsvDiff_$currentDateTime.txt"

# Write differences to the output file
foreach ($line in $diff1) {
    Add-Content -Path $outputFileName -Value "$InputCsvFile1, $line"
}
foreach ($line in $diff2) {
    Add-Content -Path $outputFileName -Value "$InputCsvFile2, $line"
}

Write-Host "Differences have been written to: $outputFileName"
