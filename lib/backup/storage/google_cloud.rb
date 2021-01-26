require 'google/cloud/storage'

module Backup
  module Storage
    class GoogleCloud < Backup::Storage::Base
      attr_accessor :project_id, :credentials, :bucket, :dest

      attr_reader :storage

      def initialize(model, storage_id = nil, &block)
        super
        storage = Google::Cloud::Storage.new(
          project_id: project_id,
          credentials: credentials
        )
        @storage = storage.bucket(bucket)
      end

      def transfer!
        package.filenames.each do |filename|
          src = File.join(Config.tmp_path, filename)
          Logger.info "Storing '#{src} to #{dest}'..."
          @storage.create_file src, dest
        end
      end
    end
  end
end
