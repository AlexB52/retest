require_relative 'test_helper'
require 'minitest/autorun'
require_relative 'retest_test/file_changes_test'
require_relative 'retest_test/flags_test'
require_relative 'retest_test/setup_test'
require_relative 'retest_test/matching_unmatching_command_test'

$stdout.sync = true

include FileHelper

