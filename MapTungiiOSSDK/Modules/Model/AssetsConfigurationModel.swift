//
//  MapConfig.swift
//  Mapconfig
//
//  Created by Arunkumar Porchezhiyan on 03/08/20.
//  Copyright © 2020 zvky. All rights reserved.
//

import Foundation

struct AssestsConfigurationModel : Codable {
    let animationFrames : [AnimationFrames]?
    let title : [Title]?
    let pivot : [Pivot]?
    let staticAssets : [StaticAssets]?
    let bgeffects : [Bgeffects]?

    enum CodingKeys: String, CodingKey {

        case animationFrames = "animationFrames"
        case title = "title"
        case pivot = "pivot"
        case staticAssets = "staticAssets"
        case bgeffects = "bgeffects"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        animationFrames = try values.decodeIfPresent([AnimationFrames].self, forKey: .animationFrames)
        title = try values.decodeIfPresent([Title].self, forKey: .title)
        pivot = try values.decodeIfPresent([Pivot].self, forKey: .pivot)
        staticAssets = try values.decodeIfPresent([StaticAssets].self, forKey: .staticAssets)
        bgeffects = try values.decodeIfPresent([Bgeffects].self, forKey: .bgeffects)
    }

}

struct AnimationFrames : Codable {
    let name : String?
    let imgName : String?
    let imgxPosition : Int?
    let imgyPosition : Int?
    let imgheight : Int?
    let imgwidth : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case imgName = "imgName"
        case imgxPosition = "imgxPosition"
        case imgyPosition = "imgyPosition"
        case imgheight = "imgheight"
        case imgwidth = "imgwidth"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        imgName = try values.decodeIfPresent(String.self, forKey: .imgName)
        imgxPosition = try values.decodeIfPresent(Int.self, forKey: .imgxPosition)
        imgyPosition = try values.decodeIfPresent(Int.self, forKey: .imgyPosition)
        imgheight = try values.decodeIfPresent(Int.self, forKey: .imgheight)
        imgwidth = try values.decodeIfPresent(Int.self, forKey: .imgwidth)
    }

}


struct Title : Codable {
    let name : String?
    let xPosition : Int?
    let yPosition : Int?
    let width : Int?
    let height : Int?
    let id : Int?
    let value : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case xPosition = "xPosition"
        case yPosition = "yPosition"
        case width = "width"
        case height = "height"
        case id = "id"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        xPosition = try values.decodeIfPresent(Int.self, forKey: .xPosition)
        yPosition = try values.decodeIfPresent(Int.self, forKey: .yPosition)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
    }

}


struct Pivot : Codable {
    let name : String?
    let btnxPosition : Int?
    let btnyPosition : Int?
    let btnheight : Int?
    let btnwidth : Int?
    let id : Int?
    let xPosition : Int?
    let yPosition : Int?
    let width : Int?
    let height : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case btnxPosition = "btnxPosition"
        case btnyPosition = "btnyPosition"
        case btnheight = "btnheight"
        case btnwidth = "btnwidth"
        case id = "id"
        case xPosition = "xPosition"
        case yPosition = "yPosition"
        case width = "width"
        case height = "height"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        btnxPosition = try values.decodeIfPresent(Int.self, forKey: .btnxPosition)
        btnyPosition = try values.decodeIfPresent(Int.self, forKey: .btnyPosition)
        btnheight = try values.decodeIfPresent(Int.self, forKey: .btnheight)
        btnwidth = try values.decodeIfPresent(Int.self, forKey: .btnwidth)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        xPosition = try values.decodeIfPresent(Int.self, forKey: .xPosition)
        yPosition = try values.decodeIfPresent(Int.self, forKey: .yPosition)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
    }

}


struct Bgeffects : Codable {
    let name : String?
    let imgName : String?
    let xPosition : Int?
    let yPosition : Int?
    let width : Int?
    let height : Int?
    let animate : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case imgName = "imgName"
        case xPosition = "xPosition"
        case yPosition = "yPosition"
        case width = "width"
        case height = "height"
        case animate = "animate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        imgName = try values.decodeIfPresent(String.self, forKey: .imgName)
        xPosition = try values.decodeIfPresent(Int.self, forKey: .xPosition)
        yPosition = try values.decodeIfPresent(Int.self, forKey: .yPosition)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        animate = try values.decodeIfPresent(Int.self, forKey: .animate)
    }

}

struct StaticAssets : Codable {
    let name : String?
    let xPosition : Int?
    let yPosition : Int?
    let width : Int?
    let height : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case xPosition = "xPosition"
        case yPosition = "yPosition"
        case width = "width"
        case height = "height"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        xPosition = try values.decodeIfPresent(Int.self, forKey: .xPosition)
        yPosition = try values.decodeIfPresent(Int.self, forKey: .yPosition)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
    }

}

