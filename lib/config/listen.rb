# lib/config/listen.rb:4: warning: method redefined; discarding old _fail
# ~/.rbenv/versions/3.1.2/lib/ruby/gems/3.1.0/gems/listen-3.8.0/lib/listen/record/symlink_detector.rb:35: warning: previous definition of _fail was here

# Runs a block of code without warnings.
def silence_warnings(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end

silence_warnings do

  # TODO: Update monkey patch when decision is made about
  #       https://github.com/guard/listen/issues/572

  module Listen
    class Record
      class SymlinkDetector
        def _fail(symlinked, real_path)
          Listen.logger.warn(format(SYMLINK_LOOP_ERROR, symlinked, real_path))
          raise Error, "Don't watch locally-symlinked directory twice"
        end
      end
    end
  end

end
