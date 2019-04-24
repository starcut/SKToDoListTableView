Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "SKToDoListTableView"
  spec.version      = "0.1.6"
  spec.summary      = "This library simplifies management of your ToDoList"

  # spec.description  = <<-DESC
  #                  DESC

  spec.homepage     = "http://seeking-star.com/"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # spec.license      = "MIT (example)"
  spec.license      = { :type => "MIT", :file => "LICENCE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "starcut" => "stella.scraps@gmail.com" }
  # Or just: spec.author    = "starcut"
  # spec.authors            = { "starcut" => "stella.scraps@gmail.com" }
  # spec.social_media_url   = "https://twitter.com/starcut"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # spec.platform     = :ios
  spec.platform     = :ios, "11.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/starcut/SKToDoListTableView.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "SKToDoListTableView/**/*.{h,m,swift,xib}"
  # spec.exclude_files = "SKToDoListTableView/Pods/FSCalendar/FSCalendar/*.{h,m,swift}"

  # spec.public_header_files = "SKToDoListTableView/Pods/FSCalendar/FSCalendar/FSCalendar.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # spec.framework  = "FSCalendar"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  spec.dependency "FSCalendar"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
