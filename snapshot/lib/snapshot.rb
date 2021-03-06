require 'snapshot/runner'
require 'snapshot/reports_generator'
require 'snapshot/detect_values'
require 'snapshot/screenshot_flatten'
require 'snapshot/screenshot_rotate'
require 'snapshot/dependency_checker'
require 'snapshot/latest_os_version'
require 'snapshot/test_command_generator'
require 'snapshot/test_command_generator_xcode_8'
require 'snapshot/error_handler'
require 'snapshot/collector'
require 'snapshot/options'
require 'snapshot/update'
require 'snapshot/fixes/simulator_zoom_fix'
require 'snapshot/fixes/hardware_keyboard_fix'
require 'snapshot/command_listener'
require 'snapshot/simulator_launchers/launcher_configuration'
require 'snapshot/simulator_launchers/simulator_launcher'
require 'snapshot/simulator_launchers/simulator_launcher_xcode_8'

require 'fastlane_core'

require 'open3'

module Snapshot
  # Use this to just setup the configuration attribute and set it later somewhere else
  class << self
    attr_accessor :config

    attr_accessor :project

    attr_accessor :cache

    def config=(value)
      @config = value
      DetectValues.set_additional_default_values
      @cache = {}
    end

    def snapfile_name
      "Snapfile"
    end

    def kill_simulator
      `killall 'iOS Simulator' &> /dev/null`
      `killall Simulator &> /dev/null`
    end
  end

  Helper = FastlaneCore::Helper # you gotta love Ruby: Helper.* should use the Helper class contained in FastlaneCore
  UI = FastlaneCore::UI
  ROOT = Pathname.new(File.expand_path('../..', __FILE__))
  DESCRIPTION = "Automate taking localized screenshots of your iOS and tvOS apps on every device"
  CACHE_DIR = File.join(Dir.home, "Library/Caches/tools.fastlane")
  SCREENSHOTS_DIR = File.join(CACHE_DIR, 'screenshots')

  Snapshot::DependencyChecker.check_dependencies

  def self.min_xcode7?
    xcode_version.split(".").first.to_i >= 7
  end
end
