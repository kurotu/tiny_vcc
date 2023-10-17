# Generate GUIDs
$PRODUCT_CODE = [guid]::NewGuid().ToString().ToUpper()
$PACKAGE_CODE = [guid]::NewGuid().ToString().ToUpper()

# Replace GUIDs in vdproj file
$FILE = "installer\TinyVccInstaller\TinyVccInstaller\TinyVccInstaller.vdproj"
(Get-Content $FILE) | Foreach-Object { $_ -replace """ProductCode"" = ""8:{.*}""", """ProductCode"" = ""8:{$PRODUCT_CODE}""" } | Set-Content -Encoding utf8bom $FILE
(Get-Content $FILE) | Foreach-Object { $_ -replace """PackageCode"" = ""8:{.*}""", """PackageCode"" = ""8:{$PACKAGE_CODE}""" } | Set-Content -Encoding utf8bom $FILE
