# Copyright (c) 2013-2015 SUSE LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of version 3 of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.   See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, contact SUSE LLC.
#
# To contact SUSE about this file by physical or electronic mail,
# you may find current contact information at www.suse.com

module Machinery
  class SystemFileUtils
    attr_accessor :file

    def initialize(file)
      @file = file
    end

    def tarball_path
      if @file.directory?
        File.join(
          @file.scope.scope_file_store.path,
          "trees",
          File.dirname(@file.name),
          File.basename(@file.name) + ".tgz"
        )
      else
        File.join(@file.scope.scope_file_store.path, "files.tgz")
      end
    end

    def write_tarball(target)
      raise Machinery::Errors::FileUtilsError if !file.directory?

      tarball_target = File.join(target, File.dirname(@file.name))

      FileUtils.mkdir_p(tarball_target)
      FileUtils.cp(tarball_path, tarball_target)
    end
  end
end
