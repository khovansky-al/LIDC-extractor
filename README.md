# LIDC Extractor
Written in Ruby 2.3.1

## Dependencies
* nokogiri
* ruby-dicom ([Github](https://github.com/dicom/ruby-dicom))

## Installing dependencies
Run `gem install dicom` and `gem install nokogiri` (if on Windows) from terminal

## Running
Place all patient XMLs in some folder.
Leave DICOMs where they are.

Run with `ruby main.rb [xml_path] [dcm_path]`.

**Example folder structure:** 

* /Users/alex/Code/lungcancer/files/XML
  * LIDC-IDRI-0001_001.xml

* /Users/alex/Code/lungcancer/files/DOI
  * /LIDC-IDRI-0001
    * /1.3.6.1.4.1.14519.5.2.1.6279.6001.298806137288633453246975630178
      * /doesn't matter how this folder is named
        * /..
        * /000001.dcm