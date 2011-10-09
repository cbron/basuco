module Basuco
  class Resource
    attr_reader :data
    
    # initializes a resource using a json result
    def initialize(data)
      #assert_kind_of 'data', data, Hash
      @schema_loaded, @attributes_loaded, @data = false, false, data
      @data_fetched = data["/type/reflect/any_master"] != nil
    end
    
    # Executes an Mql Query against the Freebase API and returns the result wrapped
    # in a <tt>Resource</tt> Object.
    #
    # == Examples
    #
    #  Basuco::Resource.get('/en/the_police') => #<Resource id="/en/the_police" name="The Police">
    # @api public
    def self.get(id)
     # assert_kind_of 'id', id, String
      arr = Resource.define_query
      result = Basuco.search.mqlread(arr.merge!(:id => id))
      raise ResourceNotFound unless result
      Basuco::Resource.new(result)
    end
    
    # resource id
    # @api public
    def id
      @data["id"] || ""
    end
    
    # resource guid
    # @api public
    def guid
      @data['guid'] || ""
    end
    
    # resource name
    # @api public
    def name
      @data["name"] || ""
    end
    
    # @api public
    def to_s
      name || id || ""
    end
    
    # @api public
    def inspect
      result = "#<Resource id=\"#{id}\" name=\"#{name || "nil"}\">"
    end
    
    # returns all assigned types
    # @api public
    def types
      load_schema! unless schema_loaded?
      @types
    end
    
    # returns all available views based on the assigned types
    # @api public
    def views
      @views ||= Basuco::Collection.new(types.map { |type| Basuco::View.new(self, type) })
    end
    
    # returns individual view based on the requested type id
    # @api public
    def view(type)
      views.each { |v| return v if v.type.id =~ /^#{Regexp.escape(type)}$/}
      nil
    end
    
    # returns individual type based on the requested type id
    # @api public
    def type(type)
      types.each { |t| return t if t.id =~ /^#{Regexp.escape(type)}$/}
      nil
    end

    # returns all the properties from all assigned types
    # @api public
    def properties
      @properties = Basuco::Collection.new
      types.each do |type|
        @properties.concat(type.properties)
      end
      @properties
    end
    
    # returns all attributes for every type the resource is an instance of
    # @api public
    def attributes
      load_attributes! unless attributes_loaded?
      @attributes.values
    end
    
    # search for an attribute by name and return it
    # @api public
    def attribute(name)
      attributes.each { |a| return a if a.property.id == name }
      nil
    end
    
    # returns true if type information is already loaded
    # @api public
    def schema_loaded?
      @schema_loaded
    end
    
    # returns true if attributes are already loaded
    # @api public
    def attributes_loaded?
      @attributes_loaded
    end
    # returns true if json data is already loaded
    # @api public
    def data_fetched?
      @data_fetched
    end

    

    private
    # executes the fetch data query in order to load the full set of types, properties and attributes
    # more info at http://lists.freebase.com/pipermail/developers/2007-December/001022.html
    # @api private
    def fetch_data
      return @data if @data["/type/reflect/any_master"]
      @data = Basuco.search.mqlread(define_query.merge!(:id => id))
    end
    
    # loads the full set of attributes using reflection
    # information is extracted from master, value and reverse attributes
    # @api private
    def load_attributes!
      fetch_data unless data_fetched?
      # master & value attributes
      raw_attributes = Basuco::Util.convert_hash(@data["/type/reflect/any_master"])
      raw_attributes.merge!(Basuco::Util.convert_hash(@data["/type/reflect/any_value"]))      
      @attributes = {}
      raw_attributes.each_pair do |a, d|
        properties.select { |p| p.id == a}.each do |p|
          @attributes[p.id] = Basuco::Attribute.create(d, p)
        end
      end
      # reverse properties
      raw_attributes = Basuco::Util.convert_hash(@data["/type/reflect/any_reverse"])
      raw_attributes.each_pair do |a, d|
        properties.select { |p| p.master_property == a}.each do |p|
          @attributes[p.id] = Basuco::Attribute.create(d, p)
        end
      end
      @attributes_loaded = true
    end
    
    # loads the resource's metainfo
    # @api private
    def load_schema!
      fetch_data unless data_fetched?
      @types = Basuco::Collection.new(@data["Basuco:type"].map { |type| Basuco::Type.new(type) })
      @schema_loaded = true
    end

    def self.define_query
        {
        # :id => id, # needs to be merge!d in instance method
        :guid => nil,
        :name => nil,
        :"Basuco:type" => [{
          :id => nil,
          :name => nil,
          :properties => [{
            :id => nil,
            :name => nil,
            :expected_type => nil,
            :unique => nil,
            :reverse_property => nil,
            :master_property => nil,
          }]
        }],
        :"/type/reflect/any_master" => [
          {
            :id => nil,
            :link => nil,
            :name => nil,
            :optional => true,
            :limit => 999999
          }
        ],
        :"/type/reflect/any_reverse" => [
          {
            :id => nil,
            :link => nil,
            :name => nil,
            :optional => true,
            :limit => 999999
          }
        ],
        :"/type/reflect/any_value" => [
          {
            :link => nil,
            :value => nil,
            :optional => true,
            :limit => 999999
            # TODO: support multiple language
            # :lang => "/lang/en",
            # :type => "/type/text"
          }
        ]
      }
    end
  end # class Resource
end # module Basuco