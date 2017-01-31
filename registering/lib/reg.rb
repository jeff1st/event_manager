require 'csv'
require 'date'

def clean_phones(phone)
  phone = phone.gsub(/[^0-9]/, '')
  return "bad phone_number" if phone.length > 11 || phone.length < 10
  return "bad phone_number" if phone.length == 11 && phone[0] != "1"
  return phone[1..10] if phone.length == 11 && phone[0] == "1"
  return phone
end

def clean_date(date)
  date1 = date.split[0]
  date2 = date.split[1]
  date2 = date2.gsub!(/^(\d:)(\d+)/, '0\1\2') if date2[1] == ":"
  return date1.split('/')[2] + '/' + date1.split('/')[0] + '/' + date1.split('/')[1] + " " + date2
end

def datetime_mgmt(datetime)
  comprehensive_date = DateTime.parse(datetime)
  return comprehensive_date
end

def fill_hours(datetime, hours)
  hours[datetime.hour.to_s] += 1
end

def fill_days(datetime, days)
  days[datetime.wday] += 1
end

def find_prefered_hour(data)
  top = 0
  res = ""
  data.each do |k, v|
    (top = v; res = k) if v > top
  end
  return res
end

def find_prefered_day(data)
  top = 0
  res = ""
  data.each do |k, v|
    (top = v; res = k) if v > top
  end
  return res
end

puts "starting analyse"
hours = Hash[(0..23).map { |hour| [hour.to_s, 0] }]
days = Hash[(0..6).map { |day| [day, 0] }]
named_day = {0=>"Sunday", 1=>"Monday", 2=>"Tuesday", 3=>"Wednesday", 4=>"Thursday", 5=>"Friday", 6=>"Saturday"}

handler = CSV.read('full.csv', headers: true, header_converters: :symbol)
handler.each do |line|
  next if line[:first_line]
  phones = clean_phones(line[:homephone])
  datetime = datetime_mgmt(clean_date(line[:regdate]))
  fill_hours(datetime, hours)
  fill_days(datetime, days)
end

prefered_hour = find_prefered_hour(hours)
prefered_day = find_prefered_day(days)
puts prefered_hour
puts named_day[prefered_day]
