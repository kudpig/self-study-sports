class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # リサイズ等画像の加工処理をするにはMiniMagickが必要

  # Choose what kind of storage to use for this uploader:
  # if Rails.env.development? || Rails.env.test? 
  #   storage :file
  # else
  #   storage :fog
  # end

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # デフォルト画像の設定
  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'profile-placeholder.png'
  end

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
  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # 画像の横幅・縦幅の最大値設定。どちらかが超えてしまう場合は最大値に合わせてリサイズされる。
  process resize_to_limit: [400, 400]
end
