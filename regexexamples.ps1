#   Character Escapes

[regex]::Match('*+test?', '\?') #
[regex]::Match('*+test?', '\+') #
[regex]::Match('*+test?', '\*') #

[regex]::Match('test.test', '\.') #


#   Character Classes

[regex]::Match('this is a test', '[a]') #
[regex]::Match('this is a test', '[at]') #

[regex]::Match('this is a test', '[a-z]') #
[regex]::Match('zthis is a test', '[a-z]') #

[regex]::Match('this is a test', '[^a-z]') #
[regex]::Match('thisisatest', '[^a-z]') #

[regex]::Match('this is a test', '.') #

# unicode catagories

[regex]::Match('ДЖames', '\p{IsCyrillic}')

[regex]::Match('ДЖames', '\P{IsCyrillic}')

[regex]::Match('ᎹᏜ', '\p{IsCherokee}')

[regex]::Match('കുശു', '\p{IsMalayalam}')

#   Character Escapes

[regex]::Match('this is a test', '\w')  # \w	Matches any word character.

[regex]::Match('this is a test', '\s')  #  \s	Matches any white-space character.

[regex]::Match('this is a test', '\d')  #   \d	Matches any decimal digit.

[regex]::Match('313-621-4620', '\d')  #   \d	Matches any decimal digit.

#  Anchors

[regex]::Match('313-621-4620', '^3')  #  The match must start at the beginning of the string or line.

[regex]::Match('313-621-4620', '0$')  #  The match must occur at the end of the string or before \n at the end of the line or string.

$str = 'this is a `
        multi line string'

[regex]::Match( $str, '\n')

#  Grouping Constructs

$myMatch = [regex]::Match('313-621-4620', '(20$)')
$myMatch.Groups[1].Value

$myMatch = [regex]::Match('313-621-4620', '(\d\d\d)')
$myMatch.Groups[1].Value


# named capture groups

$context = Get-azurermcontext
$str = $context.Name

[regex]$rx = "(?<subname>\S+)\s\-\s(?<guid>\S+)"

$rx.Match($str)

$rx.Match($str).Groups.Name

for ($i = 0; $i -lt $rx.Match($str).Groups.Count; $i++)  {
    $rx.Match($str).Groups[$i].Value
}

# backreferences in the pattern

$in_str = "He said that that was the the correct answer to that question."

$pattern = "(that)\s(\1).+(\2)"

[regex]$regexp = $pattern

$regexp.Match($in_str)

# quantifiers

#    *	Matches the previous element zero or more times.

[regex]::Matches('this is a test', 't*')

#    +	Matches the previous element one or more times.

[regex]::Matches('this is a test', '[t]+')

#    ?	Matches the previous element zero or one time.

[regex]::Matches('es', 't?')


#    { n, m }	Matches the previous element between n and m times.


$str = 'this is a string'

[regex]::Match( $str, 's{1,2}')

[regex]::Match( $str, 't*?')

#   Alternation Construct

[regex]::Match( $str, 's|t')

[regex]::Matches( $str, 's|t')

$WarAndPeaceString = Get-Content C:\temp\war_and_peace_tolstoy.txt -Raw

[regex]::matches($WarAndPeaceString,”Borís”).count

$WarAndPeaceString -match '\.'

[regex]::matches($WarAndPeaceString,”Natasha”).count

[regex]::matches($WarAndPeaceString,”Natásha”).count 

