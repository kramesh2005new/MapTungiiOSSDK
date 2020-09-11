//
//  AssetsModel.swift
//  Mapconfig
//
//  Created by Arunkumar Porchezhiyan on 31/07/20.
//  Copyright © 2020 zvky. All rights reserved.
//

import Foundation

struct AssestsModel : Codable {
    let status : Int?
    let message : String?
    let data : Data?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }

}

struct Data : Codable {
    let resortId : Int?
    let resortName : String?
    let version : Int?
    let staticMapAssets : StaticMapAssets?
    let animationAssets : [AnimationAssets]?

    enum CodingKeys: String, CodingKey {

        case resortId = "resortId"
        case resortName = "resortName"
        case version = "version"
        case staticMapAssets = "staticMapAssets"
        case animationAssets = "animationAssets"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resortId = try values.decodeIfPresent(Int.self, forKey: .resortId)
        resortName = try values.decodeIfPresent(String.self, forKey: .resortName)
        version = try values.decodeIfPresent(Int.self, forKey: .version)
        staticMapAssets = try values.decodeIfPresent(StaticMapAssets.self, forKey: .staticMapAssets)
        animationAssets = try values.decodeIfPresent([AnimationAssets].self, forKey: .animationAssets)
    }
}

struct AnimationAssets : Codable {
    let assetname : String?
    let assetUrl : String?

    enum CodingKeys: String, CodingKey {

        case assetname = "assetname"
        case assetUrl = "assetUrl"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        assetname = try values.decodeIfPresent(String.self, forKey: .assetname)
        assetUrl = try values.decodeIfPresent(String.self, forKey: .assetUrl)
    }

}

struct StaticMapAssets : Codable {
    let assetName : String?
    let assetUrl : String?

    enum CodingKeys: String, CodingKey {

        case assetName = "assetName"
        case assetUrl = "assetUrl"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        assetName = try values.decodeIfPresent(String.self, forKey: .assetName)
        assetUrl = try values.decodeIfPresent(String.self, forKey: .assetUrl)
    }

}
