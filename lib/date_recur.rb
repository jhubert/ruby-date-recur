require 'date'
class Date #:nodoc:
  def recur(type,pattern=nil,ends=self+365)
    start = self.dup
    date = self.dup
    dates = [date]
    pattern = 1 if pattern.to_i == 0
    case type.to_s
    when 'daily'
      date.step(ends,pattern.to_i) { |d| dates << d }
    when 'weekly'
      if !pattern.include?(':')
        date.step(ends,7*pattern.to_i) { |d| dates << d }
      else
        pattern = pattern.split(':')
        pattern[1].scan(/./).each_with_index do |d,x|
          next if d.to_i != 1
          base = date + 7 * (pattern[0].to_i - 1) + (x - date.cwday)
          base = base + 7 if base < date || x < date.cwday
          base.step(ends,7*pattern[0].to_i) { |d| dates << d }
        end
      end
    when 'monthly'
      if !pattern.include?(':')
        dates << (date = date>>pattern.to_i) while date < ends
      else
        pattern = pattern.split(':')
        if pattern.length == 2
          date = Date.civil(date.year,date.month)
          while date <= ends do
            pattern[1].scan(/./).each_with_index do |d,x|
              next if d.to_i != 1 || Date.valid_civil?(date.year,date.month,x.to_i + 1).nil?
              dt = Date.civil(date.year,date.month,x.to_i + 1)
              next if dt < start || dt > ends
              dates << dt
            end
            date = date>>pattern[0].to_i
          end
        elsif pattern.length == 3
          while date <= ends do
            pattern[2].scan(/./).each_with_index do |d,y|
              next if d.to_i != 1
              pattern[1].scan(/./).each_with_index do |c,x|
                next if c.to_i != 1
                dt = date.nth_weekday(x.to_i,y.to_i)
                next if dt.nil? || dt < start || dt > ends
                dates << dt
              end
            end
            date = date>>pattern[0].to_i
          end
        end
      end
    when 'yearly'
      if !pattern.include?(':')
        dates << (date = date>>12*pattern.to_i) while date < ends
      else
        pattern = pattern.split(':')
        if pattern.length == 2
          while date < ends do
            pattern[1].scan(/./).each_with_index do |d,x|
              next if d.to_i != 1
              x = x.to_i > 11 ? 1 : x.to_i + 1
              dt = Date.civil(date.year,x,date.day) if Date.valid_civil?(date.year,x,date.day)
              next if dt.nil? || dt < start || dt > ends
              dates << dt
            end
            date = date>>12*pattern[0].to_i
          end
        elsif pattern.length == 4
          while date < ends do
            pattern[1].scan(/./).each_with_index do |b,x|
              next unless b.to_i == 1
              x = x.to_i > 11 ? 1 : x.to_i + 1
              active_month = Date.civil(date.year,x,date.day) if Date.valid_civil?(date.year,x,date.day)
              next if active_month.nil? || active_month < start || active_month > ends
              pattern[3].scan(/./).each_with_index do |d,y|
                next unless d.to_i == 1
                pattern[2].scan(/./).each_with_index do |c,x|
                  next unless c.to_i == 1
                  dt = active_month.nth_weekday(x.to_i,y.to_i)
                  next if dt.nil? || dt < start || dt > ends
                  dates << dt
                end
              end
            end
            date = date>>12*pattern[0].to_i
          end
        end
      end
    end
    dates.uniq!
    dates.sort!
  end
  
  def first_sunday
    Date.civil(self.year,self.month) + (7 - self.cwday)
  end

  def nth_weekday(nth,day_of_week)
    nth = nth + 1
    last = nth == 6
    nth = 5 if last
    date = Date.civil(self.year,self.month)
    current_week_day = date.cwday
    day_of_week = 7 if day_of_week == 0
    nth -= 1 if day_of_week >= current_week_day
    offset = (7*nth - (current_week_day - day_of_week))
    new_date = date + (7*nth - (current_week_day - day_of_week))
    return new_date if new_date.month == date.month
    return last ? new_date - 7 : nil
  end

  def last_sunday
    m = self.month == 12 ? 1 : self.month + 1
    Date.civil(self.year,m).first_sunday - 7
  end
end