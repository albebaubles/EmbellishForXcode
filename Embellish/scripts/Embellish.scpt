use scripting additions
use framework "Foundation"

on insert()
set insertText to the text returned of (display dialog "Enter the text to Insert" with title "EmbellishXcode" default answer "")
 set the clipboard to insertText as string
-- return insertText
end insert

on replace()
set originText to the text returned of (display dialog "Replace occurance of string?" with title "EmbellishXcode" default answer "")
set replaceText to the text returned of (display dialog "Replace occurance of " & originText & " with?" with title "EmbellishXcode" default answer "")

 set the clipboard to originText & "ℹ️" & replaceText as string
-- return originText & "ℹ️" & replaceText
end replace
