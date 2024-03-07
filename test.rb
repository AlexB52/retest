require "open3"
require "byebug"

$stdout.sync = true

stdin, stdout, stderr, wait_thr = Open3.popen3("retest --all")
puts pid = wait_thr[:pid]  # pid of the started process.

# stdout.sync = true

class WrongMatchError < StandardError;end

time = 1
begin
  raise "Assertion failed" if time >= 5

  sleep(time)
  result = stdout.read_nonblock(4096)
  puts "result: ", result
  assertion = result.include?("107 runs, 208 assertions, 0 failures, 0 errors, 0 skips")
  puts "assertion: ", assertion
  raise WrongMatchError unless assertion
rescue WrongMatchError, IO::EAGAINWaitReadable => e
  time += 1
  puts "retrying with time: ", time
  retry
end

stdin.close  # stdin, stdout and stderr should be closed explicitly in this form.
stdout.close
stderr.close

if pid
  Process.kill('SIGHUP', pid)
  Process.detach(pid)
end

puts exit_status = wait_thr.value  # Process::Status object returned.

