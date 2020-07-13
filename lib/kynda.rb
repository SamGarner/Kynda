require "kynda/version"

# Get list of unique book titles from Kindle clippings .txt file
# Create empty file that will contain highlights from every book
book_title_regexp = /={10}\r\n(.*)\r\n/
kindle_clippings = "My Clippings"
titles = File.read(kindle_clippings).scan(book_title_regexp).flatten.uniq!
today = Time.now.strftime("%Y%m%d")
all_highlights_filename = "All_Kindle_Highlights #{today}.txt"

# Reset/wipe the all encompassing highlights file for today's date
File.write(all_highlights_filename,"")

# Iterate over each title
# create a file with highlights for each book
# append (grouped) highlights for each book to the all-encompassing highlight file
titles.each { |title|	
	# If loop added because every so often, was getting a book title with
	# leading spaces - which lead to some repetitive files and highlights
	# problem child: Amsterdam: A History of the World's Most Liberal City (Shorto, Russell)
	if title[0] =~ /[\w]/
		corrected_title = title
	else
		corrected_title = title[1..-1]
	end

	# 'clippings' pulls the text between the line containing the title and author 
	# and the === break line before the next highlight. This returns one 
	# match listing the page location and date of the highlight, one match of an 
	# empty line and one match with the desired highlighted conent (pulled out 
	# into 'highlights' variable) 
	clippings = File.read(kindle_clippings).scan(
		/#{Regexp.quote(corrected_title)}(.*)\r\n(.*)\r\n\r\n(.*)\r\n=======/).flatten
	highlights = clippings.reject { |clipping| clipping.match(
		/#{Regexp.quote("- Your Highlight")}/) || clipping.length < 2 }
	# write file for each book with associated quotes, tagged with today's date
	File.write("#{corrected_title.strip} #{today}.txt", highlights.join("\n\n"))
	# write file containing all quotes, grouped by book, tagged w/today's date
	# writes in a break/line of ='s between books and then the book's title
	File.write(all_highlights_filename,
		"="*80  +"\n#{corrected_title.strip}\n\n", mode:"a")
	# writes in all the highlights for the given book
	File.write(all_highlights_filename,
		highlights.join("\n\n") + "\n", mode:"a")
	}
