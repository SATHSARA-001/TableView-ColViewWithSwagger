//
//  Handlers.swift
//  Relator
//
//  Created by Kumuthan Sivarajah on 8/7/19.
//  Copyright © 2019 Elegant Media Pvt Ltd. All rights reserved.
//

import Foundation

typealias actionHandler = (_ status: Bool, _ message: String) -> ()
typealias completionHandler = (_ status: Bool, _ code: Int, _ message: String) -> ()
