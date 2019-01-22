# dap
Deckset Auto Preview

## Introduction
[Deckset](https://www.deckset.com) is a great applicaton for creating slide decks on macOS.
However, what if you need to edit a presentation while on your phone/tablet or on a different computer running Linux or Windows?
Up until now, you would be out of luck.

Deckset Auto Preview (dap) attempts to solve this issue.
It monitors a directory tree on your Mac for any changes to markdown presentation files.
When it detects a change, it launches Deckset and exports the presentation as a PDF (it actually creates two copies: one with speaker notes and one without).
The PDF is then converted to a [Keynote](https://www.apple.com/keynote/) '09 presentation using [PDF to Keynote](https://www.cs.hmc.edu/~oneill/freesoftware/pdftokeynote.html)
Finally, proper Keynote and PowerPoint presentations are created via Keynote.
These presentations will include all speaker notes present in the original Deckset presentation.

## Use Cases
### Editing from a mobile device
I will frequently work from my iPhone/iPad.
Thanks to iCloud, I always have access to my Deckset presentations.
With dap, I can now edit the Markdown in my favoritem mobile editor, wait a minute, and I will have a preview ready to go.

### Quick File Conversions
It is quite common to want to provide a presentation in multiple file formats.
This is usually done to support easy viewing in various applications.
dap will automatically produce Powerpoint and Keynote presentation files, as well as a PDF.
This trio of formats should be viewable by most users regardless of platform.

### Access to better presentation tools
While Deckset provides a very nice presentation interface, it lacks some features that an application like Keynote provides.
For example, Keynote supports using an iPhone as a second screen (for viewing speaker notes) and a remote.
It also supports presenting directly from an iPhone/iPad without the need for a computer.
By using dap to convert your presentation to Keynote, you get to use Deckset for creating your presentation and Keynote for presenting.

## Caveats
The Keynote and Powerpoint presentations are created from the exported PDF files.
This means it is not possible to edit the text/images contained in the slides using one of these applications.
You *must* continue to use Deckset for editing.

## Dependencies
### Deckset
[Deckset](https://www.deckset.com) is a tool for creating slide decks from mardkwon files.
You likely already have it installed if you are looking at dap.

### fswatch
[fswatch](https://github.com/emcrisostomo/fswatch) is used to monitor a directory tree for changes.
This allows quickly re-generating presentation files only when necessary.
You can install it with: `brew install fswatch`

### PDF to Keynote
[PDF to Keynote](https://www.cs.hmc.edu/~oneill/freesoftware/pdftokeynote.html) is responsible for converting the PDF file exported from Deckset into a Keynote '09 presentation file.
You can install it with: `brew cask install nhandler/tap/pdf-to-keynote`

### Keynote
[Keynote](https://www.apple.com/keynote/) is used to convert the presentation produced by PDF to Keynote into a modern Keynote presentation that contains speaker notes.
It also handles exporting a Powerpoint version of the presentation.
This likely came installed on your Mac.

## Installation
You can install dap with: `brew install nhandler/tap/dap`
You will need to run `sudo brew services start dap` following installation to start the launchd service that will run in the background.

## Configuration
By default, dap will monitor `~/Documents/Presentations` recursively for any `.md` files.
This directory can be adjusted with `defaults write com.nhandler.dap  presentationDirectory -string ~/Documents/Presentations` (replace `~/Documents/Presentations` with your new path).
Generated PDF/Keynote/Powerpoint files will be created in the same directory as their corresponding markdown file.
