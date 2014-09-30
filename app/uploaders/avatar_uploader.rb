# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # validate :validate_minimum_image_size

  # def validate_minimum_image_size
  #   if  image_width > 250 || image_height > 250 || image_width != image_height 
  #     errors.add :image, "should be 400x400px maxmum!" 
  #   end
  # end
  


  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  def image
    @image ||= MiniMagick::Image.open( model.send(mounted_as).path )
  end

  def image_width 
     image[:width]
  end

  def image_height
    image[:height]
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{get_last_dir_part(model.id)}"
  end

  def get_last_dir_part(modelid)
    p = modelid.to_s.rjust(9, '0')
    "#{p[0,3]}/#{p[3,3]}/#{p[6,3]}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end


  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  version :banner do
    process :resize_to_fill => [250,250]
  end

  version :thumb do
    process :resize_to_fill => [180,180]
  end

  version :minum do
    process :resize_to_fill => [120,120]
  end  

  version :small do
    process :resize_to_fill => [90,90]
  end


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

end
