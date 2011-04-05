class CantDoThat < StandardError; end
class Ninja

  attr_accessor :shuriken

  def initialize(weapons)
    @shuriken = weapons[:shuriken] || 0
  end

  def fling!
    if @shuriken && @shuriken > 0
      @shuriken = @shuriken - 1
    else
      raise CantDoThat
    end
  end

  def katana?
    true
  end

  def attack!(opponent = nil)
    @opponent = opponent
  end

  def status
    if @opponent == 'Chuck Norris'
      :running
    else
      :engaged
    end
  end


end