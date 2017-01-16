# LIDC Extractor
This script extracts patients' diagnoses from XML files that come with LIDC dataset. 
For each patient, study case and radiologist that surveyed his case this script outputs a series of files:

* data.csv - Metadata that contains ids of all nodules, it's malignancy and corresponding CSV file
* %node_id%.csv - File that contains coordinates of ROIs painted by radiologist (the ones that are marked as "inclusion==TRUE"). For each coordinate set it also contains .dcm filename that corresponds to this regions.

Written in Ruby 2.3.1

## Dependencies
* nokogiri
* ruby-dicom ([Github](https://github.com/dicom/ruby-dicom))

## Installing dependencies
Run `gem install dicom` and `gem install nokogiri` from terminal

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

## Results
Results can be found in `results` folder right next to the script