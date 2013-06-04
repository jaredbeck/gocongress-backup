#!/usr/bin/env ruby

# Publish the latest backup
# =========================
#
# find the latest backup
# delete records from previous years
# encrypt the dump with DES3
  # openssl des3 -pass derp < herp.dump > herp.dump.des3
# upload to S3 (using fog?)

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

  module Db
    extend Die

    def self.cleanup path
      create
      restore path
      # delete records from previous years
        # see `delete_from_prev_years.sql`
      # dump
      # drop
    end

    def self.create
      die('Cannot create db') unless system("createdb -T template0 #{name}")
    end

    def self.drop
      die('Cannot drop db') unless system("dropdb #{name}")
    end

    def self.name
      yyyymmdd = Date.today.strftime("%Y%m%d")
      "usgc_cleanup_#{yyyymmdd}"
    end

    def self.restore path
      unless system("pg_restore --no-acl --no-owner -d #{name} #{path}")
        die('Cannot restore db')
      end
    end
  end

  def self.main
    Config.check
    Db.cleanup LatestBackup.in Config.month_dir
  end
end

BackupPublisher.main
