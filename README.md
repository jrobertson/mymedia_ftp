# Introducing the MyMedia FTP gem

    require 'mymedia_ftp'

    ftp = MyMediaFTP.new(host: '192.168.4.177', user: 'user', password: '12345')
    ftp.mv('/Sounds/Digital/*.wav', '/tmp/audio')
    ftp.close


The above example demonstrates files which have a .wav extension within the */Sounds/Digital* directory being moved (downloaded) to the local directory */tmp/audio*.


## Resources

* ?mymedia_ftp https://rubygems.org/gems/mymedia_ftp?
* ?Using the net/ftp gem http://www.jamesrobertson.eu/snippets/2015/sep/24/using-the-net-ftp-gem.html?

ftp mymediaftp gem

