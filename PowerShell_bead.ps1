
write-host ""

if ($args.count -eq 0) {
    write-host -n "Please specify the file you want to be analyzed: "
    $file = read-host
    write-host ""
}
elseif ($args.count -eq 1) {
    $file = $args[0]
}
elseif ($args.count -ge 2) {
    write-host "Error: Too much argument."
    exit
}

if (! (test-Path $file)) {
    write-host "The file you provided does not exists."
    exit
}

$arrayOfNumbers = @(@(0),@(0),@(0),@(0))
$lineParity = 1
foreach ($line in get-Content -Path $file) {
    $items = $line.split()
    $i=0
    foreach($item in $items) {
        if(! ($item -match "^[+-]?[0-9]+(\.[0-9]*)?$") -or ! ($item -match "^[+-]?[0-9]*(\.[0-9]+)?$")) { continue; }
        else {
            if (([string]($item)).contains(".") -and ($item -match "[+-]?[0-9]*\..*[1-9].*")) { continue ; }
            $par = 2*$lineParity + [System.Math]::abs([int]$item % 2)
            $arrayOfNumbers[$par] += [int]$item
            $i++
        }
    }
    if($i -eq 0) {
        write-host "Error: The file contains an empty line."
        exit
    }
    elseif($i -eq 1) {
        write-host "Error: The file contains a line with less than 2 numbers."
        exit
    }
    $lineParity = 1 - $lineParity
}

for($i=0 ; $i -le 3 ; $i++) {
    write-host "Sum of" `
    $(if ($i % 2 -eq 0) {"even"} else {"odd"}) `
    "numbers in" `
    $(if ($i -le 1) {"even"} else {"odd"}) `
    "lines:" `
    ($arrayOfNumbers[$i] | measure -sum).sum 
}
