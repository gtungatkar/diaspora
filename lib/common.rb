module Diaspora
  module XMLParser
    def parse_sender_id_from_xml(xml)
      doc = Nokogiri::XML(xml) { |cfg| cfg.noblanks }
      doc.xpath("/XML/head/sender/email").text.to_s
    end

    def parse_sender_object_from_xml(xml)
      sender_id = parse_sender_id_from_xml(xml)
      Friend.where(:email => sender_id).first
    end

    def parse_body_contents_from_xml(xml)
      doc = Nokogiri::XML(xml) { |cfg| cfg.noblanks }
      doc.xpath("/XML/posts/post")
    end

    def parse_objects_from_xml(xml)
      objects = []
      sender = parse_sender_object_from_xml(xml)
      body = parse_body_contents_from_xml(xml)
      body.children.each do |post|
        begin
          object = post.name.camelize.constantize.from_xml post.to_s
          object.person = sender if object.is_a? Post  
          objects << object 
        rescue
          puts "Not a real type: #{object.to_s}"
        end
      end
      objects
    end

    def store_objects_from_xml(xml)
      objects = parse_objects_from_xml(xml)

      objects.each do |p|
        p.save if p.respond_to?(:person) && !(p.person.nil?) #WTF
        #p.save if p.respond_to?(:person) && !(p.person == nil) #WTF
      end
    end


  end
  module Webhooks
    def self.included(klass)
      klass.class_eval do
      after_save :notify_friends
        @@queue = MessageHandler.new
        
        def notify_friends
          if self.person_id == User.first.id
            xml = Post.build_xml_for([self])
            @@queue.add_post_request( friends_with_permissions, CGI::escape(xml) )
            @@queue.process
          end
        end
 
        def prep_webhook
          "<post>#{self.to_xml.to_s}</post>"
        end

        def friends_with_permissions
           Friend.all.map{|x| x = x.url + "receive/"}
        end

        def self.build_xml_for(posts)
          xml = "<XML>"
          xml += Post.generate_header
          xml += "<posts>"
          posts.each {|x| xml << x.prep_webhook}
          xml += "</posts>"
          xml += "</XML>"
        end


        def self.generate_header
          "<head>
            <sender>
              <email>#{User.first.email}</email>
            </sender>
          </head>"
        end
      end
    end
  end
end