# **** Insert overall script steps here ****

# Get list of unique book titles from Kindle clippings .txt file
titles = File.read("shortclippings.txt").scan(/={10}\n(.*)\n/).flatten.uniq!

# Reset aka wipe the all encompassing highlights file with today's date
today = Time.now.strftime("%Y%m%d")
File.write("All_Kindle_Highlights #{today}.txt","")

# Iterate over each title
# create a file with highlights for each book
# create an all-encompassing highlight file, grouped by book
titles.each { |title| 
	clippings = File.read("shortclippings.txt").scan(
		/#{Regexp.quote(title)}(.*)\n(.*)\n\n(.*)\n=======/).flatten
	highlights = clippings.reject { |clipping| clipping.match(
		/#{Regexp.quote("- Your Highlight")}/) || clipping.length < 2 }
	# write file for each book with associated quotes
	File.write("#{title.strip} #{today}.txt", highlights.join("\n\n"))
	# write file containing all kindle quotes, grouped by book
	# writes in a break/line of ='s between books and then the book's title
	File.write("All_Kindle_Highlights #{today}.txt",
		"="*80  +"\n#{title.strip}\n\n", mode:"a")
	# writes in all the highlights for the given book
	File.write("All_Kindle_Highlights #{today}.txt",
		highlights.join("\n\n") + "\n", mode:"a")
}
