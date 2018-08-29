class VideoUploader < CarrierWave::Uploader::Base
  after :store, :delete_old_tmp_file

    # storage :file
  storage :fog
  # if Rails.env.production?
  #   include CarrierWaveDirect::Uploader
  # elsif Rails.env.development? || Rails.env.test?
  #   storage :file
  # end

  def will_include_content_type
    true
  end

  # default_content_type  'video/mpeg'
  # allowed_content_types %w(video/mpeg video/mp4 video/ogg)

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(mov mpeg mpg mp4 avi mp3)
  end

  def cache!(new_file)
    super
    @old_tmp_file = new_file
  end
  
  def delete_old_tmp_file(dummy)
    @old_tmp_file.try :delete
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
