//
//  ComplicationController.swift
//  MJournalWatch Extension
//
//  Created by Michael on 07.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: 60*60*24))
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate: NSDate(timeInterval: 60, sinceDate: NSDate()))
        template.body1TextProvider = CLKSimpleTextProvider(text: "История")
        template.body2TextProvider = CLKSimpleTextProvider(text: "Каб. 220")
        
        let entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: 60*60 * -0.25, sinceDate: NSDate()), complicationTemplate: template)
        handler(entry)
    }
    
//    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
//        // Call the handler with the timeline entries prior to the given date
//        handler(nil)
//    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = CLKComplicationTemplateModularLargeStandardBody()
        template.headerTextProvider = CLKSimpleTextProvider(text: "Расписание")
        template.body1TextProvider = CLKSimpleTextProvider(text: "История")
        template.body2TextProvider = CLKSimpleTextProvider(text: "Каб. 220")
        
        handler(template)
    }
    
}
