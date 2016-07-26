has_source_changes = !git.modified_files.grep(/Sources/).empty?
has_test_changes = !git.modified_files.grep(/Tests/).empty?
big_pr = lines_of_code > 500
github = env.request_source.client
organization, repository = env.ci_source.repo_slug.split("/")

message "Ahoy, @#{pr_author}!! Thanks for your contribution mate!"

unless github.organization_member?(organization, pr_author)
    message "Hey @#{pr_author}, you're not a member of #{organization} yet. Would you like to join the #{organization} Github organization?\nYou can also join our [Slack](http://slack.zewo.io) and interact with a great community of developers. 😊"
end

if git.modified_files.include? "Package.swift"
    warn "Package.swift was updated"
end

if pr_title.include? "[WIP]"
    warn "PR is classed as Work in Progress"
end

if big_pr
    warn "Big PR"
end

if has_source_changes && !has_test_changes
  warn "Tests were not updated"
end

if pr_body.length < 5
  fail "Please provide a summary in the Pull Request description"
end

if has_source_changes && big_pr && !git.modified_files.include?("CHANGELOG.md")
  warn "Please include a CHANGELOG entry. \nYou can find it at CHANGELOG.md"
end

git.added_files.select {|f| f != "Dangerfile" && File.read(f) =~ /all rights reserved/i}.each {|f| fail("#{f} includes all rights reserved")}
