# coding: UTF-8

require 'fastercsv'

if ARGV.first.blank?
  puts '参数不对!'
  exit
end

file_name = ARGV.first
puts file_name

i = 0

FasterCSV.foreach(file_name, :headers => true, :header_converters => :symbol) do |line|
  i += 1

  puts "%s=====" % [i, line.inspect]
  hash = line.to_hash
  
  hash[:partner_name] = '请修改'
  hash[:user_id] = User.find_by_realname( hash.delete(:realname).try(:strip) ).try(:id).to_s
  if hash[:user_id].blank?
    puts "用户id找不到=====%s" % hash.inspect
    hash[:user_id] = 10000
  end
  
  hash.each do |k, v|
    if hash[k].blank?
      hash[k] = 0
    end
  end
  
  hash[:online_time] = case hash.delete(:online_time).strip
    when '周一'
      '2012-03-05'
    when '星期一'
      '2012-03-05'
    when '周二'
      '2012-03-06'
    when '星期二'
      '2012-03-06'
    when '周三'
      '2012-03-07'
    when '星期三'
      '2012-03-07'
    when '周四'
      '2012-03-08'
    when '星期四'
      '2012-03-08'
    when '周五'
      '2012-03-09'
    when '星期五'
      '2012-03-09'
    else
      puts "日期不对：=====%s" % hash.inspect
      ''
    end
  
  puts hash.inspect
  Dan.create!(hash)
end