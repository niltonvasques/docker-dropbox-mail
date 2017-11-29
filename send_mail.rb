#!/usr/bin/env ruby
# Author: Nilton Vasques <nilton.vasques{at}gmail.com>
# Description: This script upload a file to dropbox and send a mail with this file link
#
# SYNOPSIS
# docker run -it --rm -e FROM='test@gmail.com' -e TO='test@gmail.com' -e SUBJECT='topic' -e DROPBOX_ACCESS_TOKEN='token' -e DROPBOX_FOLDER='folder' -e FILE_NAME='test.file' -v $PWD:/tmp/ --name mail-app mail-dropbox-storage

require 'mail'
require 'awesome_print'
require 'dropbox'

DEFAULT_BODY_FILE = '/tmp/body'

# mail settings
$from = ENV['FROM']
$to = ENV['TO']
$subject = ENV['SUBJECT']
$mail_pass = ENV['MAIL_PASS']
$file_name = ENV['FILE_NAME']
$dropbox_folder = ENV['DROPBOX_FOLDER']
$access_token = ENV['DROPBOX_ACCESS_TOKEN']

if File.exists?(DEFAULT_BODY_FILE)
  $body = File.read(DEFAULT_BODY_FILE)
else
  $body = ENV['BODY']
end

apk = File.new($file_name)
dbx = Dropbox::Client.new($access_token)
apk_uploaded = dbx.upload("#{$dropbox_folder}/#{$file_name}", apk)

$file_link = dbx.get_temporary_link(apk_uploaded.path_display).last

$body = $body.gsub(/\[LINK\]/, $file_link)
ap $body

options = {
  address: "smtp.gmail.com",
  port: 587,
  user_name: $from,
  password: $mail_pass,
  authentication: "plain",
  enable_starttls_auto: true
}

Mail.defaults do
  delivery_method :smtp, options
end

puts "Send mail..."
mail = Mail.new do
  from $from
  to $to
  subject $subject
  body $body
  #add_file './code/app/app-release.file'
  #add_file 'app-release'
end

mail.deliver!
puts "done!"
