# **** Insert overall script steps here ****

# Get list of unique book titles from Kindle clippings .txt file
book_title_regexp = /={10}\r\n(.*)\r\n/
kindle_clippings = "My Clippings"
titles = File.read(kindle_clippings).scan(book_title_regexp).flatten.uniq!
today = Time.now.strftime("%Y%m%d")
all_highlights_filename = "All_Kindle_Highlights #{today}.txt"

	#titles = File.read("My Clippings").scan(/={10}\r\n(.*)\r\n/).flatten.uniq!

# Reset aka wipe the all encompassing highlights file with today's date
File.write(all_highlights_filename,"")

# Iterate over each title
# create a file with highlights for each book
# create an all-encompassing highlight file, grouped by book
titles.each { |title| 
	clippings = File.read(kindle_clippings).scan(
		/#{Regexp.quote(title)}(.*)\r\n(.*)\r\n\r\n(.*)\r\n=======/).flatten
	highlights = clippings.reject { |clipping| clipping.match(
		/#{Regexp.quote("- Your Highlight")}/) || clipping.length < 2 }
	# write file for each book with associated quotes
	File.write("#{title.strip} #{today}.txt", highlights.join("\n\n"))
	# write file containing all kindle quotes, grouped by book
	# writes in a break/line of ='s between books and then the book's title
	File.write(all_highlights_filename,
		"="*80  +"\n#{title.strip}\n\n", mode:"a")
	# writes in all the highlights for the given book
	File.write(all_highlights_filename,
		highlights.join("\n\n") + "\n", mode:"a")
	}

# have 'kindle_clippings' variable able to accept an input - would rather enforce default name
