titles = File.read("shortclippings.txt").scan(/={10}\n(.*)\n/).flatten
titlelist = titles.uniq

##block iterate through for one file at a time?

titlelist.each { |title| 
	clippings = File.read("shortclippings.txt").scan(/#{Regexp.quote(title)}(.*)\n(.*)\n\n(.*)\n=======/).flatten
	# for testing ##clippings.each { |clip| puts "HERE YARE: #{clip}" }
	highlights = clippings.reject { |clipping| clipping.match(/#{Regexp.quote("- Your Highlight")}/) || clipping.length < 2 }
			#highlights_and_empties = clippings.reject { |clipping| clipping.match(/#{Regexp.quote("- Your Highlight")}/)}
			#highlights = highlights_and_empties.reject { |clips| clips.length < 2}
	today = Time.now.strftime("%Y%m%d")
	File.write("#{title.strip} #{today}.txt", highlights.join("\n\n"))
}


# clippings = File.read("shortclippings.txt").scan(/#{Regexp.quote(titlelist[0])}(.*)\n(.*)\n\n(.*)\n=======/)

# highlights = clippings.reject { |clipping| clipping.match(/#{Regexp.quote("- Your Highlight")}/) || clipping.length < 2 }

# File.write('file_title_stub.txt', highlights.join("\n"))