wBook, buttonClose, buttonPrev, buttonNext, page, cover, pgNumber = nil
pageNumber = 0
totalPages = 0

function createBook( bookName, bookTitle )
	
	-- Window variables
	local Width = 460
	local Height = 520
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wbook) then
		
		pageNumber = 0
		
		-- Create the window
		wBook = guiCreateWindow(X, Y, Width, Height, bookTitle, false)
		
		-- Create close, previous and Next Button
		buttonPrev = guiCreateButton( 0.85, 0.25, 0.14, 0.05, "Prev", true, wbook)
		addEventHandler( "onClientGUIClick", buttonPrev, prevButtonClick, false )
		guiSetVisible(buttonPrev, false)

		buttonClose = guiCreateButton( 0.85, 0.45, 0.14, 0.05, "Close", true, wbook)
		addEventHandler( "onClientGUIClick", buttonClose, closeButtonClick, false )	
		
		buttonNext = guiCreateButton( 0.85, 0.65, 0.14, 0.05, "Next", true, wbook)
		addEventHandler( "onClientGUIClick", buttonNext, nextButtonClick, false )

		showCursor(true)
		
		local xml = xmlLoadFile( bookName ..".xml" ) -- load the xml for future reference.
		
		-- the pages
		page = guiCreateLabel(0.01, 0.05, 0.8, 0.95, "", true, wbook) -- create the page but leave it blank.
		guiLabelSetHorizontalAlign (page, "left", true)
		cover = guiCreateStaticImage ( 0.01, 0.05, 0.8, 0.95, "books/".. bookName ..".png", true, wbook ) -- display the cover image.
		pgNumber = guiCreateLabel(0.95, 0.0, 0.05, 1.0, "",true, wbook) -- page number at the bottom.
		
		local xml = xmlLoadFile( "books/"bookName ..".xml" ) 	-- load the xml.
		local numpagesNode = xmlFindChild(xml,"numpages")	-- get the children of the root node "content". Should return the "page"..pageNumber nodes in a table.
		totalpages = xmlNodeGetValue("numpagesNode")
	end
end
addEvent("showBook", true)
addEventHandler("showBook", getRootElement(), createBook)

--The "prev" button's function
function prevButtonClick( )
	
	pageNumber = pageNumber - 1
	
	if (pageNumber == 0) then
		guiSetVisible(buttonPrev, false)
	else
		guiSetVisible(buttonPrev, true)
	end
	
	if (pageNumber == totalPages) then
		guiSetVisible(buttonNext, false)
	else
		guiSetVisible(buttonNext, true)
	end
	
	if (pageNumber>0) then -- if the new page is not the cover
		
		local pageNode = xmlFindChild (xml, "page", pageNumber+1)
		local contents = xmlNodeGetValue( pageNode )
		
		guiSetText (page, contents)
		guiSetText (pgNumber, pageNumber)
	
	else -- if we are moving to the cover
	
		guiSetVisible(cover, true)
		guiSetText (page, "")
		guiSetText (pgNumber, "")
	end
end

--The "next" button's function
function nextButtonClick( )
	
	pageNumber = pageNumber + 1
	
	if (pageNumber == 0) then
		guiSetVisible(buttonPrev, false)
	else
		guiSetVisible(buttonPrev, true)
	end
	
	if (pageNumber == totalPages) then
		guiSetVisible(buttonNext, false)
	else
		guiSetVisible(buttonNext, true)
	end
	
	if (pageNumber-1==0) then -- If the last page was the cover page remove the cover image.
		guiSetVisible(cover, false)
	end
	
	local pageNode = xmlFindChild (xml, "page", pageNumber+1)
	local contents = xmlNodeGetValue( pageNode )
	guiSetText ( page, contents )
	guiSetText ( pgNumber, pageNumber )
end

-- The "close" button's function
function closeButtonClick( )
	pageNumber = 0
	totalPages = 0
	destroyElement ( buttonClose )
	destroyElement ( buttonPrev )
	destroyElement ( buttonNext )
	destroyElement ( page)
	destroyElement ( cover)
	destroyElement ( pgNumber )
	destroyElement ( wbook )
	buttonClose = nil
	buttonPrev = nil
	buttonNext = nil
	page = nil
	cover = nil
	pgNumber = nil
	wbook = nil
	showCursor(false)
	xmlUnloadFile(xml)
end
