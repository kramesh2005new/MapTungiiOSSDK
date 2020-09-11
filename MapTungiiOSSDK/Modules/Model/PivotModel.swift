//
//  PivotModel.swift
//  Mapconfig
//
//  Created by Arunkumar Porchezhiyan on 09/08/20.
//  Copyright © 2020 zvky. All rights reserved.
//

import Foundation

struct PivotModel : Codable {
    let status : Int?
    let message : String?
    let data : Datas?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(Datas.self, forKey: .data)
    }

}

struct PivotPoints : Codable {
    let pivotId : String?
    let heading : String?
    let description : String?
    let deal : String?
    let currentlyhappening : String?
    let imageUrl : String?

    enum CodingKeys: String, CodingKey {

        case pivotId = "pivotId"
        case heading = "heading"
        case description = "description"
        case deal = "deal"
        case currentlyhappening = "currentlyhappening"
        case imageUrl = "imageUrl"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pivotId = try values.decodeIfPresent(String.self, forKey: .pivotId)
        heading = try values.decodeIfPresent(String.self, forKey: .heading)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        deal = try values.decodeIfPresent(String.self, forKey: .deal)
        currentlyhappening = try values.decodeIfPresent(String.self, forKey: .currentlyhappening)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
    }

}

struct Datas : Codable {
    let resortId : Int?
    let resortName : String?
    let pivotPoints : [PivotPoints]?

    enum CodingKeys: String, CodingKey {

        case resortId = "resortId"
        case resortName = "resortName"
        case pivotPoints = "PivotPoints"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resortId = try values.decodeIfPresent(Int.self, forKey: .resortId)
        resortName = try values.decodeIfPresent(String.self, forKey: .resortName)
        pivotPoints = try values.decodeIfPresent([PivotPoints].self, forKey: .pivotPoints)
    }

}

