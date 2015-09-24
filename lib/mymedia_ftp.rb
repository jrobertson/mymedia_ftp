#!/usr/bin/env ruby

# file: mymedia_ftp.rb

require 'net/ftp'
require 'fileutils'


class MyMediaFTP < Net::FTP

  def initialize(host: '127.0.0.1', user: 'user', password: '1234')

    @curdir = Dir.pwd
    super()
    connect(host, 21)
    login(user, password)

  end

  def cp(src='', dest='')

    chdir File.dirname(src)
    FileUtils.mkdir_p dest
    Dir.chdir  dest

    files = list_filenames(src)

    puts 'copying ...'

    files.each do |x|

      puts x
      getbinaryfile x, x.downcase.gsub(/ +/,'-')
      yield(x) if block_given?
    end

  end


  def mv(src='', dest='')

    puts 'moving ...'
    cp(src, dest) {|file| delete file }


  end

  private

  def list_filenames(src)

    raw_q = File.basename(src)

    q = raw_q.gsub('.','\.').gsub('*','.*').gsub('?','.?')

    list.inject([]) do |r, x| 

      filename = x.split(/ +/,9).last
      filename[/^#{q}$/] ? r << filename : r
    end

  end
  
end
