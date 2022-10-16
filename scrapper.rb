require 'rest-client'
require 'json'

headers = {
  "Accept" => "application/vnd.github+json",
  "Authorization" => "Bearer #{ENV["TOKEN"]}"
}

def fetch_results(headers, page)
  response = RestClient.get("https://api.github.com/search/repositories", {headers: headers, params: { q: 'decidim', page: page, per_page: 100 }})
  JSON.parse(response.body)
end

content = %Q{# DICE
Decidim International Community Ecosystem

This is a list of all decidim related repositories found on github.

Please check additional pages to properly see a classification
* [Modules](modules.md)
* [Installations](instaces.md)

| Repository | Watchers | Forks | Last push | description |
|---|---|---|---|---|
}

page = 0

loop do
  page += 1
  results = fetch_results(headers, page)
  break if results["items"].size == 0
  results["items"].each do |row|
    content << "| [#{row["name"]}](#{row["html_url"]}) |#{row["watchers_count"]}|#{row["forks"]}|#{row["pushed_at"]}|#{row["description"]}|\n"
  end
end

File.open("README.md", 'w') { |file| file.write(content) }