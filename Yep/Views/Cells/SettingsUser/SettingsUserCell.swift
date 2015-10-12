//
//  SettingsUserCell.swift
//  Yep
//
//  Created by NIX on 15/4/24.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class SettingsUserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var introLabel: UILabel!

    @IBOutlet weak var accessoryImageView: UIImageView!

    struct Listener {
        static let Avatar = "SettingsUserCell.Avatar"
        static let Nickname = "SettingsUserCell.Nickname"
        static let Introduction = "SettingsUserCell.Introduction"
    }

    deinit {
        YepUserDefaults.avatarURLString.removeListenerWithName(Listener.Avatar)
        YepUserDefaults.nickname.removeListenerWithName(Listener.Nickname)
        YepUserDefaults.introduction.removeListenerWithName(Listener.Introduction)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let avatarSize = YepConfig.Settings.userCellAvatarSize
        avatarImageViewWidthConstraint.constant = avatarSize

        YepUserDefaults.avatarURLString.bindAndFireListener(Listener.Avatar) { [weak self] _ in
            dispatch_async(dispatch_get_main_queue()) {
                self?.updateAvatar()
            }
        }

        YepUserDefaults.nickname.bindAndFireListener(Listener.Nickname) { [weak self] nickname in
            dispatch_async(dispatch_get_main_queue()) {
                self?.nameLabel.text = nickname
            }
        }

        YepUserDefaults.introduction.bindAndFireListener(Listener.Introduction) { [weak self] introduction in
            dispatch_async(dispatch_get_main_queue()) {
                self?.introLabel.text = introduction
            }
        }

        introLabel.font = YepConfig.Settings.introFont

        accessoryImageView.tintColor = UIColor.yepCellAccessoryImageViewTintColor()
    }

    func updateAvatar() {

        if let avatarURLString = YepUserDefaults.avatarURLString.value {

            let avatarSize = YepConfig.Settings.userCellAvatarSize

            avatarImageView.alpha = 0
            AvatarCache.sharedInstance.roundAvatarWithAvatarURLString(avatarURLString, withRadius: avatarSize * 0.5) { [weak self] image in
                dispatch_async(dispatch_get_main_queue()) {
                    self?.avatarImageView.image = image

                    UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                        self?.avatarImageView.alpha = 1
                    }, completion: { (finished) -> Void in
                    })
                }
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
