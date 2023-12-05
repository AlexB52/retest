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
