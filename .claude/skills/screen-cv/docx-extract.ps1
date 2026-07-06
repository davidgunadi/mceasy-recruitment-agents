<#
.SYNOPSIS
  Extract plain text from a .docx file without Python (Windows fallback).

.DESCRIPTION
  Reads word/document.xml directly out of the docx zip archive and joins the
  text runs paragraph by paragraph. Used by the screen-cv skill when neither
  pandoc nor python3 is available on the machine.

.EXAMPLE
  powershell -NoProfile -File docx-extract.ps1 "<file>.docx"
#>
param([Parameter(Position = 0, Mandatory = $true)][string]$Path)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$resolved = (Resolve-Path -LiteralPath $Path).Path
$zip = [System.IO.Compression.ZipFile]::OpenRead($resolved)
try {
    $entry = $zip.GetEntry('word/document.xml')
    if (-not $entry) { throw "word/document.xml not found in $Path" }
    $reader = New-Object System.IO.StreamReader($entry.Open())
    try {
        [xml]$xml = $reader.ReadToEnd()
    } finally {
        $reader.Dispose()
    }
} finally {
    $zip.Dispose()
}

$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')

$paragraphs = $xml.SelectNodes('//w:body/w:p', $ns)
foreach ($p in $paragraphs) {
    $texts = $p.SelectNodes('.//w:t', $ns)
    $line = -join ($texts | ForEach-Object { $_.InnerText })
    Write-Output $line
}
