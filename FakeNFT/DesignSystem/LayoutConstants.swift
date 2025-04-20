//
//  LayoutConstants.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 28.03.2025.
//

import UIKit

enum LayoutConstants {
    static let horizontalPadding: CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 35

    static let imageSizeSmall: CGFloat = 80
    static let imageSizeMedium: CGFloat = 108
    static let avatarSize: CGFloat = 70

    static let starSize: CGFloat = 16
    static let starSpacing: CGFloat = 2

    static let buttonSizeSmall: CGFloat = 30
    static let buttonSizeLarge: CGFloat = 42

    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 7
    static let spacingM: CGFloat = 8
    static let spacingL: CGFloat = 12
    static let spacingXL: CGFloat = 16
    static let spacingXXL: CGFloat = 20
    static let spacingHuge: CGFloat = 24
    static let spacingMassive: CGFloat = 32
    static let spacingExtreme: CGFloat = 40

    static let textFieldInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
}

enum ProfileLayoutConstants {
    static let profileCardTop: CGFloat = LayoutConstants.spacingXXL
    static let tableViewTop: CGFloat = LayoutConstants.spacingExtreme
    static let horizontalPadding: CGFloat = LayoutConstants.horizontalPadding
    static let descriptionTop: CGFloat = LayoutConstants.spacingXXL
    static let websiteButtonTop: CGFloat = LayoutConstants.spacingM
    static let avatarSize: CGFloat = LayoutConstants.avatarSize
    static let avatarCornerRadius: CGFloat = LayoutConstants.cornerRadiusLarge
    static let stackSpacing: CGFloat = LayoutConstants.spacingXL
    static let rowHeight: CGFloat = 54
    static let textFieldCornerRadius: CGFloat = LayoutConstants.cornerRadiusSmall
    static let textFieldInset = LayoutConstants.textFieldInset
    static let closeButtonSize: CGFloat = LayoutConstants.buttonSizeLarge
    static let descriptionHeight: CGFloat = 132
    static let avatarTopOffset: CGFloat = 80
    static let formStackTop: CGFloat = LayoutConstants.spacingMassive
    static let formStackSpacingSmall: CGFloat = LayoutConstants.spacingM
    static let formStackSpacingLarge: CGFloat = LayoutConstants.spacingHuge
}

enum NftCellLayoutConstants {
    static let horizontalPadding: CGFloat = LayoutConstants.horizontalPadding
    static let imageSize: CGFloat = LayoutConstants.imageSizeMedium
    static let imageCornerRadius: CGFloat = LayoutConstants.cornerRadiusSmall

    static let ratingViewSpacing: CGFloat = LayoutConstants.starSpacing

    static let textStackSpacing: CGFloat = LayoutConstants.spacingXS
    static let textStackWidth: CGFloat = 78
    static let textStackToImageSpacing: CGFloat = LayoutConstants.spacingXXL

    static let priceStackSpacing: CGFloat = LayoutConstants.spacingXS
    static let priceStackTrailing: CGFloat = 39
    static let priceStackToTextSpacing: CGFloat = 39
}

enum NftLayoutConstants {
    static let imageSize: CGFloat = LayoutConstants.imageSizeSmall
    static let imageCornerRadius: CGFloat = LayoutConstants.cornerRadiusSmall

    static let likeButtonSize: CGFloat = LayoutConstants.buttonSizeSmall
    static let likeImageSize = CGSize(width: 21, height: 18)

    static let contentPadding: CGFloat = LayoutConstants.spacingS
    static let spacingBetweenImageAndText: CGFloat = LayoutConstants.spacingL

    static let ratingStarSize: CGFloat = LayoutConstants.starSize
    static let ratingStarSpacing: CGFloat = LayoutConstants.starSpacing

    static let nameToRatingSpacing: CGFloat = LayoutConstants.spacingXS
    static let ratingToPriceSpacing: CGFloat = LayoutConstants.spacingM

    static let emptyLabelHorizontalInset: CGFloat = LayoutConstants.horizontalPadding
}


enum FavoritesLayoutConstants {
    static let collectionSectionInset = UIEdgeInsets(
        top: LayoutConstants.spacingXXL,
        left: LayoutConstants.horizontalPadding,
        bottom: LayoutConstants.spacingXXL,
        right: LayoutConstants.horizontalPadding
    )

    static let collectionInterItemSpacing: CGFloat = LayoutConstants.spacingL
    static let collectionLineSpacing: CGFloat = LayoutConstants.spacingXXL

    static let emptyLabelHorizontalInset: CGFloat = LayoutConstants.horizontalPadding
    static let numberOfColumns: CGFloat = 2
    static let cellHeight: CGFloat = LayoutConstants.imageSizeSmall
}
