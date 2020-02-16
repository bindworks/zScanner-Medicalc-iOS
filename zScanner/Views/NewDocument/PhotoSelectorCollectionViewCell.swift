//
//  PhotoSelectorCollectionViewCell.swift
//  zScanner
//
//  Created by Jakub Skořepa on 14/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

protocol PhotoSelectorCellDelegate: class {
    func delete(page: Page)
}

// MARK: -
class PhotoSelectorCollectionViewCell: UICollectionViewCell {
    
    // MARK: Instance part
    private var page: Page? {
        didSet {
            imageView.image = page?.image
            textField.text = page?.description
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        page = nil
    }
    
    // MARK: Interface
    func setup(with page: Page, delegate: PhotoSelectorCellDelegate) {
        self.page = page
        self.delegate = delegate
    }
    
    // MARK: Helpers
    private weak var delegate: PhotoSelectorCellDelegate?
    
    @objc private func deleteImage() {
        guard let page = page else { return }
        delegate?.delete(page: page)
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        textField.delegate = self
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.height.equalTo(36)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.top.right.equalToSuperview().inset(4)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
    }
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private var textField : UITextField = {
        let text = UITextField()
        text.placeholder = "newDocumentPhotos.description.placeholder".localized
        text.adjustsFontSizeToFitWidth = true
        text.backgroundColor = .white
        return text
    }()
    
    private var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "delete").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.dropShadow()
        return button
    }()
}

extension PhotoSelectorCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBottomBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setBottomBorder(show: false)
    }
}
