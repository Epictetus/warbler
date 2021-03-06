#--
# Copyright (c) 2010-2012 Engine Yard, Inc.
# Copyright (c) 2007-2009 Sun Microsystems, Inc.
# This source code is available under the MIT license.
# See the file LICENSE.txt for details.
#++

module Warbler
  module Traits
    # The NoGemspec trait is used when no gemspec file is found for a
    # jar project. It assumes a standard layout including +bin+ and
    # +lib+ directories.
    class NoGemspec
      include Trait
      include PathmapHelper

      def self.detect?
        Jar.detect? && !Gemspec.detect?
      end

      def before_configure
        config.dirs = ['.']
      end

      def after_configure
        if File.directory?("lib")
          add_init_load_path(config.pathmaps.application.inject("lib") {|pm,x| pm.pathmap(x)})
        end
      end

      def update_archive(jar)
        add_main_rb(jar, apply_pathmaps(config, default_executable, :application))
      end

      def default_executable
        exes = Dir['bin/*']
        exe = exes.grep(/#{config.jar_name}/).first || exes.first
        raise "No executable script found" unless exe
        exe
      end
    end
  end
end
