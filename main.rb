require 'dicom'
require 'csv'
require_relative 'lib/patient'
require_relative 'lib/dxml'
include DICOM

DICOM.logger.level = Logger::ERROR
DICOM.image_processor = :mini_magick

if ARGV.empty?
  puts "Usage: main.rb <xml_root_path> <dcm_root_path>"
  puts "<xml_root_path> - .../XMLs"
  puts "<dcm_root_path> - .../DOI"
  puts "Example: ruby main.rb /Users/alex/Code/lungcancer/files/XMLs /Users/alex/Code/lungcancer/files/DOI"
  Kernel.exit(0)
end

xml_path = ARGV[0]
dcm_path = ARGV[1]

Dir.mkdir('result') unless File.exists?('result')

xmls = Dir["#{xml_path}/*.xml"]
puts "#{xmls.count} XMLs found"

i = 0

xmls.each do |xml|
  begin
    puts "Processing XML #{i + 1}/#{xmls.count}"
    patient = Patient.new(
      File.basename(xml).match(/[^_]+/)[0],
      DXML.new(xml)
    )

    study_uid = patient.xml.get_study_uid
    Dir.mkdir("result/#{patient.id}") unless File.exists?("result/#{patient.id}")
    Dir.mkdir("result/#{patient.id}/#{study_uid}") unless File.exists?("result/#{patient.id}/#{study_uid}")
    
    puts "Processing #{patient.id} - #{study_uid}"

    dcm_files = Dir["#{dcm_path}/#{patient.id}/#{study_uid}/*/*.dcm"]
    puts "#{dcm_files.count} DICOMs found"

    print 'Creating Slice Loc <=> DICOM DB'
    dicom_loc = {}
    dcm_files.each do |dcm_file|
      dcm = DObject.read(dcm_file)
      dcm_z = dcm.to_hash["Slice Location"].to_f
      dicom_loc[dcm_z] = File.basename(dcm_file)
      print '.'
    end
    puts "Done"

    puts "Extracting nodules..."
    sessions = patient.xml.get_nodules_by_sessions(dicom_loc)
    puts "Done. Writing CSV output"

    sessions.each do |session|
      print "Writing session #{session.id}"
      
      Dir.mkdir("result/#{patient.id}/#{study_uid}/rad_#{session.id}") unless File.exists?("result/#{patient.id}/#{study_uid}/rad_#{session.id}")
      metadata_csv = CSV.open("result/#{patient.id}/#{study_uid}/rad_#{session.id}/data.csv", 'w')
      metadata_csv << ['id', 'malignancy', 'nodule_csv_filename']

      session.nodules.each do |nodule|
        metadata_csv << [nodule.id, nodule.malignancy, "#{nodule.id}.csv"]

        CSV.open("result/#{patient.id}/#{study_uid}/rad_#{session.id}/#{nodule.id}.csv", 'w') do |csv|
          csv << ['x', 'y', 'z', 'dicom_file']
          nodule.regions.each do |coords|
            coords.each {|c| csv << c}
          end
        end
        print '.'
      end

      metadata_csv.close
      i += 1
      puts
    end
  rescue Exception => e # yeaaaah, rescue Exception :D
    puts "XML file #{xml} can't be processed"
    puts e.message
    puts e.backtrace
  end

  puts "All done"
end



