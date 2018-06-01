# rubocop:disable Lint/UselessAssignment
# rubocop:disable Metrics/LineLength
require 'test_helper'
require 'open3'

# default lock wait timeout is 50 seconds but since other command needs some
# time to bootup I use 55
# https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_lock_wait_timeout

LOCK_WAIT_TIMEOUT_EXCEEDED = 'Mysql2::Error: Lock wait timeout exceeded; try restarting transaction'.freeze

class DemoTest < ActiveSupport::TestCase
  def background(cmd)
    io = IO.popen(cmd + ' &')
    io.pid
  end

  def foreground(cmd)
    stdout, stderr, _status = Open3.capture3(cmd)
    OpenStruct.new stdout: stdout, stderr: stderr
  end

  test 'find_in_transaction does not raise timeouts' do
    pid = background 'rake demo:find_in_transaction[Bob,55]'
    result = foreground 'rake demo:find_in_transaction[Bob]'
    assert_empty result.stderr
    Process.kill 'HUP', pid
  end

  test 'find & destroy does not raise timeout' do
    pid = background 'rake demo:find_in_transaction[Bob,55]'
    result = foreground 'rake demo:destroy_in_transaction[Bob]'
    assert_empty result.stderr
    Process.kill 'HUP', pid
  end

  test 'destroy & find does not raise timeout' do
    pid = background 'rake demo:destroy_in_transaction[Bob,55]'
    result = foreground 'rake demo:find_in_transaction[Bob]'
    assert_empty result.stderr
    Process.kill 'HUP', pid
  end

  test 'find_in_lock_and_transaction raise timeout' do
    pid = background 'rake demo:find_in_lock_and_transaction[Bob,55]'
    result = foreground 'rake demo:find_in_lock_and_transaction[Bob]'
    assert_match LOCK_WAIT_TIMEOUT_EXCEEDED, result.stderr
    Process.kill 'HUP', pid
  end
end
