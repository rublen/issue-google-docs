# Run this file in terminal like this:
# $ ruby redmine/plugins/issue_docs/lib/issue_docs/list_and_delete_files_on_google_disk.rb
# Keep in mind that this script depends on service account credentials (line 12, file 'service-account-creds.json')

require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

scope = 'https://www.googleapis.com/auth/drive'

authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open(File.join(__dir__, 'service-account-creds.json')),
  scope: scope)

authorizer.fetch_access_token!

Drive = Google::Apis::DriveV3 # Alias the module
drive = Drive::DriveService.new
drive.authorization =  authorizer # See Googleauth or Signet libraries

files = drive.list_files.files
size = files.size

puts "\n. . . GOOGLE DISK . . ."
puts "-----------------------"
puts "\nThere are #{size} files on the Google Disk"

n_start = 0
files_for_del = []

while files[n_start] do
  n_last = n_start + 20 < size ? n_start + 20 : size
  puts "\n== LIST of Google Docs: _#{n_start}..#{n_last - 1}_:"
  puts

  (n_start...n_last).each do |i|
    puts "#{i}: #{files[i].name}, id - #{files[i].id}"
  end

  puts "\n!! Enter the numbers of files for deleting (e.g., 3 4 9 11)
  and/or Push 'Enter' for the next page
    or type 'all' for deleting all files on this page"

  answer = gets.chomp

  if answer.downcase == 'all'
    files_for_del += (n_start...n_last).to_a
  elsif answer
    files_for_del += answer.split.map(&:to_i)
  end
  n_start = n_last
end

files_for_del.each { |i| drive.delete_file(files[i].id) }

puts "Were deleted: #{files_for_del}"
