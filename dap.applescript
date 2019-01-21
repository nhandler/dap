#!/usr/bin/env osascript

on run argv
	if (count of argv) ≠ 1 then
		error "Usage: ./deckset_auto_preview " & item 1 of argv & "<deckset_markdown_path>" & count of argv
	end if

	set presentation_path to item 1 of argv
	set presentation_file to POSIX file presentation_path
	
	tell application "Finder"
		if not (exists presentation_file) then
			error "Error: Presentation (" & presentation_path & ") does not exist!"
		end if
	end tell
	
	try
		tell application "Deckset"
			activate
			open presentation_path
			set presentation_name to text 1 through -4 of presentation_path

			tell the first document
				set deckset_notes to the notes of every slide
				export to presentation_name & ".pdf" as "PDF" with printAllSteps
				export to presentation_name & "_notes.pdf" as "PDF" with printAllSteps and includePresenterNotes
			end tell
			quit
		end tell
	on error the errMsg number the errorNumber
		tell application "Deckset" to quit
		return errMsg & "(" & errorNumber & ")"
	end try

	set keynote_path to presentation_name & ".key"
	set keynote_file to POSIX file keynote_path
	tell application "Finder"
		if exists keynote_file then
			delete keynote_file
		end if
	end tell

	try
		tell application "PDF to Keynote"
			activate
			open presentation_name & ".pdf"
			quit
		end tell
	on error the errMsg number the errorNumber
		tell application "PDF to Keynote" to quit
		error errMsg number errorNumber
	end try

	try
		tell application "Keynote"
			activate
			open keynote_file
			if not (exists document 1) then error "Failed to open Keynote presentation"
			tell the front document
				set the slide_count to the count of (slides whose skipped is false)

				if the (count of deckset_notes) is greater than the slide_count then
					error "There are more presentation notes than slides!"
				else if the (count of deckset_notes) is less than the slide_count then
					error "There are fewer presentation notes than slides!"
				end if

				set keynote_slides to (every slide of it whose skipped is false)

				repeat with i from 1 to the count of keynote_slides
					set current_slide to item i of keynote_slides
					set the presenter notes of current_slide to item i of deckset_notes
				end repeat
			end tell

			export front document to POSIX file (presentation_name & ".ppt") as Microsoft PowerPoint

		        tell application "System Events"
				tell process "Keynote"
					set frontmost to true
					delay 2
					click menu item "Save" of menu of menu bar item "File" of menu bar 1
				end tell
				keystroke return
			end tell

			quit
		end tell
	on error the errMsg number the errorNumber
		tell application "Keynote" to quit
		error errMsg number errorNumber
	end try
end run
