//
//  BMCustomPlayer.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit
import BMPlayer

class BMCustomPlayer: BMPlayer {
    override func storyBoardCustomControl() -> BMPlayerControlView? {
        return BMPlayerCustomControlView()
    }
}
