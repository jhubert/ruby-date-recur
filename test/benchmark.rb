require 'benchmark'
require '../lib/date_recur.rb'

TESTS = 1000
Benchmark.bmbm do |results|
  results.report("name: Original Method") { 
    TESTS.times {
      Date.today.nth_weekday(5,3)
    }
  }
end