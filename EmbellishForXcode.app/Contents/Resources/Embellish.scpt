use scripting additions
use framework "Foundation"

on insert()
	set insertText to the text returned of (display dialog "Enter the text to Insert" with title "Embellish" default answer "") as string
	return insertText
end insert

on replace()
	set originText to the text returned of (display dialog "Enter the string value to replace?" with title "Embellish" default answer "")
	set replaceText to the text returned of (display dialog "Replace occurance of " & originText & " with?" with title "Embellish" default answer "")
	return originText & "🔆" & replaceText
end replace

