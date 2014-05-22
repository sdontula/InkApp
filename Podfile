platform :ios, '6.0'
pod 'AFNetworking', '~> 2.0'
pod 'XtifyLib', '~> 2.51'

post_install do |installer|
    config = <<-XTIFYGLOBAL_H
    #define xAppKey @"cd7b7fa1-0e3f-41d9-86cb-f067f9aba6ac"
    #define xLocationRequired NO
    #define xRunAlsoInBackground FALSE
    #define xDesiredLocationAccuracy kCLLocationAccuracyKilometer  // kCLLocationAccuracyBest
    #define xBadgeManagerMethod XLInboxManagedMethod
    #define xLogging TRUE
    #define xMultipleMarkets FALSE
    XTIFYGLOBAL_H
    File.open("Pods/XtifyLib/XtifyLib/XtifyGlobal.h", "w") do |file|
        file.puts config
    end
end