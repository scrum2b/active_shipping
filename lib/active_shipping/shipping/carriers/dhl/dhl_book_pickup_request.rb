require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlBookPickupRequest
      include Virtus.model
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::DhlConstants
      include ActiveMerchant::Shipping::Constants              
      
      # authorization
      attribute :site_id, String
      attribute :password, String      

      attribute :account_number, String      
      attribute :business, Boolean, default: false
      attribute :residential, Boolean, default: false      
      attribute :shipment_details, Boolean, default: false      
      attribute :company, String                  
      attribute :address, String
      attribute :package_location, String
      attribute :city, String
      attribute :country, String
      attribute :postal_code, String
      
      attribute :awb_number, String      
      
      attribute :pickup_date, Date     
      attribute :ready_by_time, String
      attribute :close_time, String     
            
      attribute :contact_name, String           
      attribute :contact_phone, String 

      attribute :weight, Float 
                      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
      
      def is_business_address
        business
      end
      
      def is_residential_address
        residential
      end      
      
      def location_type
        back = "C"
        back = "B" if is_business_address
        back = "R" if is_residential_address        
        back
      end
            
      def pickup_date
        date = Date.parse(pickup_date.to_s)
        date.strftime("%Y-%m-%d")
      end   
                  
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/dhl/templates/book_pickup.xml.erb"
        end
    end
  end
end