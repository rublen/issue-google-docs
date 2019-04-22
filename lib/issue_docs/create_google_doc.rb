begin
  require 'google/apis/drive_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'
rescue LoadError
  system "gem install googleauth"
  system "gem install google-api-client"
end

module IssueDocs
  module CreateGoogleDoc
    Drive = Google::Apis::DriveV3 # Alias the module

    def authorize
      scope = 'https://www.googleapis.com/auth/drive'

      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(File.join(__dir__, 'service-account-creds.json')),
        scope: scope
      )

      authorizer.fetch_access_token!

      @drive = Drive::DriveService.new
      @drive.authorization =  authorizer # See Googleauth or Signet libraries
    end

    def create_document(doc_name)
      metadata = Drive::File.new(name: doc_name, mime_type: 'application/vnd.google-apps.document')
      @drive.create_file(metadata)
    end

    def permit_anyone_to_edit(file)
      callback = lambda do |res, err|
        if err
          puts err.body
        else
          puts "Permission ID: #{res.id}"
        end
      end

      user_permission = {type: "anyone", role: "writer"}
      @drive.create_permission(file.id, user_permission, send_notification_email: false, fields: 'id', &callback)
    end

    def edit_link_for(file)
      "https://docs.google.com/document/d/#{file.id}/edit"
    end
  end
end
