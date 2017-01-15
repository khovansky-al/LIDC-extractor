require 'nokogiri'
require_relative 'session'
require_relative 'nodule'

class DXML

  attr_reader :file

  def initialize(path)
    @path = path
    @file = Nokogiri::XML(File.open(path))
    @file.remove_namespaces!
  end

  def get_study_uid
    self.file.xpath("//StudyInstanceUID").text
  end

  def get_nodules_by_sessions(dcm_loc)
    sessions = self.file.xpath('//readingSession')
    puts "#{sessions.size} sessions found"
    i = 0
    radiologists = []

    sessions.each do |session|
      radiologist = Session.new(session.xpath('servicingRadiologistID').text)
      print "Processing session ##{radiologist.id} (#{i + 1}/#{sessions.size})"

      session.xpath('unblindedReadNodule').each do |nodule|
        next unless nodule.xpath('characteristics').text != ''

        nodule_instance = Nodule.new(
          nodule.xpath('noduleID').text,
          nodule.xpath('characteristics/malignancy').text
        )
        
        nodule.xpath('roi').each do |roi|
          next if roi.xpath('inclusion').text == 'FALSE'
          loc = roi.xpath('imageZposition').text.to_f
          coords = []
          roi.xpath('edgeMap').each do |edge_map|
            coords << [edge_map.xpath('xCoord').text, edge_map.xpath('yCoord').text, loc, dcm_loc[loc]]
          end
          nodule_instance.regions << coords
        end

        radiologist.nodules << nodule_instance
        print '.'
      end
      radiologists << radiologist
      puts
      i += 1
    end
    radiologists
  end
end