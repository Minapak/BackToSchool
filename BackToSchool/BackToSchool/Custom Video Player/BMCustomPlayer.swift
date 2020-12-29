//
//  BMCustomPlayer.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit
import BMPlayer

class BMCustomPlayer: BMPlayer {
    override func storyBoardCustomControl() -> BMPlayerControlView? {
        return BMPlayerCustomControlView()
    }
}
