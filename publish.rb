#!/usr/bin/env ruby

# Publish the latest backup
# =========================
#
# find the latest backup
# pg_restore it
# connect to postgres and delete data not in the latest year
# pg_dump it
# encrypt the dump with DES3
  # openssl des3 -pass derp < herp.dump > herp.dump.des3
# upload to S3

require 'date'

module BackupPublisher
  module Die
    def die msg
      $stderr.puts(msg)
      exit(1)
    end
  end

  module Config
    extend Die

    BACKUP_DIR = '/Users/jared/git/usgo/gocongress/backup'.freeze

    def self.assert_dir_exists d
      die("Not directory: #{d}") unless Dir.exists?(d)
    end

    def self.check
      [BACKUP_DIR, month_dir].each do |d|
        assert_dir_exists(d)
      end
    end

    def self.month_dir
      File.join(BACKUP_DIR, Date.today.strftime("%Y-%m"))
    end
  end

  module LatestBackup
    def self.in path
      File.join(path, Dir.new(path).sort.last)
    end
  end

  def self.main
    Config.check
    puts LatestBackup.in Config.month_dir
  end
end

BackupPublisher.main
