# get current script path
$HodorPath = $PSScriptRoot

# extract Addon version from HodorReflexes.txt
$HodorVersionFileData = Get-Content $HodorPath\HodorReflexes.txt | Where-Object { $_.Contains("## Version: ") }
$HodorVersion =  $HodorVersionFileData.Split(" ")[2]

# create filename & destination
$AddonPath = (get-item $PSScriptRoot).parent.FullName
$fileName = "HodorReflexes-$HodorVersion-public.zip"
$destination = "$AddonPath\$fileName"

# exclusion rules. Can use wild cards (*)
$exclude = @("build.ps1",".git",".idea")
# get files to compress using exclusion filer
$files = Get-ChildItem -Path $HodorPath -Exclude $exclude

# create archive
echo "creating $fileName"
Compress-Archive -Path $files -DestinationPath $destination -CompressionLevel Fastest -Force
echo "finished building"