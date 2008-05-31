require '../lib/date_recur.rb'

def test(exp)
  p exp ? 'pass' : 'fail'
end

# tests

GENERAL_DATE = Date.civil(2008,05,29)

p "Every 2 days"
dates = GENERAL_DATE.recur('daily','2')
test(dates[0] == GENERAL_DATE)
test(dates[1] == GENERAL_DATE + 2)
test(dates[7] == GENERAL_DATE + 14)
test(dates.last == Date.civil(2009,5,28))

p "Every week on the same day"
dates = GENERAL_DATE.recur('weekly','1')
test(dates[0] == GENERAL_DATE)
test(dates[1] == GENERAL_DATE + 7)

p "Every 1 week on wednesday"
dates = GENERAL_DATE.recur('weekly','1:0001')
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2008,6,4))
test(dates[2] == Date.civil(2008,6,11))

p "Every 2 weeks on monday and wednesday"
dates = GENERAL_DATE.recur('weekly','2:0101',Date.civil(2008,9,18))
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2008,6,9))
test(dates[2] == Date.civil(2008,6,11))
test(dates.last == Date.civil(2008,9,17))

p "Every week on Saturday and Sunday"
dates = GENERAL_DATE.recur('weekly','1:1000001')
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2008,5,31))
test(dates[2] == Date.civil(2008,6,1))

p "Every three months"
dates = Date.civil(2008,1,1).recur('monthly','3:1')
test(dates[0] == Date.civil(2008,1,1))
test(dates[1] == Date.civil(2008,4,1))

p "Every month on the 1st and 15th"
dates = GENERAL_DATE.recur('monthly','1:100000000000001')
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2008,6,1))
test(dates[2] == Date.civil(2008,6,15))
test(dates.last == Date.civil(2009,5,15))

p "Every second month on the 1st and 15th"
dates = GENERAL_DATE.recur('monthly','2:100000000000001000000000000001')
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2008,5,30))
test(dates[2] == Date.civil(2008,7,1))
test(dates.last == Date.civil(2009,5,15))

p "Every month on the 3rd Tuesday and Saturday"
dates = GENERAL_DATE.recur('monthly','1:001:0010001')
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2008,6,17))

p "Every second month on the last Thursday"
dates = GENERAL_DATE.recur('monthly','2:000001:0000100')
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2008,7,31))

p "Every second month on the last Friday"
dates = GENERAL_DATE.recur('monthly','2:000001:0000010')
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2008,5,30))
test(dates[2] == Date.civil(2008,7,25))

p "Every year"
dates = GENERAL_DATE.recur('yearly','1',GENERAL_DATE+740)
test(dates[0] == GENERAL_DATE)
test(dates[1] == Date.civil(2009,5,29))
test(dates.last == Date.civil(2011,5,29))

p "The 1st and Last Thursday of January and March Every Year"
dates = GENERAL_DATE.recur('yearly','1:101:100001:00001',GENERAL_DATE+740)
test(dates[1] == Date.civil(2009,1,1))
test(dates[2] == Date.civil(2009,1,29))

p "Third and Fifth Saturday Every Fourth Century"
dates = Date.civil(1955,11,5).recur('yearly','400:111111111111:00101:0000001',Date.civil(1965,11,5))
test(dates[0] == Date.civil(1955,11,5))
test(dates[1] == Date.civil(1955,11,19))
test(dates[3] == Date.civil(1955,12,31))

p ""
p ""
p ""

TESTS = 1000
Benchmark.bmbm do |results|
  results.report("name: ") { TESTS.times {  
    Date.civil(1955,11,5).recur('yearly','400:111111111111:00101:0000001',Date.civil(1965,11,5))    
  } }
end