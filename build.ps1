# get current script path
$HodorPath = $PSScriptRoot

# extract Addon version from HodorReflexes.txt
$HodorVersionFileData = Get-Content $HodorPath\HodorReflexes.txt | Where-Object { $_.Contains("## Version: ") }
$HodorVersion =  $HodorVersionFileData.Split(" ")[2]

# create zip filename & destination
$parentPath = (Get-Item $PSScriptRoot).parent.FullName
$zipFileName = "HodorReflexes-$HodorVersion-public.zip"
$zipFilePath = "$parentPath\$zipFileName"

$buildFilesPath="$parentPath\build\HodorReflexes"
$arguments = @("/E", "/R:5", "/W:5", "/TBD", "/NP", "/V")
$excludedFolders = @("/XD", "$HodorPath\.git", "$HodorPath\.idea")
$excludedFiles = @("/XF", "$HodorPath\.gitignore", "$HodorPath\build.ps1")

$cmdArgs = @("$HodorPath","$buildFilesPath",$arguments,$excludedFolders,$excludedFiles)
robocopy @cmdArgs
echo "created buildfiles at $buildFilesPath"

# create archive
echo "creating $zipFilePath"

Compress-Archive -Path $buildFilesPath -DestinationPath $zipFilePath -CompressionLevel Fastest -Force
echo "finished building"

Remove-Item -Recurse $parentPath\build
echo "deleted buildfiles from $buildFilesPath"