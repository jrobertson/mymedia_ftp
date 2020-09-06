#!/usr/bin/env ruby

# file: mymedia_ftp.rb

require 'net/ftp'
require 'fileutils'


class MyMediaFTP < Net::FTP

  def initialize(s=nil, host: '127.0.0.1', user: 'user', password: '1234', 
                 port: 21, debug: false)

    if s then
      
      r = s.match(/(?<user>\w+):(?<password>\w+)@(?<host>[^:]+)(?:\:(?<port>\d+))?/)
      h = r.named_captures.map {|k,v| [k.to_sym, v]}.to_h
      puts 'h: ' + h.inspect if debug
      user, password, host = h.values.take(3)
      port = h[:port] if h[:port]
      
    end
    
    @debug = debug

    @curdir = '/'
    super()
    connect(host, port)
    login(user, password)

  end
  
  def chdir(dir)
    super(dir)
    @curdir = pwd
  end
  
  alias cd chdir

  def cp(src='', dest='', direction=:inbound, &blk)

    return outbound_cp(src, dest) if direction == :outbound
    
    puts 'cp: ' + src.inspect if @debug
    chdir File.dirname(src)
    FileUtils.mkdir_p dest
    Dir.chdir  dest

    files = list_filenames(src)

    puts 'copying ...'

    files.each do |h|

      name, type = h[:name], h[:type]
      
      puts name
      
      if type == :file then
        begin
          getbinaryfile name, name.downcase.gsub(/ +/,'-')
        rescue Net::FTPPermError => e
          puts 'e: ' + e.inspect
        end
      else
        cp_dir(name, &blk)
      end
      blk.call(name, type) if block_given?
    end

  end
  
  def delete(filename)
    super(filename)
    'file deleted'
  end
  
  def list_filenames(s=@curdir+'/*')
    
    if @debug
      puts 'inside list_filenames' 
      puts 's: ' + s.inspect
    end
    
    src = File.dirname(s)

    raw_q = File.basename(s)
    puts 'raw_q: ' + raw_q.inspect if @debug
    
    q = raw_q.gsub('.','\.').gsub('*','.*').gsub('?','.?')\
        .sub(/[^\*\?\.]$/,'.*')

    list(src).inject([]) do |r, x| 

      raw_attr, _, owner, group, filesize, month, day, time, filename = \
          x.split(/ +/,9)
      type = raw_attr =~ /d/ ? :directory : :file
      filename[/^#{q}$/] ? r << {name: filename, type: type} : r
      r
    end

  end
  
  alias ls list_filenames

  def mv(src='', dest='')

    puts 'moving ...'
    cp(src, dest) do |file, type| 
      type == :file ? delete(file) : rmdir(file)
    end

  end
  
  alias rm delete
  
  private
  
  def cp_dir(directory, &blk)
    
    puts 'inside cp_dir: ' + directory.inspect if @debug
    FileUtils.mkdir_p directory
    parent_dir = pwd
    chdir directory
    cp('*', directory, &blk)
    chdir parent_dir
  end
  
  def outbound_cp(src, destination='.')
    
    if File.basename(destination) == '.' then
      destination.sub!(/\.$/, File.basename(src))
    end
    
    putbinaryfile(src, destination)
  end
    
end
