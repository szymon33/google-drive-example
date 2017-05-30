require 'google/apis/drive_v2'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

class MyGoogleDrive
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'Drive API Ruby Quickstart by Szymon'.freeze
  CLIENT_SECRETS_PATH = 'client_secret.json'.freeze
  CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                               'drive-ruby-quickstart-by-szymon.yaml')
  SCOPE = Google::Apis::DriveV2::AUTH_DRIVE

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(
      client_id, SCOPE, token_store
    )
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(
        base_url: OOB_URI
      )
      puts 'Open the following URL in the browser and enter the ' \
           'resulting code after authorization'
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

  def initialize
    # Initialize the API
    @service = Google::Apis::DriveV2::DriveService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def list
    @service.list_files
  end

  def upload(title, source, folder_id = nil)
    metadata = { title: title }
    metadata[:parents] = [folder_id] if folder_id
    @service.insert_file(metadata, upload_source: source,
                                   content_type: 'text/plain', options: { retries: 3 })
  end

  def find_folder(name)
    folders = []
    page_token = nil
    loop do
      list = @service.list_files(q: "mimeType='application/vnd.google-apps.folder'",
                                 spaces: 'drive',
                                 page_token: page_token)
      folders = list.items.select { |item| item.title == name }
      break if page_token.nil? || folders.any?
    end
    folders.first
  end

  def create_folder(name)
    metadata = {
      title: name,
      mime_type: 'application/vnd.google-apps.folder'
    }
    @service.insert_file(metadata, fields: 'id')
  end

  def find_or_create_folder(name)
    find_folder(name) || create_folder(name)
  end
end
