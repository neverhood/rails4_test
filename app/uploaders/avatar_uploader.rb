# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  #

  # Uniquely randomize the filename
  def filename
    @filename ||= "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg pjpeg gif png)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    #asset_path("fallback/" + [version_name, model.sex, "default.png"].compact.join('_'))
    "/assets/fallback/" + [version_name, model.sex, "default.png"].compact.join('_')
  end

  process resize_to_limit: [ 800, 800 ]

  version :large do
    process resize_to_limit: [ 800, 800 ]
  end

  version :medium do
    process resize_to_fill: [ 200, 270 ]
  end

  version :thumb do
    process :crop
    process resize_to_fill: [ 150, 150 ]
  end


  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  private

  def crop
    if model.cropping?
      resize_to_fit 200, 270
      manipulate! do |image|
        geometry = "#{model.crop_w}x#{model.crop_h}+#{model.crop_x}+#{model.crop_y}"
        image.crop geometry
        image
      end
    end
  end

  # Guarantees random avatar filename
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def crop_args
    %w(x y w h).map { |accessor| send(accessor).to_i }
  end

end
