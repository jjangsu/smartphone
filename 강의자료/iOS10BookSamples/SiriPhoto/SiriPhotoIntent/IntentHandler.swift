//
//  IntentHandler.swift
//  SiriPhotoIntent
//
//  Created by Neil Smyth on 10/11/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import Intents
import Photos

class IntentHandler: INExtension, INSearchForPhotosIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
   
    func resolveDateCreated(forSearchForPhotos 
        intent: INSearchForPhotosIntent, 
        with completion: @escaping 
            (INDateComponentsRangeResolutionResult) -> Void) {

        if intent.dateCreated != nil {
            completion(INDateComponentsRangeResolutionResult.success(
                with: intent.dateCreated!))
        } else {
            completion(INDateComponentsRangeResolutionResult.needsValue())
        }
    }

    func resolveAlbumName(forSearchForPhotos intent: INSearchForPhotosIntent, 
        with completion: @escaping (INStringResolutionResult) -> Void) {
        completion(INStringResolutionResult.notRequired())
    }

    func resolvePeopleInPhoto(forSearchForPhotos intent: 
         INSearchForPhotosIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        completion([INPersonResolutionResult.notRequired()])
    }

    func resolveLocationCreated(forSearchForPhotos intent: 
        INSearchForPhotosIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
            completion(INPlacemarkResolutionResult.notRequired())
    }

    func confirm(searchForPhotos intent: INSearchForPhotosIntent, 
        completion: @escaping (INSearchForPhotosIntentResponse) -> Void)
    {
        let response = INSearchForPhotosIntentResponse(code: .ready, 
            userActivity: nil)
        completion(response)
    }

    func handle(searchForPhotos intent: INSearchForPhotosIntent, completion: @escaping (INSearchForPhotosIntentResponse) -> Void) {

        let response = INSearchForPhotosIntentResponse(code: 
            INSearchForPhotosIntentResponseCode.continueInApp, 
                userActivity: nil)

        if intent.dateCreated != nil {
            let calendar = Calendar(identifier: .gregorian)
            let startDate = calendar.date(from: 
            (intent.dateCreated?.startDateComponents)!)
            let endDate = calendar.date(from: 
            (intent.dateCreated?.endDateComponents)!)

            response.searchResultsCount = photoSearchFrom(startDate!, 
                                to: endDate!)
        }
        completion(response)
    }

    func photoSearchFrom(_ startDate: Date, to endDate: Date) -> Int {

        let fetchOptions = PHFetchOptions()

        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate as CVarArg, endDate as CVarArg)
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, 
                options: fetchOptions)
        return fetchResult.count
    }
 
}

