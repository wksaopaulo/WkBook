#         ooooooooo.              o8o  oooo                 .o.             .o8                     o8o
#         `888   `Y88.            `"'  `888                .888.           "888                     `"'
#          888   .d88'  .oooo.   oooo   888   .oooo.o     .8"888.      .oooo888  ooo. .oo.  .oo.   oooo  ooo. .oo.
#          888ooo88P'  `P  )88b  `888   888  d88(  "8    .8' `888.    d88' `888  `888P"Y88bP"Y88b  `888  `888P"Y88b
#          888`88b.     .oP"888   888   888  `"Y88b.    .88ooo8888.   888   888   888   888   888   888   888   888
#          888  `88b.  d8(  888   888   888  o.  )88b  .8'     `888.  888   888   888   888   888   888   888   888
#         o888o  o888o `Y888""8o o888o o888o 8""888P' o88o     o8888o `Y8bod88P" o888o o888o o888o o888o o888o o888o

# Register a custom field factory and field type for CarrierWave if its defined
if defined?(::CarrierWave)
  module RailsAdmin::Config::Fields::Types
    # Field type that supports CarrierWave file uploads
    class CarrierWaveFile < RailsAdmin::Config::Fields::Types::FileUpload
      register_instance_option(:partial) do
        :form_carrier_wave_file
      end
    end
    # Field type that supports CarrierWave file uploads with image preview
    class CarrierWaveImage < CarrierWaveFile
      register_instance_option(:partial) do
        :form_carrier_wave_image
      end
    end
    # Register field type to the types registry
    register(:carrier_wave_file, CarrierWaveFile)
    register(:carrier_wave_image, CarrierWaveImage)
  end
  module RailsAdmin::Config::Fields
    # Register a custom field factory
    register_factory do |parent, properties, fields|
      model = parent.abstract_model.model
      if model.kind_of?(CarrierWave::Mount) && model.uploaders.include?(properties[:name])
        type = properties[:name] =~ /logo|image|picture|thumb/ ? :carrier_wave_image : :carrier_wave_file
        properties[:type] = type
        fields << RailsAdmin::Config::Fields::Types.load(type).new(parent, properties[:name], properties)
        true
      else
        false
      end
    end
  end
end

# RailsAdmin config file. Generated on October 19, 2011 12:08
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  config.current_user_method { current_book_admin } # auto-generated
  
  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Wkbook', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  config.model Template do
    # Found associations:
    field :user, :has_one_association
    # Found columns:
    field :id, :integer
    field :name, :string
    field :preview, :carrier_wave_image
    field :effect_file, :carrier_wave_file
    field :text_id, :integer
    #field :effect_amount, :float
    #field :created_at, :datetime
    #field :updated_at, :datetime
    # Sections:
    list do;
    end
    export do; end
    show do; end
    edit do; end
    create do;
    end
    update do; end
   end

 config.model User do
   # Found associations:
   field :template, :belongs_to_association
   # Found columns:
   field :id, :integer
   field :email, :string
   field :password, :password
   field :password_confirmation, :password
   field :reset_password_token, :string        # Hidden
   field :reset_password_sent_at, :datetime
   field :remember_created_at, :datetime
   field :sign_in_count, :integer
   field :current_sign_in_at, :datetime
   field :last_sign_in_at, :datetime
   field :current_sign_in_ip, :string
   field :last_sign_in_ip, :string
   field :name, :string
   field :template_id, :integer
   field :template_picture, :string
   field :template_text, :text
   field :created_at, :datetime
   field :updated_at, :datetime
   # Sections:
   list do; end
   export do; end
   show do; end
   edit do; end
   create do; end
   update do; end
  end

end

# You made it this far? You're looking for something that doesn't exist! Add it to RailsAdmin and send us a Pull Request!
