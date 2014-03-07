require 'safety/safety_module'
module Safety
  def self.included(base)
    base.extend SafetyModule
  end
end
