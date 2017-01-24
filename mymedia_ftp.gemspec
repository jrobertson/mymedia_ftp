Gem::Specification.new do |s|
  s.name = 'mymedia_ftp'
  s.version = '0.1.1'
  s.summary = 'A MyMedia FTP client which uses Net/FTP.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/mymedia_ftp.rb']
  s.signing_key = '../privatekeys/mymedia_ftp.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/mymedia_ftp'
end
