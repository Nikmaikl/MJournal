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
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date(timeIntervalSinceNow: 60*60*24))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: (@escaping (CLKComplicationTimelineEntry?) -> Void)) {
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKTimeIntervalTextProvider(start: Date(), end: Date(timeInterval: 60, since: Date()))
        template.body1TextProvider = CLKSimpleTextProvider(text: "История")
        template.body2TextProvider = CLKSimpleTextProvider(text: "Каб. 220")
        
        let entry = CLKComplicationTimelineEntry(date: Date(timeInterval: 60*60 * -0.25, since: Date()), complicationTemplate: template)
        handler(entry)
    }
    
//    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
//        // Call the handler with the timeline entries prior to the given date
//        handler(nil)
//    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = CLKComplicationTemplateModularLargeStandardBody()
        template.headerTextProvider = CLKSimpleTextProvider(text: "Расписание")
        template.body1TextProvider = CLKSimpleTextProvider(text: "История")
        template.body2TextProvider = CLKSimpleTextProvider(text: "Каб. 220")
        
        handler(template)
    }
    
}
